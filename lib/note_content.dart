import 'dart:convert';

/// Returns readable text from either a legacy plain-text note
/// or a Quill Delta JSON note.
String notePlainText(String content) {
  try {
    final decoded = jsonDecode(content);

    if (decoded is List &&
        decoded.isNotEmpty &&
        decoded.every(
          (item) =>
              item is Map &&
              item.containsKey('insert'),
        )) {
      final buffer = StringBuffer();

      for (final item in decoded) {
        final insert = item['insert'];
        if (insert is String) {
          buffer.write(insert);
        }
      }

      return buffer.toString().trim();
    }
  } catch (_) {
    // Existing plain-text notes are returned unchanged.
  }

  return content;
}
