import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'phrases.dart';
import 'private_notes_security.dart';

class Db {
  static Database? _db;

  static Future<Database>? _opening;

  static Future<Database> open() async {
    final existing = _db;
    if (existing != null) return existing;

    final pending = _opening;
    if (pending != null) return pending;

    final future = _openDatabase();
    _opening = future;

    try {
      return await future;
    } catch (_) {
      _opening = null;
      rethrow;
    }
  }

  static Future<Database> _openDatabase() async {
    final path = p.join(await getDatabasesPath(), 'hiikaa.db');
    final db = await openDatabase(
      path,
      version: 9,
      onUpgrade: (d, oldV, newV) async {},
      onCreate: (d, v) async {
        await d.execute(
          'CREATE TABLE phrasebook(id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT NOT NULL, en TEXT NOT NULL, om TEXT NOT NULL, am TEXT NOT NULL)',
        );
        await d.execute(
          'CREATE TABLE history(id INTEGER PRIMARY KEY AUTOINCREMENT, src_lang TEXT NOT NULL, tgt_lang TEXT NOT NULL, src_text TEXT NOT NULL, tgt_text TEXT NOT NULL, favorite INTEGER NOT NULL DEFAULT 0, created_at INTEGER NOT NULL)',
        );
        final batch = d.batch();
        for (final r in seedPhrases) {
          batch.insert('phrasebook', {
            'category': r[0],
            'en': r[1],
            'om': r[2],
            'am': r[3],
          });
        }
        await batch.commit(noResult: true);
      },
    );

    await _ensureSeedPhrases(db);
    await _ensureNotes(db);
    _db = db;
    return db;
  }

  static Future<void> _ensureSeedPhrases(Database db) async {
    // Existing phrases are read once instead of querying once per phrase.
    final rows = await db.query('phrasebook', columns: ['en', 'om', 'am']);

    String makeKey(String en, String om, String am) => '$en\u0000$om\u0000$am';

    final existing = <String>{};
    for (final row in rows) {
      existing.add(
        makeKey(row['en'] as String, row['om'] as String, row['am'] as String),
      );
    }

    final batch = db.batch();
    var added = 0;

    for (final r in seedPhrases) {
      final key = makeKey(r[1], r[2], r[3]);
      if (existing.add(key)) {
        batch.insert('phrasebook', {
          'category': r[0],
          'en': r[1],
          'om': r[2],
          'am': r[3],
        });
        added++;
      }
    }

    if (added > 0) {
      await batch.commit(noResult: true);
    }
  }

  static Future<void> _ensureSentences(Database db) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS sentences(id INTEGER PRIMARY KEY AUTOINCREMENT, en TEXT NOT NULL, om TEXT NOT NULL, am TEXT NOT NULL)',
    );
    final c =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM sentences'),
        ) ??
        0;
    if (c > 0) return;
    final raw = await rootBundle.loadString('assets/flores_sentences.tsv');
    final batch = db.batch();
    for (final line in raw.split('\n')) {
      final p = line.trimRight().split('\t');
      if (p.length < 3) continue;
      batch.insert('sentences', {'en': p[0], 'om': p[1], 'am': p[2]});
    }
    await batch.commit(noResult: true);
  }

  static Future<List<Map<String, Object?>>> sentences(String query) async {
    final db = await open();
    final q = query.trim().toLowerCase();
    if (q.length < 2) return [];
    await _ensureSentences(db);
    if (q.length < 2) return [];
    final like = '%$q%';
    return db.query(
      'sentences',
      where: 'LOWER(en) LIKE ? OR LOWER(om) LIKE ? OR am LIKE ?',
      whereArgs: [like, like, like],
      orderBy: 'id ASC',
    );
  }

  static String norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp("[?!.,;:\u1362\u1363]"), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  static Future<String?> lookup(String text, String src, String tgt) async {
    final db = await open();
    final rows = await db.query('phrasebook', columns: [src, tgt]);
    final q = norm(text);
    for (final r in rows) {
      if (norm(r[src] as String) == q) return r[tgt] as String;
    }
    return null;
  }

  static Future<String?> lookupEn(String text, String src) async {
    final db = await open();
    final rows = await db.query('phrasebook', columns: ['en', src]);
    final q = norm(text);
    for (final r in rows) {
      if (norm(r[src] as String) == q) return r['en'] as String;
    }
    return null;
  }

  static Future<void> addHistory(
    String src,
    String tgt,
    String s,
    String t,
  ) async {
    final db = await open();
    await db.insert('history', {
      'src_lang': src,
      'tgt_lang': tgt,
      'src_text': s,
      'tgt_text': t,
      'favorite': 0,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<List<Map<String, Object?>>> history({
    bool favoritesOnly = false,
  }) async {
    final db = await open();
    return db.query(
      'history',
      where: favoritesOnly ? 'favorite = 1' : null,
      orderBy: 'created_at DESC',
    );
  }

  static Future<void> setFavorite(int id, bool value) async {
    final db = await open();
    await db.update(
      'history',
      {'favorite': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteHistory(int id) async {
    final db = await open();
    await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> clearHistory() async {
    final db = await open();
    await db.delete('history');
  }

  static Future<List<Map<String, Object?>>> phrases(String query) async {
    final db = await open();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return db.query('phrasebook', orderBy: 'en COLLATE NOCASE, id');
    }
    final like = '%$q%';
    return db.query(
      'phrasebook',
      where: 'LOWER(en) LIKE ? OR LOWER(om) LIKE ? OR am LIKE ?',
      whereArgs: [like, like, like],
      orderBy: 'category, id',
    );
  }

  static Future<void> _ensureNotes(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT NOT NULL,
        color INTEGER NOT NULL,
        icon TEXT NOT NULL,
        font_size REAL NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        is_private INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        encrypted_title TEXT,
        encrypted_content TEXT,
        encryption_version INTEGER NOT NULL DEFAULT 0
      )
    ''');
    // Safe additive migration for databases created before encryption existed.
    final columns = await db.rawQuery('PRAGMA table_info(notes)');
    final names = columns.map((c) => c['name'] as String).toSet();
    if (!names.contains('encrypted_title')) {
      await db.execute('ALTER TABLE notes ADD COLUMN encrypted_title TEXT');
    }
    if (!names.contains('encrypted_content')) {
      await db.execute('ALTER TABLE notes ADD COLUMN encrypted_content TEXT');
    }
    if (!names.contains('encryption_version')) {
      await db.execute(
        'ALTER TABLE notes ADD COLUMN encryption_version INTEGER NOT NULL DEFAULT 0',
      );
    }
  }

  /// Encrypts old private notes in one SQLite transaction. Existing rows are
  /// left untouched if any encryption operation fails.
  static Future<void> encryptLegacyPrivateNotes() async {
    final security = PrivateNotesSecurity.instance;
    if (!security.isUnlocked) {
      throw StateError('Private notes must be unlocked before migration.');
    }
    final db = await open();
    await db.transaction((txn) async {
      final rows = await txn.query(
        'notes',
        where: 'is_private = 1 AND encryption_version = 0',
      );
      for (final row in rows) {
        final id = row['id'] as int;
        final title = row['title'] as String;
        final content = row['content'] as String;
        final encryptedTitle = await security.encryptText(title);
        final encryptedContent = await security.encryptText(content);
        await txn.update(
          'notes',
          {
            'title': '',
            'content': '',
            'encrypted_title': encryptedTitle,
            'encrypted_content': encryptedContent,
            'encryption_version': 1,
          },
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    });
  }

  static Future<List<Map<String, Object?>>> notes({
    String query = '',
    String? category,
    bool favoritesOnly = false,
  }) async {
    final db = await open();
    final rawRows = await db.query(
      'notes',
      where:
          [
            if (category != null && category != 'All') 'category = ?',
            if (favoritesOnly) 'is_favorite = 1',
          ].isEmpty
          ? null
          : [
              if (category != null && category != 'All') 'category = ?',
              if (favoritesOnly) 'is_favorite = 1',
            ].join(' AND '),
      whereArgs: [if (category != null && category != 'All') category].isEmpty
          ? null
          : [if (category != null && category != 'All') category],
      orderBy: 'is_favorite DESC, updated_at DESC',
    );

    final security = PrivateNotesSecurity.instance;
    final q = query.trim().toLowerCase();
    final visible = <Map<String, Object?>>[];
    for (final raw in rawRows) {
      final row = Map<String, Object?>.from(raw);
      final isPrivate = (row['is_private'] as int? ?? 0) == 1;

      // Keep private notes out of the ordinary list while locked.
      if (isPrivate && !security.isUnlocked) continue;

      final version = row['encryption_version'] as int? ?? 0;
      if (isPrivate && version == 1) {
        if (!security.isUnlocked) {
          row['title'] = 'Ã°Å¸â€â€™ Yaadannoo iccitii';
          row['content'] = 'PIN galchiitii yaadannoo bani.';
        } else {
          try {
            row['title'] = await security.decryptText(
              row['encrypted_title'] as String,
            );
            row['content'] = await security.decryptText(
              row['encrypted_content'] as String,
            );
          } on Object {
            // Never expose ciphertext or fall back to plaintext on an error.
            row['title'] = 'Ã°Å¸â€â€™ Yaadannoo iccitii';
            row['content'] = 'Yaadannoo kana banuun hin dandaÃ¢â‚¬â„¢amne.';
          }
        }
      } else if (isPrivate) {
        // Legacy plaintext private notes are hidden until the owner sets up PIN
        // and the transactional migration encrypts them.
        row['title'] = 'Ã°Å¸â€â€™ Yaadannoo iccitii durii';
        row['content'] = 'PIN qopheessiitii yaadannoo iccitii eegsiisi.';
      }

      if (q.isNotEmpty) {
        if (isPrivate && !security.isUnlocked) continue;
        final title = (row['title'] as String? ?? '').toLowerCase();
        final content = (row['content'] as String? ?? '').toLowerCase();
        if (!title.contains(q) && !content.contains(q)) continue;
      }
      visible.add(row);
    }
    return visible;
  }

  static Future<int> addNote(Map<String, Object?> values) async {
    final db = await open();
    final now = DateTime.now().millisecondsSinceEpoch;
    final row = Map<String, Object?>.from(values);
    row.remove('_confirm_private_to_public');

    if ((row['is_private'] as int? ?? 0) == 1) {
      final security = PrivateNotesSecurity.instance;
      if (!security.isUnlocked) {
        throw StateError('Private notes must be unlocked before saving.');
      }
      row['encrypted_title'] = await security.encryptText(
        row['title'] as String,
      );
      row['encrypted_content'] = await security.encryptText(
        row['content'] as String,
      );
      row['title'] = '';
      row['content'] = '';
      row['encryption_version'] = 1;
    } else {
      row['encrypted_title'] = null;
      row['encrypted_content'] = null;
      row['encryption_version'] = 0;
    }
    return db.insert('notes', {...row, 'created_at': now, 'updated_at': now});
  }

  static Future<int> updateNote(int id, Map<String, Object?> values) async {
    final db = await open();
    final found = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (found.isEmpty) return 0;

    final old = found.first;
    final row = Map<String, Object?>.from(values);
    final confirmPublic = row.remove('_confirm_private_to_public') == true;
    final wasPrivate = old['is_private'] == 1;
    final willBePrivate = row.containsKey('is_private')
        ? row['is_private'] == 1
        : wasPrivate;
    final hasTitle = row.containsKey('title');
    final hasContent = row.containsKey('content');
    final security = PrivateNotesSecurity.instance;

    Future<String> oldText(String plainKey, String encryptedKey) async {
      if (old['encryption_version'] == 1) {
        if (!security.isUnlocked) {
          throw StateError('Private notes must be unlocked before saving.');
        }
        final encrypted = old[encryptedKey] as String?;
        if (encrypted == null) {
          throw StateError('Encrypted note data is missing.');
        }
        return security.decryptText(encrypted);
      }
      return old[plainKey] as String? ?? '';
    }

    if (wasPrivate && !willBePrivate) {
      if (!confirmPublic) {
        throw StateError(
          'Confirm before changing a private note to an ordinary note.',
        );
      }
      if (!security.isUnlocked) {
        throw StateError('Unlock private notes before changing privacy.');
      }

      row['title'] = hasTitle
          ? row['title'] as String
          : await oldText('title', 'encrypted_title');
      row['content'] = hasContent
          ? row['content'] as String
          : await oldText('content', 'encrypted_content');
      row['is_private'] = 0;
      row['encrypted_title'] = null;
      row['encrypted_content'] = null;
      row['encryption_version'] = 0;
    } else if (!wasPrivate && willBePrivate) {
      if (!security.isUnlocked) {
        throw StateError('Unlock private notes before saving.');
      }
      final title = hasTitle
          ? row['title'] as String
          : old['title'] as String? ?? '';
      final content = hasContent
          ? row['content'] as String
          : old['content'] as String? ?? '';

      row['encrypted_title'] = await security.encryptText(title);
      row['encrypted_content'] = await security.encryptText(content);
      row['title'] = '';
      row['content'] = '';
      row['is_private'] = 1;
      row['encryption_version'] = 1;
    } else if (wasPrivate && willBePrivate && (hasTitle || hasContent)) {
      if (!security.isUnlocked) {
        throw StateError('Unlock private notes before saving.');
      }
      final title = hasTitle
          ? row['title'] as String
          : await oldText('title', 'encrypted_title');
      final content = hasContent
          ? row['content'] as String
          : await oldText('content', 'encrypted_content');

      row['encrypted_title'] = await security.encryptText(title);
      row['encrypted_content'] = await security.encryptText(content);
      row['title'] = '';
      row['content'] = '';
      row['is_private'] = 1;
      row['encryption_version'] = 1;
    }

    return db.update(
      'notes',
      {...row, 'updated_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteNote(int id) async {
    final db = await open();
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
