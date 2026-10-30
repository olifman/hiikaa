import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'db.dart';
import 'phrases.dart';
import 'private_notes_security.dart';

void main() => runApp(const HiikaaApp());

enum Lang { en, om, am }

const langLabel = {
  Lang.en: 'English',
  Lang.om: 'Afaan Oromoo',
  Lang.am: '\u12A0\u121B\u122D\u129B',
};

class HiikaaApp extends StatelessWidget {
  const HiikaaApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Hiikaa',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green, fontFamily: 'NotoSansEthiopic'),
        home: const HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const TranslatePage(),
      const PhrasebookPage(),
      const HistoryPage(),
      const SentencesPage(),
      const NotesPage(),
    ];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.translate), label: 'Translate'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Phrasebook'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.article_outlined), label: 'Sentences'),
          NavigationDestination(icon: Icon(Icons.edit_note_rounded), label: 'Notes'),
        ],
      ),
    );
  }
}

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});
  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  Lang src = Lang.en;
  Lang tgt = Lang.om;
  final controller = TextEditingController();
  String output = '';
  bool found = false;
  bool verified = false;

  Widget picker(Lang value, ValueChanged<Lang> onChanged) =>
      DropdownButton<Lang>(
        value: value,
        items: [
          for (final l in Lang.values)
            DropdownMenuItem(value: l, child: Text(langLabel[l]!)),
        ],
        onChanged: (l) => onChanged(l!),
      );

  Future<void> translate() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    final r = await Db.lookup(text, src.name, tgt.name);
    final en = r == null ? null : await Db.lookupEn(text, src.name);
    if (!mounted) return;
    setState(() {
      found = r != null;
      verified = en != null && verifiedEn.contains(en);
      output = r ?? 'Not in phrasebook yet. The AI model will be added in a later stage.';
    });
    if (r != null) {
      await Db.addHistory(src.name, tgt.name, text, r);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Hiikaa'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => showDialog(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('About Hiikaa'),
                  content: const Text(
                      'Offline translator for English, Afaan Oromoo and Amharic.\n\nVersion 0.2 (beta)\nWorks without internet. Do not rely on them for medical or legal decisions.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(c),
                        child: const Text('OK')),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(children: [
              picker(src, (l) => setState(() => src = l)),
              IconButton(
                icon: const Icon(Icons.swap_horiz),
                onPressed: () => setState(() {
                  final t = src;
                  src = tgt;
                  tgt = t;
                }),
              ),
              picker(tgt, (l) => setState(() => tgt = l)),
            ]),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Text'),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: translate, child: const Text('Translate')),
            const SizedBox(height: 16),
            Text(output, style: Theme.of(context).textTheme.titleLarge),
            if (found)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: output));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied')));
                  },
                ),
              ),
            const SizedBox(height: 24),

          ],
        ),
      );
}

class PhrasebookPage extends StatefulWidget {
  const PhrasebookPage({super.key});
  @override
  State<PhrasebookPage> createState() => _PhrasebookPageState();
}

class _PhrasebookPageState extends State<PhrasebookPage> {
  String query = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Phrasebook')),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Search'),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, Object?>>>(
              future: Db.phrases(query),
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(child: Text('Error: ${snap.error}'));
                }
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final rows = snap.data!;
                if (rows.isEmpty) {
                  return const Center(child: Text('No phrases found'));
                }
                return ListView.separated(
                  itemCount: rows.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final r = rows[i];
                    return ListTile(
                      isThreeLine: true,
                      title: Text(r['en'] as String),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r['om'] as String),
                          Text(
                            r['am'] as String,
                            style: const TextStyle(
                              fontFamily: 'NotoSansEthiopic',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(r['category'] as String,
                              style: Theme.of(context).textTheme.labelSmall),
                          const SizedBox(height: 4),
                          verifiedEn.contains(r['en'])
                              ? const Text('\u2713 Verified',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 11))
                              : const Text('Draft',
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 11)),
                        ],
                      ),
                      onLongPress: () {
                        Clipboard.setData(ClipboardData(
                            text: '${r['en']}\n${r['om']}\n${r['am']}'));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied')));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ]),
      );
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool favOnly = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          actions: [
            TextButton(
              onPressed: () async {
                await Db.clearHistory();
                setState(() {});
              },
              child: const Text('Clear all'),
            ),
          ],
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              FilterChip(
                label: const Text('Favorites only'),
                selected: favOnly,
                onSelected: (v) => setState(() => favOnly = v),
              ),
            ]),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, Object?>>>(
              future: Db.history(favoritesOnly: favOnly),
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(child: Text('Error: ${snap.error}'));
                }
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final rows = snap.data!;
                if (rows.isEmpty) {
                  return const Center(child: Text('Nothing here yet'));
                }
                return ListView.separated(
                  itemCount: rows.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final r = rows[i];
                    final id = r['id'] as int;
                    final fav = (r['favorite'] as int) == 1;
                    final dir =
                        '${(r['src_lang'] as String).toUpperCase()} \u2192 ${(r['tgt_lang'] as String).toUpperCase()}';
                    return ListTile(
                      title: Text(r['src_text'] as String),
                      subtitle: Text('${r['tgt_text']}\n$dir'),
                      isThreeLine: true,
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          icon: Icon(fav ? Icons.star : Icons.star_border),
                          onPressed: () async {
                            await Db.setFavorite(id, !fav);
                            setState(() {});
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            await Db.deleteHistory(id);
                            setState(() {});
                          },
                        ),
                      ]),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      );
}

class SentencesPage extends StatefulWidget {
  const SentencesPage({super.key});

  @override
  State<SentencesPage> createState() => _SentencesPageState();
}

class _SentencesPageState extends State<SentencesPage> {
  String query = '';
  int page = 0;
  static const int pageSize = 10;

  Widget _languagePanel({
    required String label,
    required String text,
    required Color background,
    required Color accent,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: accent),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            text.trim().isEmpty ? 'Hiikni hin jiru' : text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.55,
              color: Color(0xFF202938),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),
        appBar: AppBar(
          title: const Text(
            'Sentences',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          centerTitle: false,
          backgroundColor: const Color(0xFFF6F8FC),
          surfaceTintColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: TextField(
                onChanged: (v) => setState(() {
                  query = v;
                  page = 0;
                }),
                decoration: InputDecoration(
                  hintText: 'Search sentences in any language',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Color(0xFFE1E7F0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Color(0xFF3977D5),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, Object?>>>(
                future: Db.sentences(query),
                builder: (context, snap) {
                  if (query.trim().length < 2) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.menu_book_rounded,
                              size: 54,
                              color: Color(0xFF3977D5),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Explore sentences',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Search a word to see it in Afaan Oromoo, English and Amharic.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF687386),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (snap.hasError) {
                    return Center(child: Text('Error: ${snap.error}'));
                  }
                  if (!snap.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final rows = snap.data!;
                  if (rows.isEmpty) {
                    return const Center(
                      child: Text('No sentences found'),
                    );
                  }

                  final pageCount = (rows.length / pageSize).ceil();
                  final safePage = page >= pageCount ? pageCount - 1 : page;
                  final pageRows = rows
                      .skip(safePage * pageSize)
                      .take(pageSize)
                      .toList();

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.library_books_outlined,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${rows.length} sentences found',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(14, 2, 14, 12),
                          itemCount: pageRows.length,
                          itemBuilder: (context, i) {
                            final r = pageRows[i];
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 14),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: Color(0xFFE7EBF2),
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEEF2FF),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '${safePage * pageSize + i + 1}',
                                            style: const TextStyle(
                                              color: Color(0xFF4356A6),
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          'Sentence',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Color(0xFF344054),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    _languagePanel(
                                      label: 'AFaan OROMOO',
                                      text: '${r['om'] ?? ''}',
                                      background: const Color(0xFFEAF7EE),
                                      accent: const Color(0xFF247447),
                                      icon: Icons.menu_book_rounded,
                                    ),
                                    const SizedBox(height: 9),
                                    _languagePanel(
                                      label: 'ENGLISH',
                                      text: '${r['en'] ?? ''}',
                                      background: const Color(0xFFEBF3FF),
                                      accent: const Color(0xFF245FC0),
                                      icon: Icons.translate_rounded,
                                    ),
                                    const SizedBox(height: 9),
                                    _languagePanel(
                                      label: '???? ? AMHARIC',
                                      text: '${r['am'] ?? ''}',
                                      background: const Color(0xFFFFF3E5),
                                      accent: const Color(0xFF9A5B16),
                                      icon: Icons.language_rounded,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Color(0xFFE7EBF2)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton.icon(
                              onPressed: safePage > 0
                                  ? () => setState(() => page = safePage - 1)
                                  : null,
                              icon: const Icon(Icons.chevron_left),
                              label: const Text('Previous'),
                            ),
                            Flexible(
                              child: Text(
                                '${safePage + 1} / $pageCount',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF475467),
                                ),
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: safePage < pageCount - 1
                                  ? () => setState(() => page = safePage + 1)
                                  : null,
                              icon: const Icon(Icons.chevron_right),
                              label: const Text('Next'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Text(
                'Source: FLORES-200 (Meta AI), CC BY-SA 4.0',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF7A8495),
                ),
              ),
            ),
          ],
        ),
      );
}


const _noteCategories = <String>[
  'Mana Amantii',
  'Iccitii',
  'Barnoota',
  'Dhuunfaa',
  'Yaada',
  'Kan Biroo',
];

const _noteIcons = <String>[
  '??', '?', '??', '??', '??', '??', '??', '?', '??', '??',
];

const _noteColors = <int>[
  0xFFE8F5E9,
  0xFFEDE7F6,
  0xFFFFF3E0,
  0xFFE3F2FD,
  0xFFFCE4EC,
  0xFFFFFDE7,
  0xFFE0F2F1,
  0xFFF3E5F5,
];

class _PinEntryDialog extends StatefulWidget {
  const _PinEntryDialog();

  @override
  State<_PinEntryDialog> createState() => _PinEntryDialogState();
}

class _PinEntryDialogState extends State<_PinEntryDialog> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('PIN galchi'),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        obscureText: true,
        maxLength: 12,
        decoration: const InputDecoration(
          labelText: 'PIN (lakkoofsa 6–12)',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Dhiisi'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, '__RECOVER__'),
          child: const Text('PIN dagadhe?'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: const Text('Bani'),
        ),
      ],
    );
  }
}
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String query = '';
  String category = 'All';
  bool favoritesOnly = false;

  Future<bool> _ensurePrivateUnlocked() async {
    final security = PrivateNotesSecurity.instance;
    if (security.isUnlocked) return true;
    if (await security.isConfigured) {
      final pin = await _showPinDialog();
      if (pin == null) return false;
      if (pin == '__RECOVERED__') {
        await Db.encryptLegacyPrivateNotes();
        if (mounted) setState(() {});
        return true;
      }
      final ok = await security.unlock(pin);
      if (!ok) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PIN sirrii miti.')),
          );
        }
        return false;
      }
      await Db.encryptLegacyPrivateNotes();
      if (mounted) setState(() {});
      return true;
    }
    final pin = await _showSetupPinDialog();
    if (pin == null) return false;
    try {
      final recoveryCode = await security.setup(pin);
      if (mounted) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Recovery code kee'),
            content: SelectableText(
              '$recoveryCode\n\nKoodii kana bakka nageenya qabu irratti kuusi. PIN yoo dagatte si gargaara. Amma booda guutummaatti irra deebitee argachuun hin dandaâ€™amu.',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kuuseera'),
              ),
            ],
          ),
        );
      }
      await Db.encryptLegacyPrivateNotes();
      if (mounted) setState(() {});
      return true;
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PIN qopheessuun hin milkoofne: $e')),
        );
      }
      return false;
    }
  }

  Future<String?> _showPinDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => const _PinEntryDialog(),
    );

    if (result == '__RECOVER__') {
      return await _recoverPrivateAccess() ? '__RECOVERED__' : null;
    }
    return result;
  }

  Future<String?> _showSetupPinDialog() async {
    final pin = TextEditingController();
    final confirm = TextEditingController();
    String? error;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('PIN iccitii qopheessi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('PIN lakkoofsa 6â€“12 qabu filadhu.'),
              TextField(controller: pin, keyboardType: TextInputType.number, obscureText: true, maxLength: 12, decoration: const InputDecoration(labelText: 'PIN haaraa')),
              TextField(controller: confirm, keyboardType: TextInputType.number, obscureText: true, maxLength: 12, decoration: const InputDecoration(labelText: 'PIN irra deebiâ€™i')),
              if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Dhiisi')),
            FilledButton(
              onPressed: () {
                if (!RegExp(r'^\d{6,12}$').hasMatch(pin.text.trim())) {
                  setDialogState(() => error = 'PIN lakkoofsa 6â€“12 taâ€™uu qaba.');
                } else if (pin.text.trim() != confirm.text.trim()) {
                  setDialogState(() => error = 'PIN lamaan wal hin fakkaatan.');
                } else {
                  Navigator.pop(context, pin.text.trim());
                }
              },
              child: const Text('Qopheessi'),
            ),
          ],
        ),
      ),
    );
    pin.dispose();
    confirm.dispose();
    return result;
  }

  Future<bool> _recoverPrivateAccess() async {
    final code = TextEditingController();
    final pin = TextEditingController();
    final confirm = TextEditingController();
    String? error;
    final values = await showDialog<List<String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Recovery code fayyadami'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: code, textCapitalization: TextCapitalization.characters, decoration: const InputDecoration(labelText: 'Recovery code')),
              TextField(controller: pin, keyboardType: TextInputType.number, obscureText: true, maxLength: 12, decoration: const InputDecoration(labelText: 'PIN haaraa')),
              TextField(controller: confirm, keyboardType: TextInputType.number, obscureText: true, maxLength: 12, decoration: const InputDecoration(labelText: 'PIN haaraa irra deebiâ€™i')),
              if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Dhiisi')),
            FilledButton(
              onPressed: () {
                if (!RegExp(r'^\d{6,12}$').hasMatch(pin.text.trim())) {
                  setDialogState(() => error = 'PIN lakkoofsa 6â€“12 taâ€™uu qaba.');
                } else if (pin.text.trim() != confirm.text.trim()) {
                  setDialogState(() => error = 'PIN lamaan wal hin fakkaatan.');
                } else {
                  Navigator.pop(context, [code.text.trim(), pin.text.trim()]);
                }
              },
              child: const Text('PIN jijjiiri'),
            ),
          ],
        ),
      ),
    );
    code.dispose();
    pin.dispose();
    confirm.dispose();
    if (values == null) return false;
    final ok = await PrivateNotesSecurity.instance.recoverWithCode(values[0], values[1]);
    if (!ok) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recovery code sirrii miti.')));
      return false;
    }
    await Db.encryptLegacyPrivateNotes();
    if (mounted) setState(() {});
    return true;
  }

  Future<void> _managePrivateAccess() async {
    final security = PrivateNotesSecurity.instance;
    if (security.isUnlocked) {
      security.lock();
      if (mounted) setState(() {});
      return;
    }
    await _ensurePrivateUnlocked();
  }

  Future<void> _openEditor([Map<String, Object?>? note]) async {
    if (note != null && (note['is_private'] as int? ?? 0) == 1 &&
        !PrivateNotesSecurity.instance.isUnlocked) {
      final unlocked = await _ensurePrivateUnlocked();
      if (!unlocked || !mounted) return;
      final freshRows = await Db.notes(category: 'All');
      note = freshRows.cast<Map<String, Object?>>().firstWhere(
        (row) => row['id'] == note!['id'],
        orElse: () => note!,
      );
    }
    if (!mounted) return;
    final result = await showModalBottomSheet<Map<String, Object?>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NoteEditor(note: note),
    );
    if (!mounted || result == null) return;
    if ((result['is_private'] as int? ?? 0) == 1 &&
        !PrivateNotesSecurity.instance.isUnlocked) {
      final unlocked = await _ensurePrivateUnlocked();
      if (!unlocked || !mounted) return;
    }

    try {
      if (note == null) {
        await Db.addNote(result);
      } else {
        await Db.updateNote(note['id'] as int, result);
      }
      if (mounted) setState(() {});
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yaadannoo olkaaʼuun hin milkoofne: ${e.toString()}'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _delete(Map<String, Object?> note) async {
    if ((note['is_private'] as int? ?? 0) == 1 &&
        !PrivateNotesSecurity.instance.isUnlocked) {
      final unlocked = await _ensurePrivateUnlocked();
      if (!unlocked || !mounted) return;
      final noteId = note['id'];
      final freshRows = await Db.notes(category: 'All');
      final matches = freshRows.where((row) => row['id'] == noteId);
      if (matches.isEmpty) return;
      note = matches.first;
    }
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yaadannoo haquu?'),
        content: Text('"${note['title']}" haquu barbaaddaa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Lakki'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Haqi'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await Db.deleteNote(note['id'] as int);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFFF7F8FC),
        actions: [
          IconButton(
            tooltip: PrivateNotesSecurity.instance.isUnlocked ? 'Yaadannoo iccitii cufi' : 'PIN / Yaadannoo iccitii',
            onPressed: _managePrivateAccess,
            icon: Icon(PrivateNotesSecurity.instance.isUnlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded),
          ),
          IconButton(
            tooltip: 'Favorites only',
            onPressed: () => setState(() => favoritesOnly = !favoritesOnly),
            icon: Icon(
              favoritesOnly ? Icons.star_rounded : Icons.star_border_rounded,
              color: favoritesOnly ? Colors.amber.shade800 : null,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Yaadannoo haaraa'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF176B48), Color(0xFF39966B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome_rounded,
                      color: Colors.white, size: 28),
                  SizedBox(height: 12),
                  Text(
                    'Yaada kee kuusi.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 23,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Barumsa, yaadannoo fi karoora kee bakka tokko.',
                    style: TextStyle(color: Colors.white, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) => setState(() => query = value),
              decoration: InputDecoration(
                hintText: 'Yaadannoo barbaadi...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final item in ['All', ..._noteCategories])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(item == 'All' ? 'Hunda' : item),
                      selected: category == item,
                      onSelected: (_) => setState(() => category = item),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, Object?>>>(
              future: Db.notes(
                query: query,
                category: category,
                favoritesOnly: favoritesOnly,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Dogoggora: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final rows = snapshot.data!;
                if (rows.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sticky_note_2_outlined,
                              size: 64, color: Colors.green.shade300),
                          const SizedBox(height: 12),
                          const Text(
                            'Yaadannoo hin jiru',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Mallattoo + tuqiitii yaadannoo kee jalqabi.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 100),
                  itemCount: rows.length,
                  itemBuilder: (context, index) {
                    final note = rows[index];
                    final color = Color(note['color'] as int);
                    final isPrivate = (note['is_private'] as int) == 1;
                    final isFavorite = (note['is_favorite'] as int) == 1;
                    final title = note['title'] as String;
                    final content = note['content'] as String;
                    final updated = DateTime.fromMillisecondsSinceEpoch(
                      note['updated_at'] as int,
                    );
                    final date =
                        '${updated.day}/${updated.month}/${updated.year}';

                    return Card(
                      elevation: 0,
                      color: color,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.black.withValues(alpha: 0.05),
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _openEditor(note),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 14, 8, 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  note['icon'] as String,
                                  style: const TextStyle(fontSize: 23),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      isPrivate
                                          ? '?? Yaadannoo iccitii'
                                          : content,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: (note['font_size'] as num)
                                            .toDouble(),
                                        height: 1.35,
                                        color: const Color(0xFF465166),
                                      ),
                                    ),
                                    const SizedBox(height: 9),
                                    Text(
                                      '${note['category']}  ?  $date',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF667085),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'favorite') {
                                    await Db.updateNote(
                                      note['id'] as int,
                                      {'is_favorite': isFavorite ? 0 : 1},
                                    );
                                    if (mounted) setState(() {});
                                  } else if (value == 'edit') {
                                    await _openEditor(note);
                                  } else if (value == 'delete') {
                                    await _delete(note);
                                  }
                                },
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    value: 'favorite',
                                    child: Text(isFavorite
                                        ? 'Jaallatamoo keessaa baasi'
                                        : 'Jaallatamoo keessatti dabali'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Gulaali'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Haqi'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotebookLinesPainter extends CustomPainter {
  const _NotebookLinesPainter({required this.lineHeight});

  final double lineHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE6E2D6)
      ..strokeWidth = 1;

    final firstLine = 12 + lineHeight * 0.95;

    for (double y = firstLine; y < size.height - 8; y += lineHeight) {
      canvas.drawLine(
        Offset(14, y),
        Offset(size.width - 14, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NotebookLinesPainter oldDelegate) {
    return oldDelegate.lineHeight != lineHeight;
  }
}
class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key, this.note});

  final Map<String, Object?>? note;

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late final TextEditingController customCategoryController;
  late String category;
  late String icon;
  late int color;
  late double fontSize;
  late bool favorite;
  late bool isPrivate;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    titleController = TextEditingController(
      text: note?['title'] as String? ?? '',
    );
    contentController = TextEditingController(
      text: note?['content'] as String? ?? '',
    );
    customCategoryController = TextEditingController();
    category = _noteCategories.contains(note?['category'])
        ? note!['category'] as String
        : 'Dhuunfaa';
    icon = note?['icon'] as String? ?? '??';
    color = note?['color'] as int? ?? _noteColors[0];
    fontSize = (note?['font_size'] as num?)?.toDouble() ?? 16;
    favorite = (note?['is_favorite'] as int? ?? 0) == 1;
    isPrivate = (note?['is_private'] as int? ?? 0) == 1;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    customCategoryController.dispose();
    super.dispose();
  }

  void _save() {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mata-duree galchi.')),
      );
      return;
    }
    final customCategory = customCategoryController.text.trim();
    Navigator.pop<Map<String, Object?>>(context, {
      'title': title,
      'content': contentController.text.trim(),
      'category': customCategory.isEmpty ? category : customCategory,
      'color': color,
      'icon': icon,
      'font_size': fontSize,
      'is_favorite': favorite ? 1 : 0,
      'is_private': isPrivate ? 1 : 0,
      '_confirm_private_to_public':
          (widget.note?['is_private'] as int? ?? 0) == 1 && !isPrivate,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFFAFBFF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                widget.note == null ? 'Yaadannoo haaraa' : 'Yaadannoo gulaali',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Mata-duree',
                  prefixIcon: const Icon(Icons.title_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Barreeffama kee',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF26352D),
                ),
              ),
              const SizedBox(height: 9),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFEF8),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE8E1CF)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.035),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: _NotebookLinesPainter(
                    lineHeight: fontSize * 1.7,
                  ),
                  child: TextField(
                    controller: contentController,
                    minLines: 9,
                    maxLines: 14,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      fontSize: fontSize,
                      height: 1.7,
                      color: const Color(0xFF29352F),
                    ),
                    cursorColor: const Color(0xFF176B48),
                    decoration: const InputDecoration(
                      hintText: 'Yaada kee asitti barreessi...',
                      hintStyle: TextStyle(color: Color(0xFF9A9A8F)),
                      contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text('Ramaddii', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: category,
                isExpanded: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final item in _noteCategories)
                    DropdownMenuItem(value: item, child: Text(item)),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => category = value);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: customCategoryController,
                decoration: const InputDecoration(
                  labelText: 'Ramaddii mataa keetii (filannoo)',
                  hintText: 'Fakkeenya: Karoora 2027',
                  prefixIcon: Icon(Icons.create_new_folder_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              const Text('Mallattoo', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final item in _noteIcons)
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => icon = item),
                      child: Container(
                        width: 43,
                        height: 43,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: icon == item
                              ? const Color(0xFFD9F0E4)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: icon == item
                                ? const Color(0xFF238357)
                                : const Color(0xFFE0E5EC),
                            width: icon == item ? 2 : 1,
                          ),
                        ),
                        child: Text(item, style: const TextStyle(fontSize: 21)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Halluu', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: [
                  for (final value in _noteColors)
                    InkWell(
                      onTap: () => setState(() => color = value),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Color(value),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color == value
                                ? const Color(0xFF176B48)
                                : Colors.black12,
                            width: color == value ? 3 : 1,
                          ),
                        ),
                        child: color == value
                            ? const Icon(Icons.check, size: 17)
                            : null,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.format_size_rounded),
                  const SizedBox(width: 8),
                  const Text('Hammamtaa barruu'),
                  Expanded(
                    child: Slider(
                      min: 14,
                      max: 24,
                      divisions: 10,
                      value: fontSize,
                      label: fontSize.round().toString(),
                      onChanged: (value) => setState(() => fontSize = value),
                    ),
                  ),
                  Text(fontSize.round().toString()),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: favorite,
                onChanged: (value) => setState(() => favorite = value),
                secondary: const Icon(Icons.star_rounded, color: Colors.amber),
                title: const Text('Jaallatamoo'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: isPrivate,
                onChanged: (value) async {
                  if (!value && isPrivate) {
                    if (!mounted) return;
    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Akeekkachiisa nageenyaa'),
                        content: const Text(
                          'Yaadannoo iccitii gara idileetti jijjiiruun '
                          'qabiyyee isaa barruu ifa taâ€™een kuusa. '
                          'Namoonni bilbila kee argatan dubbisuu dandaâ€™u. '
                          'Jijjiiruu barbaaddaa?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext, false),
                            child: const Text('Dhiisi'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: const Text('Eeyyee, jijjiiri'),
                          ),
                        ],
                      ),
                    );
                    if (!mounted || confirmed != true) return;
                  }
                  setState(() => isPrivate = value);
                },
                secondary: const Icon(Icons.lock_outline_rounded),
                title: const Text('Yaadannoo iccitii'),
                subtitle: const Text(
                  'PIN fi AES-GCM encryption fayyadamuun kuufama.',
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check_rounded),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    child: Text('Kuusi'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






