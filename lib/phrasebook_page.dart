import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'phrases.dart';

class PhraseEntry {
  const PhraseEntry(this.category, this.en, this.om, this.am);
  final String category;
  final String en;
  final String om;
  final String am;
}

class PhraseGroup {
  const PhraseGroup(this.id, this.title, this.icon, this.color, this.categories);
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final List<String> categories;
}

const List<PhraseGroup> phraseGroups = [
  PhraseGroup('greet', 'Greetings', Icons.waving_hand, Color(0xFF2E7D32),
      ['Greetings', 'Social', 'Thanks', 'Together']),
  PhraseGroup('conv', 'Conversation', Icons.chat_bubble_outline, Color(0xFF00897B), [
    'Basics', 'Phrases', 'Questions', 'What', 'Who', 'Why', 'When', 'How', 'Ask',
    'Request', 'Choice', 'Offer', 'CanI', 'Give', 'Need', 'Like', 'Dislike', 'Plan',
    'Sentence', 'Have', 'Role', 'There', 'Place'
  ]),
  PhraseGroup('shop', 'Shopping', Icons.shopping_bag_outlined, Color(0xFFEF6C00),
      ['Market', 'Shopping', 'Price', 'Buy', 'Money', 'Quantity']),
  PhraseGroup('food', 'Food & Drink', Icons.restaurant, Color(0xFFC62828),
      ['Food', 'Restaurant', 'Kitchen', 'Order']),
  PhraseGroup('travel', 'Travel', Icons.directions_bus_outlined, Color(0xFF1565C0), [
    'Travel', 'Transport', 'Direction', 'Route', 'Go', 'Where', 'Places', 'Cities',
    'Countries', 'Hotel'
  ]),
  PhraseGroup('health', 'Health', Icons.local_hospital_outlined, Color(0xFFD81B60),
      ['Health', 'Body', 'Emergency']),
  PhraseGroup('edu', 'Education', Icons.school_outlined, Color(0xFF6A1B9A),
      ['Education', 'School']),
  PhraseGroup('biz', 'Business & Work', Icons.business_center_outlined, Color(0xFF37474F),
      ['Work', 'Office', 'Technology']),
  PhraseGroup('family', 'Family & People', Icons.family_restroom, Color(0xFFAD1457),
      ['Family', 'People']),
  PhraseGroup('numtime', 'Numbers & Time', Icons.access_time, Color(0xFF0277BD),
      ['Numbers', 'Time', 'Calendar', 'Measure']),
  PhraseGroup('home', 'Home & Nature', Icons.park_outlined, Color(0xFF558B2F),
      ['Home', 'Nature', 'Animals', 'Farm', 'Weather', 'Colors', 'Clothing', 'Materials']),
  PhraseGroup('words', 'Verbs & Words', Icons.directions_run, Color(0xFF4E342E), [
    'Words', 'Verbs', 'Verb phrases', 'Action', 'Done', 'Group', 'Command',
    'Possessive', 'Adjectives'
  ]),
  PhraseGroup('culture', 'Culture & Society', Icons.account_balance_outlined,
      Color(0xFF8D6E63), ['Culture', 'Society', 'Concept']),
  PhraseGroup('more', 'More', Icons.more_horiz, Color(0xFF757575), []),
];

final Map<String, String> _catToGroup = {
  for (final g in phraseGroups)
    for (final c in g.categories) c.toLowerCase(): g.id,
};

final List<PhraseEntry> allPhraseEntries = [
  for (final r in seedPhrases)
    if (r.length >= 4) PhraseEntry(r[0], r[1], r[2], r[3]),
];

List<PhraseEntry> entriesForGroup(String id) => [
      for (final e in allPhraseEntries)
        if ((_catToGroup[e.category.toLowerCase()] ?? 'more') == id) e,
    ];

List<PhraseEntry> _filter(List<PhraseEntry> src, String q) {
  final s = q.trim().toLowerCase();
  if (s.isEmpty) return src;
  return [
    for (final e in src)
      if (e.en.toLowerCase().contains(s) ||
          e.om.toLowerCase().contains(s) ||
          e.am.contains(s))
        e,
  ];
}

class SavedPhrases {
  static final ValueNotifier<Set<String>> items = ValueNotifier<Set<String>>({});
  static bool _loaded = false;
  static const String _key = 'saved_phrases_v1';

  static Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    items.value = (prefs.getStringList(_key) ?? <String>[]).toSet();
    _loaded = true;
  }

  static Future<void> toggle(String en) async {
    final next = Set<String>.from(items.value);
    if (!next.remove(en)) next.add(en);
    items.value = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, next.toList());
  }
}

class CategoryPhrasebookPage extends StatefulWidget {
  const CategoryPhrasebookPage({super.key});
  @override
  State<CategoryPhrasebookPage> createState() => _CategoryPhrasebookPageState();
}

class _CategoryPhrasebookPageState extends State<CategoryPhrasebookPage> {
  final TextEditingController _search = TextEditingController();
  String _q = '';
  late final Map<String, int> _counts = {
    for (final g in phraseGroups) g.id: entriesForGroup(g.id).length,
  };

  @override
  void initState() {
    super.initState();
    SavedPhrases.load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _open(PhraseGroup g) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PhraseListPage(title: g.title, entries: entriesForGroup(g.id)),
      ),
    );
  }

  Widget _grid() {
    final visible = phraseGroups.where((g) => (_counts[g.id] ?? 0) > 0).toList();
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(12),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.3,
      children: [
        ValueListenableBuilder<Set<String>>(
          valueListenable: SavedPhrases.items,
          builder: (context, saved, _) => _GroupCard(
            title: 'Saved',
            subtitle: '${saved.length} saved',
            icon: Icons.star,
            color: const Color(0xFFF9A825),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SavedPage()),
            ),
          ),
        ),
        for (final g in visible)
          _GroupCard(
            title: g.title,
            subtitle: '${_counts[g.id]} phrases',
            icon: g.icon,
            color: g.color,
            onTap: () => _open(g),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final searching = _q.trim().length >= 2;
    return Scaffold(
      appBar: AppBar(title: const Text('Phrasebook')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _search,
              onChanged: (v) => setState(() => _q = v),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                hintText: 'Search all phrases',
              ),
            ),
          ),
          Expanded(
            child: searching
                ? PhraseListView(entries: _filter(allPhraseEntries, _q))
                : _grid(),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 30, color: color),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhraseListPage extends StatefulWidget {
  const PhraseListPage({super.key, required this.title, required this.entries});
  final String title;
  final List<PhraseEntry> entries;
  @override
  State<PhraseListPage> createState() => _PhraseListPageState();
}

class _PhraseListPageState extends State<PhraseListPage> {
  String _q = '';
  String _sub = '';
  late final List<String> _subs = _uniqueCategories(widget.entries);

  static List<String> _uniqueCategories(List<PhraseEntry> list) {
    final seen = <String>[];
    for (final e in list) {
      if (!seen.contains(e.category)) seen.add(e.category);
    }
    return seen;
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var shown = widget.entries;
    if (_sub.isNotEmpty) {
      shown = [
        for (final e in shown)
          if (e.category == _sub) e,
      ];
    }
    shown = _filter(shown, _q);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                hintText: 'Search in ${widget.title}',
              ),
            ),
          ),
          if (_subs.length > 1)
            SizedBox(
              height: 46,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                children: [
                  _chip('All', _sub.isEmpty, () => setState(() => _sub = '')),
                  for (final c in _subs)
                    _chip(c, _sub == c, () => setState(() => _sub = c)),
                ],
              ),
            ),
          Expanded(child: PhraseListView(entries: shown)),
        ],
      ),
    );
  }
}

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: SavedPhrases.items,
        builder: (context, saved, _) => PhraseListView(
          entries: [
            for (final e in allPhraseEntries)
              if (saved.contains(e.en)) e,
          ],
          emptyText: 'Tap the star on any phrase to save it here',
        ),
      ),
    );
  }
}

class PhraseListView extends StatelessWidget {
  const PhraseListView({
    super.key,
    required this.entries,
    this.emptyText = 'No phrases found',
  });
  final List<PhraseEntry> entries;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return Center(child: Text(emptyText));
    return ValueListenableBuilder<Set<String>>(
      valueListenable: SavedPhrases.items,
      builder: (context, saved, _) => ListView.separated(
        itemCount: entries.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final e = entries[i];
          final isSaved = saved.contains(e.en);
          final verified = verifiedEn.contains(e.en);
          return ListTile(
            title: Text(e.en, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.om),
                Text(e.am),
                const SizedBox(height: 2),
                Text(
                  verified ? '\u2713 Verified' : 'Draft',
                  style: TextStyle(
                    fontSize: 11,
                    color: verified ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(isSaved ? Icons.star : Icons.star_border),
              onPressed: () => SavedPhrases.toggle(e.en),
            ),
            onTap: () {
              Clipboard.setData(
                  ClipboardData(text: '${e.en}\n${e.om}\n${e.am}'));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Copied'), duration: Duration(seconds: 1)),
              );
            },
          );
        },
      ),
    );
  }
}