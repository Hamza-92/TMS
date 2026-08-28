import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';
import 'package:tailor_app/features/auth/data/auth_repository.dart';
import 'package:tailor_app/features/auth/domain/phone_number.dart';
import 'package:tailor_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);

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
        showAuthSnackBar(
          context,
          localizedAuthError(context, error, AuthErrorScope.phone),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthPageScaffold(
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
              decoration: InputDecoration(
                labelText: l10n.whatsAppPhone,
                hintText: l10n.phoneHint,
                prefixIcon: const AuthFieldIcon('assets/icons/profile.svg'),
              ),
              validator: (value) => PhoneNumber.normalize(value ?? '') == null
                  ? l10n.phoneInvalid
                  : null,
              onFieldSubmitted: (_) => _continue(),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.passwordOtpPrivacyNotice,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontSize: 11.5, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            AuthPrimaryButton(
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
