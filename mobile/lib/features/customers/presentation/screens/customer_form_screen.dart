import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/features/auth/application/auth_controller.dart';
import 'package:tailor_app/features/auth/domain/phone_number.dart';
import 'package:tailor_app/features/customers/application/customer_providers.dart';
import 'package:tailor_app/features/customers/data/customer_photo_storage.dart';
import 'package:tailor_app/features/customers/data/customer_repository.dart';
import 'package:tailor_app/features/customers/domain/customer.dart';
import 'package:tailor_app/features/customers/presentation/widgets/customer_avatar.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';
import 'package:tailor_app/shared/widgets/app_status_sheet.dart';

class CustomerFormScreen extends ConsumerStatefulWidget {
  const CustomerFormScreen({this.clientUuid, super.key});

  final String? clientUuid;

  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _photoStorage = CustomerPhotoStorage();
  CustomerRecord? _existing;
  String? _photoLocalPath;
  String? _newPhotoPath;
  bool _photoChanged = false;
  bool _initialized = false;
  bool _saving = false;

  bool get _editing => widget.clientUuid != null;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _alternatePhoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    if (_newPhotoPath != null) {
      unawaited(_photoStorage.delete(_newPhotoPath));
    }
    super.dispose();
  }

  void _populate(CustomerRecord customer) {
    if (_initialized) return;
    _existing = customer;
    _nameController.text = customer.name;
    _phoneController.text = customer.phoneE164 ?? '';
    _alternatePhoneController.text = customer.alternatePhoneE164 ?? '';
    _addressController.text = customer.address ?? '';
    _notesController.text = customer.notes ?? '';
    _photoLocalPath = customer.photoLocalPath;
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider).valueOrNull;
    final business = authState is SignedIn ? authState.business : null;

    if (business == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (_editing) {
      final customer = ref.watch(
        customerProvider(CustomerKey(business.id, widget.clientUuid!)),
      );
      final record = customer.valueOrNull;
      if (customer.isLoading && record == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator.adaptive()),
        );
      }
      if (record == null) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(child: Text(context.l10n.customerNotFound)),
        );
      }
      _populate(record);
    } else {
      _initialized = true;
    }

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppRadii.page),
          ),
        ),
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [AppColors.primaryDark, AppColors.primaryLight],
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(AppRadii.page),
            ),
          ),
        ),
        title: Text(
          _editing ? context.l10n.editCustomer : context.l10n.addCustomer,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ColoredBox(
        color: AppColors.canvas,
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
              children: [
                _CustomerPhotoField(
                  localPhotoPath: _photoLocalPath,
                  photoUrl: _photoChanged ? null : _existing?.photoUrl,
                  label: context.l10n.customerPhotoHint,
                  onTap: _choosePhoto,
                ),
                const SizedBox(height: 22),
                Text(
                  context.l10n.customerBasicInformation,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _nameController,
                  autofocus: !_editing,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  style: _fieldTextStyle,
                  decoration: _fieldDecoration(
                    label: context.l10n.customerName,
                    hintText: context.l10n.customerNameHint,
                    isRequired: true,
                  ),
                  validator: (value) {
                    final name = value?.trim() ?? '';
                    if (name.isEmpty) return context.l10n.customerNameRequired;
                    if (name.length < 2) {
                      return context.l10n.customerNameTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  textInputAction: TextInputAction.next,
                  style: _fieldTextStyle,
                  decoration: _fieldDecoration(
                    label: context.l10n.customerPhone,
                    hintText: context.l10n.phoneHint,
                  ),
                  validator: (value) => _phoneError(value, alternate: false),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _alternatePhoneController,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  textInputAction: TextInputAction.next,
                  style: _fieldTextStyle,
                  decoration: _fieldDecoration(
                    label: context.l10n.customerAlternatePhone,
                    hintText: context.l10n.phoneHint,
                  ),
                  validator: (value) => _phoneError(value, alternate: true),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _addressController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  maxLines: 2,
                  maxLength: 1000,
                  style: _fieldTextStyle,
                  decoration: _fieldDecoration(
                    label: context.l10n.customerAddress,
                    hintText: context.l10n.customerAddressHint,
                    multiline: true,
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _notesController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  maxLength: 2000,
                  style: _fieldTextStyle,
                  decoration: _fieldDecoration(
                    label: context.l10n.customerNotes,
                    hintText: context.l10n.customerNotesHint,
                    multiline: true,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: _saving ? null : () => _save(business.id),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(AppSizes.controlHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.control),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(context.l10n.saveCustomer),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle? get _fieldTextStyle =>
      Theme.of(context).textTheme.bodyLarge
          ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500);

  InputDecoration _fieldDecoration({
    required String label,
    required String hintText,
    bool isRequired = false,
    bool multiline = false,
  }) {
    return InputDecoration(
      label: Directionality(
        textDirection: Directionality.of(context),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: label),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.danger),
                ),
            ],
          ),
        ),
      ),
      hintText: hintText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      alignLabelWithHint: multiline,
      counterText: '',
      contentPadding: EdgeInsets.fromLTRB(
        16,
        multiline ? 17 : 15,
        16,
        multiline ? 15 : 14,
      ),
    );
  }

  String? _phoneError(String? value, {required bool alternate}) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return null;
    final normalized = PhoneNumber.normalize(input);
    if (normalized == null) return context.l10n.customerPhoneInvalid;

    if (alternate) {
      final primary = PhoneNumber.normalize(_phoneController.text);
      if (primary != null && primary == normalized) {
        return context.l10n.customerAlternatePhoneDifferent;
      }
    }
    return null;
  }

  Future<void> _save(String businessId) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final repository = ref.read(customerRepositoryProvider);
      final customer = await repository.save(
        businessId: businessId,
        existing: _existing,
        draft: CustomerDraft(
          name: _nameController.text.trim(),
          phoneE164: _normalizedOrNull(_phoneController.text),
          alternatePhoneE164: _normalizedOrNull(_alternatePhoneController.text),
          address: _textOrNull(_addressController.text),
          notes: _textOrNull(_notesController.text),
          photoLocalPath: _photoLocalPath,
          photoChanged: _photoChanged,
        ),
      );
      ref.invalidate(customersProvider(businessId));
      unawaited(repository.synchronize(businessId));

      if (!mounted) return;
      final previousPhotoPath = _existing?.photoLocalPath;
      _newPhotoPath = null;
      if (_photoChanged &&
          previousPhotoPath != null &&
          previousPhotoPath != _photoLocalPath) {
        unawaited(_photoStorage.delete(previousPhotoPath));
      }

      await showAppStatusSheet(
        context,
        type: AppStatusType.success,
        title: context.l10n.customerSavedTitle,
        message: context.l10n.customerSavedLocally,
        actionLabel: context.l10n.doneLabel,
      );
      if (!mounted) return;

      if (_editing) {
        context.pop();
      } else {
        context.go('/customers/${customer.clientUuid}');
      }
    } catch (_) {
      if (mounted) {
        await showAppStatusSheet(
          context,
          type: AppStatusType.danger,
          title: context.l10n.errorTitle,
          message: context.l10n.customerSaveFailed,
          actionLabel: context.l10n.okayLabel,
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _normalizedOrNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : PhoneNumber.normalize(trimmed);
  }

  String? _textOrNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> _choosePhoto() async {
    FocusScope.of(context).unfocus();
    final hasPhoto =
        _photoLocalPath != null ||
        (!_photoChanged && (_existing?.photoUrl?.isNotEmpty ?? false));
    final action = await showAppOptionsSheet<_PhotoAction>(
      context,
      title: context.l10n.chooseCustomerPhoto,
      cancelLabel: context.l10n.cancelLabel,
      options: [
        AppSheetOption(
          value: _PhotoAction.camera,
          label: context.l10n.takePhoto,
          icon: Icons.camera_alt_outlined,
        ),
        AppSheetOption(
          value: _PhotoAction.gallery,
          label: context.l10n.chooseFromGallery,
          icon: Icons.photo_library_outlined,
        ),
        if (hasPhoto)
          AppSheetOption(
            value: _PhotoAction.remove,
            label: context.l10n.removePhoto,
            icon: Icons.delete_outline_rounded,
            destructive: true,
          ),
      ],
    );
    if (action == null || !mounted) return;

    if (action == _PhotoAction.remove) {
      if (_newPhotoPath != null) {
        await _photoStorage.delete(_newPhotoPath);
      }
      setState(() {
        _photoLocalPath = null;
        _newPhotoPath = null;
        _photoChanged = true;
      });
      return;
    }

    try {
      final path = await _photoStorage.pick(
        action == _PhotoAction.camera
            ? ImageSource.camera
            : ImageSource.gallery,
      );
      if (path == null || !mounted) return;
      if (_newPhotoPath != null) {
        await _photoStorage.delete(_newPhotoPath);
      }
      setState(() {
        _photoLocalPath = path;
        _newPhotoPath = path;
        _photoChanged = true;
      });
    } catch (_) {
      if (!mounted) return;
      await showAppStatusSheet(
        context,
        type: AppStatusType.danger,
        title: context.l10n.errorTitle,
        message: context.l10n.photoSelectionFailed,
        actionLabel: context.l10n.okayLabel,
      );
    }
  }
}

enum _PhotoAction { camera, gallery, remove }

class _CustomerPhotoField extends StatelessWidget {
  const _CustomerPhotoField({
    required this.localPhotoPath,
    required this.photoUrl,
    required this.label,
    required this.onTap,
  });

  final String? localPhotoPath;
  final String? photoUrl;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.chooseCustomerPhoto,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x185F33E1),
                          blurRadius: 18,
                          offset: Offset(0, 7),
                        ),
                      ],
                    ),
                    child: CustomerAvatar(
                      localPhotoPath: localPhotoPath,
                      photoUrl: photoUrl,
                      size: 82,
                      borderRadius: 41,
                      iconSize: 38,
                    ),
                  ),
                  PositionedDirectional(
                    end: -2,
                    bottom: 1,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
