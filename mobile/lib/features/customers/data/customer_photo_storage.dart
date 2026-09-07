import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CustomerPhotoStorage {
  CustomerPhotoStorage({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<String?> pick(ImageSource source) async {
    final selected = await _picker.pickImage(
      source: source,
      imageQuality: 82,
      maxWidth: 1200,
      requestFullMetadata: false,
    );
    if (selected == null) return null;

    final root = await getApplicationDocumentsDirectory();
    final directory = Directory(
      '${root.path}${Platform.pathSeparator}customer_photos',
    );
    await directory.create(recursive: true);

    final extension = _safeExtension(selected.name);
    final destination = File(
      '${directory.path}${Platform.pathSeparator}'
      '${DateTime.now().microsecondsSinceEpoch}.$extension',
    );
    await File(selected.path).copy(destination.path);
    return destination.path;
  }

  Future<void> delete(String? path) async {
    if (path == null || path.isEmpty) return;
    final file = File(path);
    if (await file.exists()) await file.delete();
  }

  String _safeExtension(String fileName) {
    final separator = fileName.lastIndexOf('.');
    if (separator < 0 || separator == fileName.length - 1) return 'jpg';
    final extension = fileName.substring(separator + 1).toLowerCase();
    return const {'jpg', 'jpeg', 'png', 'webp'}.contains(extension)
        ? extension
        : 'jpg';
  }
}
