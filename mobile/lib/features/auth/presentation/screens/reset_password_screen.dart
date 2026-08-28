import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';
import 'package:tailor_app/features/auth/data/auth_repository.dart';
import 'package:tailor_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, required this.draft});

  final PasswordResetDraft draft;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);

    try {
      await ref
          .read(authRepositoryProvider)
          .resetPassword(
            draft: widget.draft,
            password: _passwordController.text,
          );
      if (!mounted) return;
      showAuthSnackBar(context, context.l10n.passwordChangedSuccess);
      context.go('/');
    } catch (error) {
      if (mounted) {
        showAuthSnackBar(
          context,
          localizedAuthError(context, error, AuthErrorScope.password),
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
      title: l10n.chooseNewPassword,
      subtitle: l10n.chooseNewPasswordSubtitle,
      iconAsset: 'assets/icons/lock.svg',
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const ValueKey('reset-password-field'),
              controller: _passwordController,
              autofocus: true,
              obscureText: _obscure,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: l10n.newPassword,
                hintText: l10n.passwordHint,
                prefixIcon: const AuthFieldIcon('assets/icons/lock.svg'),
                suffixIcon: IconButton(
                  tooltip: _obscure ? l10n.showPassword : l10n.hidePassword,
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: AuthSvgIcon(
                    assetName: _obscure
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
              key: const ValueKey('reset-confirm-password-field'),
              controller: _confirmController,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: l10n.confirmPassword,
                hintText: l10n.confirmPasswordHint,
                prefixIcon: const AuthFieldIcon('assets/icons/lock.svg'),
              ),
              validator: (value) => value != _passwordController.text
                  ? l10n.passwordsDoNotMatch
                  : null,
              onFieldSubmitted: (_) => _reset(),
            ),
            const SizedBox(height: 20),
            AuthPrimaryButton(
              key: const ValueKey('reset-password-button'),
              label: l10n.updatePassword,
              loading: _loading,
              onPressed: _reset,
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
