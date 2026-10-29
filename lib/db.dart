import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'phrases.dart';

class Db {
  static Database? _db;

  static Future<Database> open() async {
    final existing = _db;
    if (existing != null) return existing;
    final path = p.join(await getDatabasesPath(), 'hiikaa.db');
    final db = await openDatabase(path, version: 5,
        onUpgrade: (d, oldV, newV) async {}, onCreate: (d, v) async {
      await d.execute(
          'CREATE TABLE phrasebook(id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT NOT NULL, en TEXT NOT NULL, om TEXT NOT NULL, am TEXT NOT NULL)');
      await d.execute(
          'CREATE TABLE history(id INTEGER PRIMARY KEY AUTOINCREMENT, src_lang TEXT NOT NULL, tgt_lang TEXT NOT NULL, src_text TEXT NOT NULL, tgt_text TEXT NOT NULL, favorite INTEGER NOT NULL DEFAULT 0, created_at INTEGER NOT NULL)');
      final batch = d.batch();
      for (final r in seedPhrases) {
        batch.insert('phrasebook',
            {'category': r[0], 'en': r[1], 'om': r[2], 'am': r[3]});
      }
      await batch.commit(noResult: true);
    });
    await _ensureSeedPhrases(db);
    await _ensureSentences(db);
    _db = db;
    return db;
  }


  static Future<void> _ensureSeedPhrases(Database db) async {
    for (final r in seedPhrases) {
      final found = await db.query(
        'phrasebook',
        columns: ['id'],
        where: 'en = ? AND om = ? AND am = ?',
        whereArgs: [r[1], r[2], r[3]],
        limit: 1,
      );
      if (found.isEmpty) {
        await db.insert('phrasebook', {
          'category': r[0],
          'en': r[1],
          'om': r[2],
          'am': r[3],
        });
      }
    }
  }
  static Future<void> _ensureSentences(Database db) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS sentences(id INTEGER PRIMARY KEY AUTOINCREMENT, en TEXT NOT NULL, om TEXT NOT NULL, am TEXT NOT NULL)');
    final c = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM sentences')) ??
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
      String src, String tgt, String s, String t) async {
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

  static Future<List<Map<String, Object?>>> history(
      {bool favoritesOnly = false}) async {
    final db = await open();
    return db.query('history',
        where: favoritesOnly ? 'favorite = 1' : null,
        orderBy: 'created_at DESC');
  }

  static Future<void> setFavorite(int id, bool value) async {
    final db = await open();
    await db.update('history', {'favorite': value ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
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
      return db.query('phrasebook', orderBy: 'category, id');
    }
    final like = '%$q%';
    return db.query('phrasebook',
        where: 'LOWER(en) LIKE ? OR LOWER(om) LIKE ? OR am LIKE ?',
        whereArgs: [like, like, like],
        orderBy: 'category, id');
  }
}