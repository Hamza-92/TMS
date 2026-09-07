import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tailor_app/core/theme/app_theme.dart';

enum AppStatusType { success, danger, warning, info }

class AppSheetOption<T> {
  const AppSheetOption({
    required this.value,
    required this.label,
    required this.icon,
    this.destructive = false,
  });

  final T value;
  final String label;
  final IconData icon;
  final bool destructive;
}

Future<void> showAppStatusSheet(
  BuildContext context, {
  required AppStatusType type,
  required String title,
  required String message,
  required String actionLabel,
}) => showModalBottomSheet<void>(
  context: context,
  useSafeArea: true,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  barrierColor: const Color(0x990F0D16),
  builder: (context) => _StatusSheet(
    type: type,
    title: title,
    message: message,
    primaryLabel: actionLabel,
    onPrimary: () => Navigator.pop(context),
  ),
);

Future<bool> showAppConfirmationSheet(
  BuildContext context, {
  required AppStatusType type,
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
}) async =>
    await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x990F0D16),
      isDismissible: true,
      builder: (context) => _StatusSheet(
        type: type,
        title: title,
        message: message,
        primaryLabel: confirmLabel,
        secondaryLabel: cancelLabel,
        onPrimary: () => Navigator.pop(context, true),
        onSecondary: () => Navigator.pop(context, false),
      ),
    ) ??
    false;

Future<T?> showAppOptionsSheet<T>(
  BuildContext context, {
  required String title,
  required List<AppSheetOption<T>> options,
  required String cancelLabel,
}) => showModalBottomSheet<T>(
  context: context,
  useSafeArea: true,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  barrierColor: const Color(0x990F0D16),
  builder: (context) => _OptionsSheet<T>(
    title: title,
    options: options,
    cancelLabel: cancelLabel,
  ),
);

class _StatusSheet extends StatelessWidget {
  const _StatusSheet({
    required this.type,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final AppStatusType type;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final palette = _StatusPalette.forType(type);
    return _SheetSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusIllustration(palette: palette),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(color: palette.foreground, fontSize: 17),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.ink, fontSize: 13, height: 1.45),
          ),
          const SizedBox(height: 22),
          if (secondaryLabel == null)
            SizedBox(
              width: double.infinity,
              height: AppSizes.controlHeight,
              child: FilledButton(
                onPressed: onPrimary,
                style: _primaryButtonStyle(palette),
                child: Text(primaryLabel),
              ),
            )
          else
            Row(
              textDirection: TextDirection.ltr,
              children: [
                Expanded(
                  child: SizedBox(
                    height: AppSizes.controlHeight,
                    child: OutlinedButton(
                      onPressed: onSecondary,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: palette.foreground,
                        side: BorderSide(color: palette.foreground),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadii.control),
                        ),
                      ),
                      child: Text(secondaryLabel!),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: AppSizes.controlHeight,
                    child: FilledButton(
                      onPressed: onPrimary,
                      style: _primaryButtonStyle(palette),
                      child: Text(primaryLabel),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  ButtonStyle _primaryButtonStyle(_StatusPalette palette) =>
      FilledButton.styleFrom(
        backgroundColor: palette.foreground,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
        ),
      );
}

class _OptionsSheet<T> extends StatelessWidget {
  const _OptionsSheet({
    required this.title,
    required this.options,
    required this.cancelLabel,
  });

  final String title;
  final List<AppSheetOption<T>> options;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    return _SheetSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          for (var index = 0; index < options.length; index++) ...[
            _OptionTile<T>(option: options[index]),
            if (index != options.length - 1) const SizedBox(height: 8),
          ],
          const SizedBox(height: 18),
          SizedBox(
            height: AppSizes.controlHeight,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.control),
                ),
              ),
              child: Text(cancelLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionTile<T> extends StatelessWidget {
  const _OptionTile({required this.option});

  final AppSheetOption<T> option;

  @override
  Widget build(BuildContext context) {
    final color = option.destructive ? AppColors.danger : AppColors.ink;
    return Material(
      color: AppColors.field,
      borderRadius: BorderRadius.circular(AppRadii.control),
      child: InkWell(
        onTap: () => Navigator.pop(context, option.value),
        borderRadius: BorderRadius.circular(AppRadii.control),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Icon(option.icon, size: 20, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option.label,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: color, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetSurface extends StatelessWidget {
  const _SheetSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        math.max(18, MediaQuery.paddingOf(context).bottom + 10),
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF25232A),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatusIllustration extends StatelessWidget {
  const _StatusIllustration({required this.palette});

  final _StatusPalette palette;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 148,
      width: double.infinity,
      child: CustomPaint(
        painter: _StatusBackdropPainter(
          surface: palette.surface,
          foreground: palette.foreground,
        ),
        child: Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: palette.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(palette.icon, size: 34, color: palette.foreground),
          ),
        ),
      ),
    );
  }
}

class _StatusBackdropPainter extends CustomPainter {
  const _StatusBackdropPainter({
    required this.surface,
    required this.foreground,
  });

  final Color surface;
  final Color foreground;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = surface;
    final center = Offset(size.width / 2, size.height / 2);
    const sourceWidth = 155.0;
    const sourceHeight = 156.0;
    const blobWidth = 126.0;
    const blobHeight = 127.0;
    final blob = Path()
      ..moveTo(145.387, 55.515)
      ..cubicTo(149.958, 71.2652, 157.439, 82.381, 153.32, 92.4498)
      ..cubicTo(151.074, 97.9419, 149.201, 101.65, 137.808, 119.774)
      ..cubicTo(130.187, 129.165, 128.52, 138.473, 122.319, 145.149)
      ..cubicTo(110.206, 158.192, 101.408, 156.536, 85.0816, 150.751)
      ..cubicTo(77.4413, 148.043, 71.8509, 140.781, 55.4232, 137.899)
      ..cubicTo(51.4078, 137.194, 38.7807, 138.211, 28.4012, 134.274)
      ..cubicTo(12.2142, 124.7, 6.62514, 118.048, 8.95846, 101.65)
      ..cubicTo(8.09602, 91.029, 3.96496, 88.5192, 2.69725, 83.5256)
      ..cubicTo(-1.78275, 65.8783, -1.31479, 57.0981, 8.95846, 44.9699)
      ..cubicTo(15.6069, 36.7326, 25.7039, 34.4754, 38.2873, 29.1522)
      ..cubicTo(50.4918, 23.5501, 53.0555, 16.3365, 61.3549, 11.0278)
      ..cubicTo(74.6113, 2.54828, 91.9409, -2.36017, 103.865, 1.14173)
      ..cubicTo(120.461, 6.01562, 129.551, 9.38386, 141.433, 29.1522)
      ..cubicTo(144.632, 34.4754, 143.883, 40.0781, 145.387, 55.515)
      ..close();

    canvas.save();
    canvas.translate(center.dx - blobWidth / 2, center.dy - blobHeight / 2);
    canvas.scale(blobWidth / sourceWidth, blobHeight / sourceHeight);
    canvas.drawPath(blob, paint);
    canvas.restore();

    final sprinklePaint = Paint()
      ..color = foreground.withValues(alpha: 0.26)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.45
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    void drawStarburst(Offset origin, double radius) {
      for (var index = 0; index < 4; index++) {
        final angle = math.pi * index / 4;
        final direction = Offset(math.cos(angle), math.sin(angle));
        canvas.drawLine(
          origin - direction * radius,
          origin + direction * radius,
          sprinklePaint,
        );
      }
      canvas.drawCircle(
        origin,
        1.8,
        Paint()..color = foreground.withValues(alpha: 0.34),
      );
    }

    Path diamond(Offset origin, double width, double height) => Path()
      ..moveTo(origin.dx, origin.dy - height / 2)
      ..lineTo(origin.dx + width / 2, origin.dy)
      ..lineTo(origin.dx, origin.dy + height / 2)
      ..lineTo(origin.dx - width / 2, origin.dy)
      ..close();

    drawStarburst(Offset(center.dx - 112, center.dy + 31), 8);
    canvas.drawPath(
      diamond(Offset(center.dx + 103, center.dy - 36), 11, 8),
      sprinklePaint,
    );
    canvas.drawPath(
      diamond(Offset(center.dx + 116, center.dy - 47), 5, 4),
      sprinklePaint,
    );
    canvas.drawPath(
      diamond(Offset(center.dx + 119, center.dy - 27), 4, 3),
      sprinklePaint,
    );

    final ringCenter = Offset(center.dx + 116, center.dy + 35);
    canvas.drawArc(
      Rect.fromCenter(center: ringCenter, width: 16, height: 9),
      math.pi * 0.08,
      math.pi * 0.84,
      false,
      sprinklePaint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: ringCenter, width: 16, height: 9),
      math.pi * 1.08,
      math.pi * 0.84,
      false,
      sprinklePaint,
    );
    canvas.drawCircle(ringCenter, 2, sprinklePaint);
  }

  @override
  bool shouldRepaint(_StatusBackdropPainter oldDelegate) =>
      oldDelegate.surface != surface || oldDelegate.foreground != foreground;
}

class _StatusPalette {
  const _StatusPalette(this.foreground, this.surface, this.icon);

  factory _StatusPalette.forType(AppStatusType type) => switch (type) {
    AppStatusType.success => const _StatusPalette(
      AppColors.success,
      AppColors.successSurface,
      Icons.verified_rounded,
    ),
    AppStatusType.danger => const _StatusPalette(
      AppColors.danger,
      AppColors.dangerSurface,
      Icons.delete_outline_rounded,
    ),
    AppStatusType.warning => const _StatusPalette(
      AppColors.warning,
      AppColors.warningSurface,
      Icons.warning_amber_rounded,
    ),
    AppStatusType.info => const _StatusPalette(
      AppColors.primary,
      AppColors.infoSurface,
      Icons.info_outline_rounded,
    ),
  };

  final Color foreground;
  final Color surface;
  final IconData icon;
}
