import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';
import 'package:tailor_app/features/auth/data/auth_repository.dart';
import 'package:tailor_app/features/auth/presentation/widgets/auth_flow_widgets.dart';
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
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  bool _loading = false;
  String? _submissionError;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _submissionError = null;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .resetPassword(
            draft: widget.draft,
            password: _passwordController.text,
          );
      if (!mounted) return;
      showAuthStatusSheet(context, context.l10n.passwordChangedSuccess);
      context.go('/login/phone');
    } catch (error) {
      if (mounted) {
        setState(() {
          _submissionError = localizedAuthError(
            context,
            error,
            AuthErrorScope.password,
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
      title: l10n.chooseNewPassword,
      subtitle: l10n.chooseNewPasswordSubtitle,
      iconAsset: 'assets/icons/lock.svg',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const ValueKey('reset-password-field'),
              controller: _passwordController,
              autofocus: true,
              obscureText: _obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              autocorrect: false,
              enableSuggestions: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: authFieldDecoration(
                labelText: l10n.newPassword,
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
                if (_submissionError != null) {
                  setState(() => _submissionError = null);
                }
                if (_confirmController.text.isNotEmpty) {
                  _formKey.currentState?.validate();
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('reset-confirm-password-field'),
              controller: _confirmController,
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
              onChanged: (_) {
                if (_submissionError != null) {
                  setState(() => _submissionError = null);
                }
              },
              onFieldSubmitted: (_) => _reset(),
            ),
            if (_submissionError != null) ...[
              const SizedBox(height: 16),
              AuthInlineError(_submissionError!),
              const SizedBox(height: 16),
            ] else
              const SizedBox(height: 24),
            AuthPrimaryActionButton(
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

bool _hasLetterAndNumber(String value) =>
    RegExp('[A-Za-z]').hasMatch(value) && RegExp(r'\d').hasMatch(value);
