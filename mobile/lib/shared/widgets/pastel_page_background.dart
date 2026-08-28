import 'package:flutter/material.dart';
import 'package:tailor_app/core/theme/app_theme.dart';

/// The static pastel canvas used by the dashboard.
///
/// Authentication pages reuse this widget so the visual system stays
/// consistent without changing the dashboard itself.
class PastelPageBackground extends StatelessWidget {
  const PastelPageBackground({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFEFFFE), Color(0xFFFEFDFF), Color(0xFFFFFEFA)],
          stops: [0, 0.52, 1],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            top: -80,
            left: -105,
            child: _PastelGlow(
              color: Color(0xFFE4F9F1),
              size: 300,
              opacity: 0.78,
            ),
          ),
          const Positioned(
            top: 105,
            left: -155,
            child: _PastelGlow(
              color: AppColors.lavender,
              size: 390,
              opacity: 0.34,
            ),
          ),
          const Positioned(
            top: 230,
            right: -185,
            child: _PastelGlow(
              color: Color(0xFFFFF3C9),
              size: 430,
              opacity: 0.56,
            ),
          ),
          const Positioned(
            top: 330,
            left: -210,
            child: _PastelGlow(
              color: Color(0xFFDDF4FF),
              size: 510,
              opacity: 0.72,
            ),
          ),
          ?child,
        ],
      ),
    );
  }
}

class _PastelGlow extends StatelessWidget {
  const _PastelGlow({
    required this.color,
    required this.size,
    required this.opacity,
  });

  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
