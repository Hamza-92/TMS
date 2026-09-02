import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/features/auth/application/auth_controller.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';
import 'package:tailor_app/features/auth/presentation/widgets/auth_flow_widgets.dart';
import 'package:tailor_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';

class LoginPasswordScreen extends ConsumerStatefulWidget {
  const LoginPasswordScreen({super.key, required this.draft});

  final LoginDraft draft;

  @override
  ConsumerState<LoginPasswordScreen> createState() =>
      _LoginPasswordScreenState();
}

class _LoginPasswordScreenState extends ConsumerState<LoginPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;
  String? _submissionError;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _loading = true;
      _submissionError = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(
            phoneE164: widget.draft.phoneE164,
            password: _passwordController.text,
          );
      if (mounted) context.go('/dashboard');
    } catch (error) {
      if (mounted) {
        setState(() {
          _submissionError = localizedAuthError(
            context,
            error,
            AuthErrorScope.login,
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
      title: l10n.enterPasswordTitle,
      subtitle: l10n.signingInAs(isolateLtrText(widget.draft.phoneE164)),
      iconAsset: 'assets/icons/lock.svg',
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const ValueKey('login-password-field'),
              controller: _passwordController,
              autofocus: true,
              obscureText: _obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              autocorrect: false,
              enableSuggestions: false,
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
              validator: (value) =>
                  value?.isNotEmpty == true ? null : l10n.passwordRequired,
              onChanged: (_) {
                if (_submissionError != null) {
                  setState(() => _submissionError = null);
                }
              },
              onFieldSubmitted: (_) => _signIn(),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                key: const ValueKey('login-forgot-password'),
                onPressed: _loading
                    ? null
                    : () => context.push(
                        '/forgot-password',
                        extra: widget.draft.phoneE164,
                      ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 10,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(l10n.forgotPassword),
              ),
            ),
            if (_submissionError != null) ...[
              const SizedBox(height: 6),
              AuthInlineError(_submissionError!),
              const SizedBox(height: 14),
            ] else
              const SizedBox(height: 20),
            AuthPrimaryActionButton(
              key: const ValueKey('login-submit-button'),
              label: l10n.signIn,
              loading: _loading,
              onPressed: _signIn,
            ),
          ],
        ),
      ),
    );
  }
}
