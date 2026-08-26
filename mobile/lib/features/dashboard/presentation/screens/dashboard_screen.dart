import 'package:flutter/material.dart';
import 'package:tailor_app/core/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.canvas,
      body: SizedBox.expand(key: ValueKey('dashboard-root')),
    );
  }
}
