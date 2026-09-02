import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tailor_app/core/localization/app_locale.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';

abstract final class AuthFlowMetrics {
  static const headerHeight = 266.0;
  static const badgeSize = 100.0;
  static const contentTop = headerHeight + badgeSize;
  static const horizontalPadding = 20.0;
  static const maxContentWidth = 400.0;
  static const fieldRadius = 10.0;
  static const controlHeight = 56.0;
}

String isolateLtrText(String value) => '\u2066$value\u2069';

class AuthFlowScaffold extends StatelessWidget {
  const AuthFlowScaffold({
    super.key,
    required this.title,
    required this.iconAsset,
    required this.child,
    this.subtitle,
    this.showBack = true,
    this.showLanguage = true,
  });

  final String title;
  final String? subtitle;
  final String iconAsset;
  final Widget child;
  final bool showBack;
  final bool showLanguage;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              key: const ValueKey('auth-flow-scroll'),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(bottom: media.viewPadding.bottom + 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    SizedBox(
                      height: AuthFlowMetrics.contentTop,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: AuthFlowMetrics.headerHeight,
                            child: _AuthGradientHeader(
                              title: title,
                              subtitle: subtitle,
                              showBack: showBack,
                              showLanguage: showLanguage,
                            ),
                          ),
                          Positioned(
                            top:
                                AuthFlowMetrics.headerHeight -
                                (AuthFlowMetrics.badgeSize / 2),
                            left: 0,
                            right: 0,
                            child: Center(
                              child: AuthHeaderBadge(iconAsset: iconAsset),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AuthFlowMetrics.horizontalPadding,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: AuthFlowMetrics.maxContentWidth,
                          ),
                          child: child,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthGradientHeader extends StatelessWidget {
  const _AuthGradientHeader({
    required this.title,
    required this.subtitle,
    required this.showBack,
    required this.showLanguage,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final bool showLanguage;

  @override
  Widget build(BuildContext context) {
    // `Scaffold` can consume `MediaQuery.padding`, making its top value zero.
    // `viewPadding` preserves the physical safe-area inset so these controls
    // align with the welcome screen on every status-bar/cutout configuration.
    final controlTop = MediaQuery.viewPaddingOf(context).top + 2;

    return ClipRRect(
      key: const ValueKey('auth-header'),
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [AppColors.primaryLight, AppColors.primaryDark],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(top: -88, right: -74, child: _HeaderRings()),
            PositionedDirectional(
              top: controlTop,
              start: 8,
              child: showBack
                  ? IconButton(
                      key: const ValueKey('auth-back-button'),
                      tooltip: MaterialLocalizations.of(context)
                          .backButtonTooltip,
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded, size: 24),
                      color: Colors.white,
                    )
                  : const SizedBox.square(dimension: 48),
            ),
            if (showLanguage)
              PositionedDirectional(
                top: controlTop,
                end: 8,
                child: const AuthLanguageButton(onDark: true),
              ),
            Positioned(
              left: AuthFlowMetrics.horizontalPadding,
              right: AuthFlowMetrics.horizontalPadding,
              top: 136,
              child: Column(
                children: [
                  FittedBox(
                    key: const ValueKey('auth-header-title'),
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      maxLines: 1,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        height: 1.18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (subtitle?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 8),
                    Text(
                      key: const ValueKey('auth-header-subtitle'),
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 14,
                        height: 1.35,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderRings extends StatelessWidget {
  const _HeaderRings();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final size in [210.0, 158.0, 108.0])
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
            ),
        ],
      ),
    );
  }
}

class AuthHeaderBadge extends StatelessWidget {
  const AuthHeaderBadge({super.key, required this.iconAsset});

  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('auth-header-badge'),
      width: AuthFlowMetrics.badgeSize,
      height: AuthFlowMetrics.badgeSize,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.13),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.lavender,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AuthFlowIcon(
            assetName: iconAsset,
            size: 42,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class AuthLanguageButton extends ConsumerWidget {
  const AuthLanguageButton({super.key, this.onDark = false});

  final bool onDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocale = ref.watch(localeProvider);

    return PopupMenuButton<AppLocale>(
      key: const ValueKey('language-button'),
      tooltip: context.l10n.language,
      onSelected: ref.read(localeProvider.notifier).select,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 4),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 4,
      shadowColor: AppColors.ink.withValues(alpha: 0.14),
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 166),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.border),
      ),
      menuPadding: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      itemBuilder: (context) => [
        for (final locale in AppLocale.values)
          PopupMenuItem<AppLocale>(
            value: locale,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _nativeLocaleLabel(locale),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: locale.fontFamily,
                      color: locale == selectedLocale
                          ? AppColors.primary
                          : AppColors.ink,
                      fontSize: 13,
                      height: locale == AppLocale.urdu ? 1.45 : 1.2,
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
      icon: AuthFlowIcon(
        assetName: 'assets/icons/language_globe.svg',
        size: 22,
        color: onDark
            ? Colors.white.withValues(alpha: 0.9)
            : AppColors.mutedInk,
      ),
    );
  }
}

String _nativeLocaleLabel(AppLocale locale) => switch (locale) {
  AppLocale.english => 'English',
  AppLocale.urdu => 'اردو',
  AppLocale.romanUrdu => 'Roman Urdu',
};

class AuthPrimaryActionButton extends StatelessWidget {
  const AuthPrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.inverted = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    final background = inverted ? Colors.white : AppColors.primary;
    final foreground = inverted ? AppColors.primary : Colors.white;

    return SizedBox(
      width: double.infinity,
      height: AuthFlowMetrics.controlHeight,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          disabledBackgroundColor: background.withValues(alpha: 0.58),
          foregroundColor: foreground,
          disabledForegroundColor: foreground.withValues(alpha: 0.8),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthFlowMetrics.fieldRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            height: 1,
            fontWeight: FontWeight.w400,
          ),
        ),
        child: loading
            ? SizedBox.square(
                dimension: 21,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: foreground,
                ),
              )
            : Text(label),
      ),
    );
  }
}

InputDecoration authFieldDecoration({
  required String hintText,
  String? labelText,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(AuthFlowMetrics.fieldRadius),
    ),
    borderSide: BorderSide(color: Color(0xFFEFF0F5)),
  );

  return InputDecoration(
    filled: true,
    fillColor: const Color(0xFFF9FAFE),
    isDense: true,
    hintText: hintText,
    labelText: labelText,
    hintStyle: const TextStyle(
      color: Color(0xFFA3A3A3),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: const TextStyle(
      color: AppColors.mutedInk,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    floatingLabelStyle: const TextStyle(
      color: AppColors.primary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    prefixIconConstraints: const BoxConstraints(minWidth: 52, minHeight: 52),
    suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 52),
    border: border,
    enabledBorder: border,
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(AuthFlowMetrics.fieldRadius),
      ),
      borderSide: BorderSide(color: AppColors.primary, width: 1.4),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(AuthFlowMetrics.fieldRadius),
      ),
      borderSide: BorderSide(color: Color(0xFFE35D6A)),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(AuthFlowMetrics.fieldRadius),
      ),
      borderSide: BorderSide(color: Color(0xFFE35D6A), width: 1.4),
    ),
    errorStyle: const TextStyle(fontSize: 12, height: 1.3),
    errorMaxLines: 2,
  );
}

class AuthSupportingText extends StatelessWidget {
  const AuthSupportingText(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.mutedInk,
        fontSize: 13,
        height: 1.45,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class AuthInlineError extends StatelessWidget {
  const AuthInlineError(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: errorColor.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(AuthFlowMetrics.fieldRadius),
          border: Border.all(color: errorColor.withValues(alpha: 0.18)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(
                Icons.error_outline_rounded,
                size: 18,
                color: errorColor,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: errorColor,
                  fontSize: 12,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthFlowIcon extends StatelessWidget {
  const AuthFlowIcon({
    super.key,
    required this.assetName,
    this.size = 20,
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

class AuthFieldLeadingIcon extends StatelessWidget {
  const AuthFieldLeadingIcon({
    super.key,
    required this.assetName,
    this.color = AppColors.mutedInk,
  });

  final String assetName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Center(
        child: AuthFlowIcon(assetName: assetName, size: 20, color: color),
      ),
    );
  }
}

class AuthOtpField extends StatefulWidget {
  const AuthOtpField({
    super.key,
    required this.controller,
    required this.validator,
    this.autofocus = true,
    this.length = 6,
    this.externalErrorText,
    this.onChanged,
  });

  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final bool autofocus;
  final int length;
  final String? externalErrorText;
  final ValueChanged<String>? onChanged;

  @override
  State<AuthOtpField> createState() => _AuthOtpFieldState();
}

class _AuthOtpFieldState extends State<AuthOtpField> {
  final _fieldKey = GlobalKey<FormFieldState<String>>();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  void _handleControllerChanged() {
    _fieldKey.currentState?.didChange(widget.controller.text);
    widget.onChanged?.call(widget.controller.text);
    if (mounted) setState(() {});
  }

  void _handleFocusChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: _fieldKey,
      initialValue: widget.controller.text,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        final value = widget.controller.text;
        final errorColor = Theme.of(context).colorScheme.error;
        final visibleError = field.errorText ?? widget.externalErrorText;
        final hasError = visibleError != null;
        final activeIndex = value.length >= widget.length
            ? widget.length - 1
            : value.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              textField: true,
              label: context.l10n.verifyCode,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _focusNode.requestFocus,
                child: SizedBox(
                  height: 64,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: 0.01,
                            child: TextField(
                              controller: widget.controller,
                              focusNode: _focusNode,
                              autofocus: widget.autofocus,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              textDirection: TextDirection.ltr,
                              autofillHints: const [AutofillHints.oneTimeCode],
                              autocorrect: false,
                              enableSuggestions: false,
                              maxLength: widget.length,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(widget.length),
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            children: [
                              for (
                                var index = 0;
                                index < widget.length;
                                index++
                              ) ...[
                                if (index > 0) const SizedBox(width: 8),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 160),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9FAFE),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: hasError
                                            ? errorColor
                                            : _focusNode.hasFocus &&
                                                  index == activeIndex
                                            ? AppColors.primary
                                            : const Color(0xFFEFF0F5),
                                        width:
                                            _focusNode.hasFocus &&
                                                index == activeIndex
                                            ? 1.4
                                            : 1,
                                      ),
                                    ),
                                    child: Text(
                                      index < value.length ? value[index] : '',
                                      style: const TextStyle(
                                        color: AppColors.ink,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (visibleError != null) ...[
              const SizedBox(height: 6),
              Semantics(
                liveRegion: true,
                child: Text(
                  visibleError,
                  style: TextStyle(
                    color: errorColor,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
