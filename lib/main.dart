import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'db.dart';
import 'phrases.dart';

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
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
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
                      'Offline translator for English, Afaan Oromoo and Amharic.\n\nVersion 0.2 (beta)\nWorks without internet. Phrases are drafts being reviewed by native speakers. Do not rely on them for medical or legal decisions.'),
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
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  verified
                      ? '\u2713 Verified by a native speaker'
                      : 'Draft: not yet verified by a native speaker',
                  style: TextStyle(
                      fontSize: 12,
                      color: verified ? Colors.green : Colors.orange),
                ),
              ),
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
            Text(
              'Beta: phrases are being checked by native speakers. Machine translation can contain errors.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
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
                      subtitle: Text('${r['om']}\n${r['am']}'),
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
