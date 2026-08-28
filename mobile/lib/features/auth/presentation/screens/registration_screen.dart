import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/localization/app_locale.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';
import 'package:tailor_app/features/auth/data/auth_repository.dart';
import 'package:tailor_app/features/auth/domain/phone_number.dart';
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
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _businessController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final phone = PhoneNumber.normalize(_phoneController.text)!;
    setState(() => _loading = true);

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
      title: l10n.createAccount,
      subtitle: l10n.createAccountSubtitle,
      iconAsset: 'assets/icons/add_user.svg',
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const ValueKey('registration-name-field'),
              controller: _nameController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              decoration: InputDecoration(
                labelText: l10n.fullName,
                hintText: l10n.fullNameHint,
                prefixIcon: const AuthFieldIcon('assets/icons/profile.svg'),
              ),
              validator: (value) => (value?.trim().length ?? 0) < 2
                  ? l10n.fullNameRequired
                  : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const ValueKey('registration-business-field'),
              controller: _businessController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.businessName,
                hintText: l10n.businessNameHint,
                prefixIcon: const AuthFieldIcon('assets/icons/work.svg'),
              ),
              validator: (value) => (value?.trim().length ?? 0) < 2
                  ? l10n.businessNameRequired
                  : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const ValueKey('registration-phone-field'),
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
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
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const ValueKey('registration-password-field'),
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: l10n.password,
                hintText: l10n.passwordHint,
                prefixIcon: const AuthFieldIcon('assets/icons/lock.svg'),
                suffixIcon: IconButton(
                  tooltip: _obscurePassword
                      ? l10n.showPassword
                      : l10n.hidePassword,
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: AuthSvgIcon(
                    assetName: _obscurePassword
                        ? 'assets/icons/show.svg'
                        : 'assets/icons/hide.svg',
                  ),
                ),
              ),
              validator: (value) => _validPassword(value ?? '')
                  ? null
                  : l10n.passwordRequirements,
            ),
            const SizedBox(height: 10),
            TextFormField(
              key: const ValueKey('registration-confirm-password-field'),
              controller: _confirmPasswordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: l10n.confirmPassword,
                hintText: l10n.confirmPasswordHint,
                prefixIcon: const AuthFieldIcon('assets/icons/lock.svg'),
              ),
              validator: (value) => value != _passwordController.text
                  ? l10n.passwordsDoNotMatch
                  : null,
              onFieldSubmitted: (_) => _continue(),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.registrationTermsNotice,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontSize: 10.5, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 16),
            AuthPrimaryButton(
              key: const ValueKey('registration-continue-button'),
              label: l10n.continueLabel,
              loading: _loading,
              onPressed: _continue,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loading ? null : () => context.pop(),
              child: Text(l10n.alreadyHaveAccount),
            ),
          ],
        ),
      ),
    );
  }
}

bool _validPassword(String value) {
  return value.length >= 8 &&
      RegExp('[A-Za-z]').hasMatch(value) &&
      RegExp(r'\d').hasMatch(value);
}
