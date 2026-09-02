import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';
import 'package:tailor_app/features/auth/data/auth_repository.dart';
import 'package:tailor_app/features/auth/domain/phone_number.dart';
import 'package:tailor_app/features/auth/presentation/widgets/auth_flow_widgets.dart';
import 'package:tailor_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialPhone});

  final String? initialPhone;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  bool _loading = false;
  String? _submissionError;

  @override
  void initState() {
    super.initState();
    final initialPhone = widget.initialPhone ?? '';
    _phoneController = TextEditingController(text: initialPhone)
      ..selection = TextSelection.collapsed(offset: initialPhone.length);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _submissionError = null;
    });

    try {
      final phone = PhoneNumber.normalize(_phoneController.text)!;
      final challenge = await ref
          .read(authRepositoryProvider)
          .requestPasswordOtp(phone);
      if (!mounted) return;

      await context.push(
        '/forgot-password/otp',
        extra: PasswordOtpDraft(
          challengeId: challenge.challengeId,
          phoneE164: phone,
          expiresAt: challenge.expiresAt,
          resendAt: challenge.resendAt,
        ),
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _submissionError = localizedAuthError(
            context,
            error,
            AuthErrorScope.phone,
          );
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthFlowScaffold(
      title: l10n.resetPassword,
      subtitle: l10n.resetPasswordSubtitle,
      iconAsset: 'assets/icons/lock.svg',
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const ValueKey('forgot-phone-field'),
              controller: _phoneController,
              autofocus: true,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              textDirection: TextDirection.ltr,
              autofillHints: const [AutofillHints.telephoneNumber],
              decoration: authFieldDecoration(
                labelText: l10n.whatsAppPhone,
                hintText: l10n.phoneHint,
                prefixIcon: const AuthFieldLeadingIcon(
                  assetName: 'assets/icons/profile.svg',
                ),
              ),
              validator: (value) {
                if (value?.trim().isEmpty ?? true) return l10n.phoneRequired;
                return PhoneNumber.normalize(value!) == null
                    ? l10n.phoneInvalid
                    : null;
              },
              onChanged: (_) {
                if (_submissionError != null) {
                  setState(() => _submissionError = null);
                }
              },
              onFieldSubmitted: (_) => _continue(),
            ),
            const SizedBox(height: 12),
            AuthSupportingText(
              l10n.passwordOtpPrivacyNotice,
              textAlign: TextAlign.center,
            ),
            if (_submissionError != null) ...[
              const SizedBox(height: 16),
              AuthInlineError(_submissionError!),
              const SizedBox(height: 16),
            ] else
              const SizedBox(height: 24),
            AuthPrimaryActionButton(
              key: const ValueKey('forgot-continue-button'),
              label: l10n.sendVerificationCode,
              loading: _loading,
              onPressed: _continue,
            ),
          ],
        ),
      ),
    );
  }
}
