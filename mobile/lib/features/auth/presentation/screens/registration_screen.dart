import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/localization/app_locale.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';
import 'package:tailor_app/features/auth/data/auth_repository.dart';
import 'package:tailor_app/features/auth/domain/phone_number.dart';
import 'package:tailor_app/features/auth/presentation/widgets/auth_flow_widgets.dart';
import 'package:tailor_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _businessController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  bool _loading = false;
  String? _submissionError;

  @override
  void dispose() {
    _nameController.dispose();
    _businessController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearSubmissionError() {
    if (_submissionError != null) {
      setState(() => _submissionError = null);
    }
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final phone = PhoneNumber.normalize(_phoneController.text)!;
    setState(() {
      _loading = true;
      _submissionError = null;
    });

    try {
      final repository = ref.read(authRepositoryProvider);
      final installationUuid = await repository.installationUuid();
      final challenge = await repository.requestRegistrationOtp(phone);
      if (!mounted) return;

      final draft = RegistrationDraft(
        challengeId: challenge.challengeId,
        name: _nameController.text.trim(),
        businessName: _businessController.text.trim(),
        phoneE164: phone,
        password: _passwordController.text,
        preferredLocale: ref.read(localeProvider).apiCode,
        installationUuid: installationUuid,
        expiresAt: challenge.expiresAt,
        resendAt: challenge.resendAt,
      );
      await context.push('/register/otp', extra: draft);
    } catch (error) {
      if (mounted) {
        setState(() {
          _submissionError = localizedAuthError(
            context,
            error,
            AuthErrorScope.registration,
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
      title: l10n.createAccount,
      subtitle: l10n.createAccountSubtitle,
      iconAsset: 'assets/icons/add_user.svg',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const ValueKey('registration-name-field'),
              controller: _nameController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              inputFormatters: [LengthLimitingTextInputFormatter(120)],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: authFieldDecoration(
                labelText: l10n.fullName,
                hintText: l10n.fullNameHint,
                prefixIcon: const AuthFieldLeadingIcon(
                  assetName: 'assets/icons/profile.svg',
                ),
              ),
              validator: (value) {
                final name = value?.trim() ?? '';
                if (name.isEmpty) return l10n.fullNameRequired;
                return name.length < 2 ? l10n.fullNameTooShort : null;
              },
              onChanged: (_) => _clearSubmissionError(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('registration-business-field'),
              controller: _businessController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [LengthLimitingTextInputFormatter(160)],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: authFieldDecoration(
                labelText: l10n.businessName,
                hintText: l10n.businessNameHint,
                prefixIcon: const AuthFieldLeadingIcon(
                  assetName: 'assets/icons/work.svg',
                ),
              ),
              validator: (value) {
                final name = value?.trim() ?? '';
                if (name.isEmpty) return l10n.businessNameRequired;
                return name.length < 2 ? l10n.businessNameTooShort : null;
              },
              onChanged: (_) => _clearSubmissionError(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('registration-phone-field'),
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              textDirection: TextDirection.ltr,
              autofillHints: const [AutofillHints.telephoneNumber],
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
              onChanged: (_) => _clearSubmissionError(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('registration-password-field'),
              controller: _passwordController,
              obscureText: _obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              autocorrect: false,
              enableSuggestions: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: authFieldDecoration(
                labelText: l10n.password,
                hintText: l10n.passwordHint,
                prefixIcon: const AuthFieldLeadingIcon(
                  assetName: 'assets/icons/lock.svg',
                ),
                suffixIcon: IconButton(
                  tooltip: _obscurePassword
                      ? l10n.showPassword
                      : l10n.hidePassword,
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: AuthFlowIcon(
                    assetName: _obscurePassword
                        ? 'assets/icons/show.svg'
                        : 'assets/icons/hide.svg',
                  ),
                ),
              ),
              validator: (value) {
                final password = value ?? '';
                if (password.isEmpty) return l10n.passwordRequired;
                if (password.length < 8) return l10n.passwordTooShort;
                return _hasLetterAndNumber(password)
                    ? null
                    : l10n.passwordLetterAndNumberRequired;
              },
              onChanged: (_) {
                _clearSubmissionError();
                if (_confirmPasswordController.text.isNotEmpty) {
                  _formKey.currentState?.validate();
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('registration-confirm-password-field'),
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmation,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              autocorrect: false,
              enableSuggestions: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: authFieldDecoration(
                labelText: l10n.confirmPassword,
                hintText: l10n.confirmPasswordHint,
                prefixIcon: const AuthFieldLeadingIcon(
                  assetName: 'assets/icons/lock.svg',
                ),
                suffixIcon: IconButton(
                  tooltip: _obscureConfirmation
                      ? l10n.showPassword
                      : l10n.hidePassword,
                  onPressed: () => setState(
                    () => _obscureConfirmation = !_obscureConfirmation,
                  ),
                  icon: AuthFlowIcon(
                    assetName: _obscureConfirmation
                        ? 'assets/icons/show.svg'
                        : 'assets/icons/hide.svg',
                  ),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return l10n.confirmPasswordRequired;
                }
                return value != _passwordController.text
                    ? l10n.passwordsDoNotMatch
                    : null;
              },
              onChanged: (_) => _clearSubmissionError(),
              onFieldSubmitted: (_) => _continue(),
            ),
            const SizedBox(height: 12),
            AuthSupportingText(
              l10n.registrationTermsNotice,
              textAlign: TextAlign.center,
            ),
            if (_submissionError != null) ...[
              const SizedBox(height: 16),
              AuthInlineError(_submissionError!),
            ],
            const SizedBox(height: 24),
            AuthPrimaryActionButton(
              key: const ValueKey('registration-continue-button'),
              label: l10n.continueLabel,
              loading: _loading,
              onPressed: _continue,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _loading ? null : () => context.go('/login/phone'),
              child: Text(l10n.alreadyHaveAccount),
            ),
          ],
        ),
      ),
    );
  }
}

bool _hasLetterAndNumber(String value) =>
    RegExp('[A-Za-z]').hasMatch(value) && RegExp(r'\d').hasMatch(value);
