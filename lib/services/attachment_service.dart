import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Captures or picks a receipt/photo and persists it inside the app's private
/// storage. The absolute file path returned here is what gets written to
/// Firestore (see `Expense.receiptUrl`), keeping images on-device instead of in
/// cloud storage.
class AttachmentService {
  AttachmentService({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  static const String _folderName = 'receipts';

  /// Directory that holds every stored attachment, created on first use.
  Future<Directory> _receiptsDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}${Platform.pathSeparator}$_folderName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Launches the camera or gallery (per [source]) and copies the chosen image
  /// into app storage. Returns the saved file path, or `null` when the user
  /// cancelled or no image could be read.
  Future<String?> pickAndStore(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked == null) return null;

    final dir = await _receiptsDir();
    final dot = picked.name.lastIndexOf('.');
    final ext = dot >= 0 ? picked.name.substring(dot) : '.jpg';
    final fileName = 'receipt_${DateTime.now().millisecondsSinceEpoch}$ext';
    final dest = '${dir.path}${Platform.pathSeparator}$fileName';

    await File(picked.path).copy(dest);
    return dest;
  }

  /// Best-effort delete of a stored attachment; ignores missing files.
  Future<void> delete(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // The file may already be gone — nothing else to do.
    }
  }
}
