import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/storage/secure_storage_service.dart';

class EntryScreen extends ConsumerStatefulWidget {
  const EntryScreen({super.key});

  @override
  ConsumerState<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends ConsumerState<EntryScreen> {
  static const _splashDuration = Duration(seconds: 2);

  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
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

    final remaining = _splashDuration - DateTime.now().difference(startedAt);
    if (remaining > Duration.zero) await Future<void>.delayed(remaining);
    if (!mounted) return;

    context.go(token?.trim().isNotEmpty ?? false ? '/dashboard' : '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: const ValueKey('splash-root'),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOut,
              child: AnimatedScale(
                scale: _visible ? 1 : 0.94,
                duration: const Duration(milliseconds: 520),
                curve: Curves.easeOutCubic,
                child: Image.asset(
                  'assets/images/sewing_machine_mark.webp',
                  key: const ValueKey('splash-mark'),
                  width: 132,
                  height: 132,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
