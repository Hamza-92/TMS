import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';
import 'package:tailor_app/features/auth/domain/phone_number.dart';
import 'package:tailor_app/features/auth/presentation/widgets/auth_flow_widgets.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _continue() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final phone = PhoneNumber.normalize(_phoneController.text)!;
    context.push('/login/password', extra: LoginDraft(phoneE164: phone));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthFlowScaffold(
      title: l10n.whatsYourPhoneNumber,
      iconAsset: 'assets/icons/profile.svg',
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const ValueKey('login-phone-field'),
              controller: _phoneController,
              autofocus: true,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              textDirection: TextDirection.ltr,
              autofillHints: const [AutofillHints.telephoneNumber],
              decoration: authFieldDecoration(
                labelText: l10n.whatsAppPhone,
                hintText: l10n.phoneHint,
                prefixIcon: const AuthFieldLeadingIcon(
                  assetName: 'assets/icons/profile.svg',
                ),
              ),
              validator: (value) {
                if (value?.trim().isEmpty ?? true) return l10n.phoneRequired;
                return PhoneNumber.normalize(value!) == null
                    ? l10n.phoneInvalid
                    : null;
              },
              onFieldSubmitted: (_) => _continue(),
            ),
            const SizedBox(height: 12),
            AuthSupportingText(
              l10n.phoneLoginHelp,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AuthPrimaryActionButton(
              key: const ValueKey('login-phone-continue'),
              label: l10n.continueLabel,
              onPressed: _continue,
            ),
          ],
        ),
      ),
    );
  }
}
