import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tailor_app/core/theme/app_theme.dart';

class CustomerAvatar extends StatelessWidget {
  const CustomerAvatar({
    super.key,
    this.localPhotoPath,
    this.photoUrl,
    this.size = 44,
    this.borderRadius = 13,
    this.iconSize,
  });

  final String? localPhotoPath;
  final String? photoUrl;
  final double size;
  final double borderRadius;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final path = localPhotoPath;
    final url = photoUrl;
    final fallback = Container(
      color: AppColors.lavender,
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        color: AppColors.primary,
        size: iconSize ?? size * 0.52,
      ),
    );

    Widget image = fallback;
    if (path != null && path.isNotEmpty && File(path).existsSync()) {
      image = Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      );
    } else if (url != null && url.isNotEmpty) {
      image = Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      );
    }

    return SizedBox.square(
      dimension: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: image,
      ),
    );
  }
}
