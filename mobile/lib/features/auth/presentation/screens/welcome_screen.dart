import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/features/auth/presentation/widgets/auth_flow_widgets.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.primaryDark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        key: const ValueKey('welcome-root'),
        backgroundColor: AppColors.primaryDark,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [AppColors.primaryLight, AppColors.primaryDark],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                const Positioned(top: -92, right: -82, child: _WelcomeRings()),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Column(
                          children: [
                            const Expanded(child: _ResponsiveWelcomeArtwork()),
                            const SizedBox(height: 10),
                            Text(
                              context.l10n.welcomeToTailorManager,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                height: 1.18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              context.l10n.introTagline,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.88),
                                fontSize: 14,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 24),
                            AuthPrimaryActionButton(
                              key: const ValueKey('welcome-login-button'),
                              label: context.l10n.signIn,
                              inverted: true,
                              onPressed: () => context.push('/login/phone'),
                            ),
                            const SizedBox(height: 4),
                            TextButton(
                              key: const ValueKey('welcome-create-account'),
                              onPressed: () => context.push('/register'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(44),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              child: Text(context.l10n.createAccount),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const PositionedDirectional(
                  top: 2,
                  end: 8,
                  child: AuthLanguageButton(onDark: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResponsiveWelcomeArtwork extends StatelessWidget {
  const _ResponsiveWelcomeArtwork();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final diameter = math.min(
          constraints.maxWidth * 0.84,
          constraints.maxHeight * 0.98,
        );

        return Center(
          child: SizedBox.square(
            dimension: diameter,
            child: Stack(
              alignment: Alignment.center,
              children: [
                for (final factor in [1.0, 0.76, 0.52])
                  Container(
                    width: diameter * factor,
                    height: diameter * factor,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(
                        alpha: factor == 0.52 ? 0.10 : 0.04,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.09),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(diameter * 0.035),
                  child: Image.asset(
                    'assets/images/tailor_welcome.webp',
                    key: const ValueKey('welcome-tailor-illustration'),
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WelcomeRings extends StatelessWidget {
  const _WelcomeRings();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final size in [220.0, 166.0, 112.0])
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
            ),
        ],
      ),
    );
  }
}
