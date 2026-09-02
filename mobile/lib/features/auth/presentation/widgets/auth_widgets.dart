import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tailor_app/core/network/network_exception.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';
import 'package:tailor_app/shared/widgets/pastel_page_background.dart';

enum AuthErrorScope { login, phone, registration, otp, password, general }

String localizedAuthError(
  BuildContext context,
  Object error,
  AuthErrorScope scope,
) {
  final l10n = context.l10n;
  if (error is! NetworkException) return l10n.authUnexpectedError;
  if (error.statusCode == null) return l10n.authNetworkError;
  if (error.statusCode == 429) return l10n.authTooManyRequests;
  if (error.statusCode! >= 500) return l10n.authUnexpectedError;

  return switch (scope) {
    AuthErrorScope.login => l10n.authInvalidCredentials,
    AuthErrorScope.phone => l10n.authPhoneRequestFailed,
    AuthErrorScope.registration => l10n.authRegistrationFailed,
    AuthErrorScope.otp => l10n.authOtpInvalid,
    AuthErrorScope.password => l10n.authPasswordResetFailed,
    AuthErrorScope.general => l10n.authUnexpectedError,
  };
}

void showAuthSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
}

class AuthPageScaffold extends StatelessWidget {
  const AuthPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    required this.child,
    this.showBack = true,
  });

  final String title;
  final String subtitle;
  final String iconAsset;
  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const PastelPageBackground(),
          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 42,
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: showBack
                              ? IconButton(
                                  tooltip: MaterialLocalizations.of(context)
                                      .backButtonTooltip,
                                  onPressed: () =>
                                      Navigator.of(context).maybePop(),
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  color: AppColors.ink,
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size.square(38),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 66,
                          height: 66,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primaryLight,
                                AppColors.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(21),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x325F33E1),
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: AuthSvgIcon(
                            assetName: iconAsset,
                            size: 29,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x365F33E1),
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 48,
            child: Center(
              child: loading
                  ? const SizedBox.square(
                      dimension: 21,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge
                          ?.copyWith(color: Colors.white, fontSize: 14),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthSvgIcon extends StatelessWidget {
  const AuthSvgIcon({
    super.key,
    required this.assetName,
    this.size = 19,
    this.color = AppColors.mutedInk,
  });

  final String assetName;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      excludeFromSemantics: true,
    );
  }
}

class AuthFieldIcon extends StatelessWidget {
  const AuthFieldIcon(this.assetName, {super.key});

  final String assetName;

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: AuthSvgIcon(assetName: assetName),
    );
  }
}

class DevelopmentOtpNotice extends StatelessWidget {
  const DevelopmentOtpNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.lavender.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              context.l10n.authDevelopmentOtpHint,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.primaryDark, fontSize: 11.5),
            ),
          ),
        ],
      ),
    );
  }
}
