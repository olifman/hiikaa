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
                      'Offline translator for English, Afaan Oromoo and Amharic.\n\nVersion 0.1 (beta)\nWorks without internet. Phrases are drafts being reviewed by native speakers. Do not rely on them for medical or legal decisions.'),
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
