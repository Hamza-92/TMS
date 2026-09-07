import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';

class GradientPageHeader extends StatelessWidget {
  const GradientPageHeader({
    required this.title,
    this.height = 180,
    this.showBack = true,
    this.onBack,
    this.trailing,
    this.bottom,
    super.key,
  });

  final String title;
  final double height;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [AppColors.primaryDark, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadii.page),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: showBack
                          ? IconButton(
                              tooltip: MaterialLocalizations.of(context)
                                  .backButtonTooltip,
                              onPressed:
                                  onBack ??
                                  () {
                                    if (context.canPop()) {
                                      context.pop();
                                    } else {
                                      context.go('/dashboard');
                                    }
                                  },
                              icon: Icon(
                                Directionality.of(context) == TextDirection.rtl
                                    ? Icons.arrow_forward_rounded
                                    : Icons.arrow_back_rounded,
                                textDirection: TextDirection.ltr,
                                color: Colors.white,
                                size: 22,
                              ),
                            )
                          : const SizedBox(width: 48),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 52),
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (trailing != null)
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: trailing,
                      ),
                  ],
                ),
              ),
              if (bottom != null) ...[
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: bottom!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
