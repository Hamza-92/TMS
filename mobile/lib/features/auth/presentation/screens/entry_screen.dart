import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/localization/app_locale.dart';
import 'package:tailor_app/core/storage/secure_storage_service.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';

class EntryScreen extends ConsumerStatefulWidget {
  const EntryScreen({super.key});

  @override
  ConsumerState<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends ConsumerState<EntryScreen> {
  static const _introDuration = Duration(seconds: 2);
  static const _motionDuration = Duration(milliseconds: 720);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _showForm = false;
  bool _obscurePassword = true;
  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    unawaited(_resolveDestination());
  }

  Future<void> _resolveDestination() async {
    final startedAt = DateTime.now();
    String? token;

    try {
      token = await ref.read(secureStorageProvider).readAccessToken();
    } catch (_) {
      token = null;
    }

    if (!mounted) return;

    if (token?.trim().isNotEmpty ?? false) {
      context.go('/dashboard');
      return;
    }

    final elapsed = DateTime.now().difference(startedAt);
    if (elapsed < _introDuration) {
      await Future<void>.delayed(_introDuration - elapsed);
    }

    if (mounted) {
      setState(() => _showForm = true);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    _hasSubmitted = true;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.authNotConnected),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
  }

  Future<void> _selectLocale(AppLocale locale) async {
    await ref.read(localeProvider.notifier).select(locale);
    if (!mounted || !_hasSubmitted) return;
    _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardOpen = mediaQuery.viewInsets.bottom > 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.canvas,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: _EntryBackground(
          child: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxHeight < 700 || keyboardOpen;
                    final expandedArtworkHeight = (constraints.maxHeight * 0.57)
                        .clamp(330.0, 470.0);
                    final compactArtworkHeight = compact ? 172.0 : 218.0;

                    return SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 34,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420),
                            child: Column(
                              mainAxisAlignment: _showForm
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  key: const ValueKey(
                                    'tailor-artwork-container',
                                  ),
                                  duration: _motionDuration,
                                  curve: Curves.easeInOutCubicEmphasized,
                                  height: _showForm
                                      ? compactArtworkHeight
                                      : expandedArtworkHeight,
                                  child: const _TailorArtwork(),
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 420),
                                  reverseDuration: const Duration(
                                    milliseconds: 260,
                                  ),
                                  transitionBuilder: (child, animation) =>
                                      FadeTransition(
                                        opacity: animation,
                                        child: SizeTransition(
                                          sizeFactor: animation,
                                          alignment: Alignment.topCenter,
                                          child: child,
                                        ),
                                      ),
                                  child: _showForm
                                      ? const SizedBox(
                                          key: ValueKey('intro-collapsed'),
                                          height: 8,
                                        )
                                      : const _IntroCopy(
                                          key: ValueKey('intro-copy'),
                                        ),
                                ),
                                AnimatedSwitcher(
                                  duration: _motionDuration,
                                  switchInCurve: Curves.easeOutCubic,
                                  transitionBuilder: (child, animation) {
                                    final slide = Tween<Offset>(
                                      begin: const Offset(0, 0.12),
                                      end: Offset.zero,
                                    ).animate(animation);
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: slide,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: _showForm
                                      ? _LoginCard(
                                          key: const ValueKey('login-card'),
                                          formKey: _formKey,
                                          emailController: _emailController,
                                          passwordController:
                                              _passwordController,
                                          passwordFocus: _passwordFocus,
                                          obscurePassword: _obscurePassword,
                                          onTogglePassword: () => setState(
                                            () => _obscurePassword =
                                                !_obscurePassword,
                                          ),
                                          onSubmit: _submit,
                                        )
                                      : const SizedBox(
                                          key: ValueKey('login-placeholder'),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                PositionedDirectional(
                  top: 4,
                  end: 4,
                  child: _LanguageButton(
                    selectedLocale: ref.watch(localeProvider),
                    onSelected: _selectLocale,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.selectedLocale,
    required this.onSelected,
  });

  final AppLocale selectedLocale;
  final ValueChanged<AppLocale> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppLocale>(
      key: const ValueKey('language-button'),
      tooltip: context.l10n.language,
      onSelected: onSelected,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 4),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 3,
      shadowColor: AppColors.ink.withValues(alpha: 0.12),
      constraints: const BoxConstraints(minWidth: 142, maxWidth: 158),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      menuPadding: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      itemBuilder: (context) => [
        for (final locale in AppLocale.values)
          PopupMenuItem<AppLocale>(
            value: locale,
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _localeNativeLabel(locale),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: locale == selectedLocale
                          ? AppColors.primaryDark
                          : AppColors.ink,
                      fontSize: 13,
                      fontWeight: locale == selectedLocale
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (locale == selectedLocale)
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox.square(dimension: 6),
                  ),
              ],
            ),
          ),
      ],
      icon: const _IconlyIcon(
        assetName: 'assets/icons/language_globe.svg',
        size: 22,
        color: AppColors.mutedInk,
      ),
    );
  }
}

String _localeNativeLabel(AppLocale locale) => switch (locale) {
  AppLocale.english => 'English',
  AppLocale.urdu => 'اردو',
  AppLocale.romanUrdu => 'Roman Urdu',
};

class _EntryBackground extends StatelessWidget {
  const _EntryBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFAFFFD), AppColors.canvas, Color(0xFFFFFCF4)],
              stops: [0, 0.56, 1],
            ),
          ),
        ),
        const Positioned(
          top: -90,
          right: -80,
          child: _PastelGlow(size: 250, color: AppColors.lavender),
        ),
        const Positioned(
          bottom: 120,
          left: -100,
          child: _PastelGlow(size: 240, color: AppColors.mint),
        ),
        const Positioned(
          bottom: -110,
          right: -80,
          child: _PastelGlow(size: 260, color: AppColors.blush),
        ),
        child,
      ],
    );
  }
}

class _PastelGlow extends StatelessWidget {
  const _PastelGlow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.72), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _TailorArtwork extends StatelessWidget {
  const _TailorArtwork();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.tailorIllustrationLabel,
      image: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.58,
                  colors: [
                    AppColors.lavender.withValues(alpha: 0.52),
                    AppColors.lavender.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 34,
            child: _DecorativeDot(color: Color(0xFF7EDCF4), size: 10),
          ),
          Positioned(
            left: 38,
            bottom: 36,
            child: _DecorativeDot(color: Color(0xFFFF8CB3), size: 9),
          ),
          Positioned(
            right: 66,
            bottom: 22,
            child: _DecorativeDot(color: Color(0xFFFFD548), size: 7),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Image.asset(
              'assets/images/tailor_welcome.webp',
              key: const ValueKey('tailor-illustration'),
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeDot extends StatelessWidget {
  const _DecorativeDot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: SizedBox.square(dimension: size),
      ),
    );
  }
}

class _IntroCopy extends StatelessWidget {
  const _IntroCopy({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 16),
      child: Column(
        children: [
          Text(
            'Tailor Manager',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '—  آپ کا کام، ہماری ذمہ داری  —',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Manage your customers, measurements,\norders and payments with ease.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(fontSize: 13, height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.passwordFocus,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocus;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.welcomeBack,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('login-identifier-field'),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              autofillHints: const [
                AutofillHints.username,
                AutofillHints.email,
                AutofillHints.telephoneNumber,
              ],
              decoration: InputDecoration(
                labelText: l10n.loginIdentifier,
                hintText: l10n.loginIdentifierHint,
                prefixIcon: const _FieldIcon(
                  assetName: 'assets/icons/profile.svg',
                ),
              ),
              validator: (value) {
                final identifier = value?.trim() ?? '';
                if (identifier.isEmpty) return l10n.loginIdentifierRequired;
                if (!_isValidLoginIdentifier(identifier)) {
                  return l10n.loginIdentifierInvalid;
                }
                return null;
              },
              onFieldSubmitted: (_) => passwordFocus.requestFocus(),
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: const ValueKey('password-field'),
              controller: passwordController,
              focusNode: passwordFocus,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              decoration: InputDecoration(
                labelText: l10n.password,
                hintText: l10n.passwordHint,
                prefixIcon: const _FieldIcon(
                  assetName: 'assets/icons/lock.svg',
                ),
                suffixIcon: IconButton(
                  tooltip: obscurePassword
                      ? l10n.showPassword
                      : l10n.hidePassword,
                  onPressed: onTogglePassword,
                  icon: _IconlyIcon(
                    assetName: obscurePassword
                        ? 'assets/icons/show.svg'
                        : 'assets/icons/hide.svg',
                    size: 19,
                    color: AppColors.mutedInk,
                  ),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return l10n.passwordRequired;
                if (value!.length < 6) return l10n.passwordTooShort;
                return null;
              },
              onFieldSubmitted: (_) => onSubmit(),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(l10n.authNotConnected),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                ),
                child: Text(
                  l10n.forgotPassword,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 1),
            _GradientButton(
              key: const ValueKey('sign-in-button'),
              label: l10n.signIn,
              onPressed: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

bool _isValidLoginIdentifier(String value) {
  final isEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  final normalizedPhone = value.replaceAll(RegExp(r'[\s()\-]'), '');
  final isPhone = RegExp(r'^\+?\d{7,15}$').hasMatch(normalizedPhone);
  return isEmail || isPhone;
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x426431EC),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Text(
                label,
                textAlign: TextAlign.center,
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

class _FieldIcon extends StatelessWidget {
  const _FieldIcon({required this.assetName});

  final String assetName;

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: _IconlyIcon(
        assetName: assetName,
        size: 19,
        color: AppColors.mutedInk,
      ),
    );
  }
}

class _IconlyIcon extends StatelessWidget {
  const _IconlyIcon({
    required this.assetName,
    required this.size,
    required this.color,
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
