import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/constants/app_config.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';
import 'package:tailor_app/features/auth/data/auth_repository.dart';
import 'package:tailor_app/features/auth/presentation/widgets/auth_flow_widgets.dart';
import 'package:tailor_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';

class PasswordOtpScreen extends ConsumerStatefulWidget {
  const PasswordOtpScreen({super.key, required this.draft});

  final PasswordOtpDraft draft;

  @override
  ConsumerState<PasswordOtpScreen> createState() => _PasswordOtpScreenState();
}

class _PasswordOtpScreenState extends ConsumerState<PasswordOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  late PasswordOtpDraft _draft;
  Timer? _timer;
  int _secondsRemaining = 0;
  int _resendSecondsRemaining = 0;
  bool _loading = false;
  bool _resending = false;
  String? _submissionError;

  @override
  void initState() {
    super.initState();
    _draft = widget.draft;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(_updateRemaining);
      if (_secondsRemaining == 0 && _resendSecondsRemaining == 0) {
        _timer?.cancel();
      }
    });
  }

  void _updateRemaining() {
    _secondsRemaining = _draft.expiresAt
        .difference(DateTime.now())
        .inSeconds
        .clamp(0, 999);
    _resendSecondsRemaining = _draft.resendAt
        .difference(DateTime.now())
        .inSeconds
        .clamp(0, 999);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_secondsRemaining == 0) return;
    setState(() {
      _loading = true;
      _submissionError = null;
    });

    try {
      final resetDraft = await ref
          .read(authRepositoryProvider)
          .verifyPasswordOtp(
            challengeId: _draft.challengeId,
            otp: _otpController.text,
          );
      if (mounted) {
        context.pushReplacement('/forgot-password/reset', extra: resetDraft);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _submissionError = localizedAuthError(
            context,
            error,
            AuthErrorScope.otp,
          );
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      _resending = true;
      _submissionError = null;
    });
    try {
      final challenge = await ref
          .read(authRepositoryProvider)
          .requestPasswordOtp(_draft.phoneE164);
      if (!mounted) return;
      setState(() {
        _draft = PasswordOtpDraft(
          challengeId: challenge.challengeId,
          phoneE164: _draft.phoneE164,
          expiresAt: challenge.expiresAt,
          resendAt: challenge.resendAt,
        );
        _otpController.clear();
        _formKey.currentState?.reset();
      });
      _startTimer();
      showAuthSnackBar(context, context.l10n.authOtpResent);
    } catch (error) {
      if (mounted) {
        setState(() {
          _submissionError = localizedAuthError(
            context,
            error,
            AuthErrorScope.phone,
          );
        });
      }
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');

    return AuthFlowScaffold(
      title: l10n.verifyPhone,
      subtitle: l10n.otpSentTo(isolateLtrText(_draft.phoneE164)),
      iconAsset: 'assets/icons/message.svg',
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthOtpField(
              key: const ValueKey('password-otp-field'),
              controller: _otpController,
              onChanged: (_) {
                if (_submissionError != null) {
                  setState(() => _submissionError = null);
                }
              },
              validator: (value) =>
                  value?.length == 6 ? null : l10n.otpSixDigitsRequired,
            ),
            const SizedBox(height: 10),
            Text(
              _secondsRemaining > 0
                  ? l10n.otpExpiresIn(isolateLtrText('$minutes:$seconds'))
                  : l10n.otpExpired,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (_submissionError != null) ...[
              const SizedBox(height: 12),
              AuthInlineError(_submissionError!),
            ],
            if (AppConfig.environment != AppEnvironment.production) ...[
              const SizedBox(height: 14),
              const DevelopmentOtpNotice(),
            ],
            const SizedBox(height: 20),
            AuthPrimaryActionButton(
              key: const ValueKey('password-otp-verify-button'),
              label: l10n.verifyCode,
              loading: _loading,
              onPressed: _secondsRemaining > 0 ? _verify : null,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _resendSecondsRemaining > 0 || _resending
                  ? null
                  : _resend,
              child: Text(
                _resending
                    ? l10n.sendingOtp
                    : _resendSecondsRemaining > 0
                    ? l10n.resendOtpIn(_resendSecondsRemaining)
                    : l10n.resendOtp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
