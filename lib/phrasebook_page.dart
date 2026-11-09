import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'phrases.dart';
import 'app_localizations.dart';
import 'technology_page.dart';

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
      ['Health', 'Body', 'Emergency', 'Symptoms', 'Conditions', 'Doctor', 'Pharmacy', 'Hygiene', 'Mother and child', 'Medical words']),
  PhraseGroup('edu', 'Education', Icons.school_outlined, Color(0xFF6A1B9A),
      ['Education', 'School', 'Classroom', 'School life', 'Exams', 'Subjects', 'Grades']),
  PhraseGroup('biz', 'Business & Work', Icons.business_center_outlined, Color(0xFF37474F),
      ['Work', 'Office']),
  PhraseGroup('tech', 'Technology', Icons.memory, Color(0xFF00897B),
      ['Technology']),
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
  PhraseGroup('sci', 'Science & Tech', Icons.science_outlined, Color(0xFF00695C), [
    'Science', 'Mathematics', 'Statistics', 'Computer Science', 'Software Engineering',
    'Computer Security', 'Technology and computers', 'Internet and communication',
    'Engineering', 'Construction', 'Research'
  ]),
  PhraseGroup('love', 'Love & Relationships', Icons.favorite_border, Color(0xFFEC407A), [
    'Feelings', 'Compliments', 'Dating', 'Relationship', 'Marriage', 'Distance'
  ]),
  PhraseGroup('jobs', 'Jobs & Interviews', Icons.work_outline, Color(0xFF3949AB), [
    'Job interview questions', 'Job interview answers', 'Job application', 'Boss to employee',
    'Employee to boss', 'Hiring and salary', 'Colleagues at work', 'Workplace problems', 'Quitting and leaving'
  ]),
  PhraseGroup('gov', 'Government & Offices', Icons.account_balance_outlined, Color(0xFF455A64), [
    'Police station', 'Court', 'Prosecutor', 'Defense and military', 'Communication office',
    'Immigration and passport', 'City and kebele office', 'Tax and revenue',
    'Land and housing office', 'Utilities and post office'
  ]),
  PhraseGroup('motiv', 'Motivation', Icons.emoji_events_outlined, Color(0xFFF9A825), ['Motivation']),
  PhraseGroup('quotes', 'Famous quotes', Icons.format_quote, Color(0xFF5E35B1), ['Famous quotes']),
  PhraseGroup('trans', 'Transportation & Vehicles', Icons.directions_car_outlined, Color(0xFF00838F), ['Transportation & Vehicles']),
  PhraseGroup('bank', 'Money & Banking', Icons.account_balance_wallet_outlined, Color(0xFF33691E), ['Money & Banking']),
  PhraseGroup('wx', 'Time, Date & Weather', Icons.wb_cloudy_outlined, Color(0xFF039BE5), ['Time, Date & Weather']),
  PhraseGroup('safety', 'Emergency & Safety', Icons.warning_amber_outlined, Color(0xFFB71C1C), ['Emergency & Safety']),
  PhraseGroup('sport', 'Sports & Recreation', Icons.sports_soccer, Color(0xFFE65100), ['Sports & Recreation']),
  PhraseGroup('dirs', 'Directions & Places', Icons.place_outlined, Color(0xFF6D4C41), ['Directions & Places']),
  PhraseGroup('meas', 'Numbers & Measurements', Icons.straighten, Color(0xFF5C6BC0), ['Numbers & Measurements']),
  PhraseGroup('comm', 'Communication & Social Media', Icons.forum_outlined, Color(0xFF7B1FA2), ['Communication & Social Media']),
  PhraseGroup('grp_faith', 'Faith & Encouragement', Icons.church_outlined, Color(0xFF3F51B5), ['Faith: Blessings', 'Faith: Words', 'Faith: Prayer', 'Faith: Church', 'Faith: Encouragement']),
  PhraseGroup('grp_politics', 'Politics', Icons.how_to_vote_outlined, Color(0xFF455A64), ['Politics: Words', 'Politics: Elections', 'Politics: Public Life']),
  PhraseGroup('grp_law', 'Law', Icons.gavel_outlined, Color(0xFF795548), ['Law: Words', 'Law: Courts', 'Law: Police and Crime']),
  PhraseGroup('grp_machinery', 'Machinery', Icons.precision_manufacturing_outlined, Color(0xFFFF6F00), ['Machinery: Words', 'Machinery: Repair', 'Machinery: Farm', 'Machinery: Safety']),
  PhraseGroup('grp_history', 'History', Icons.history_edu_outlined, Color(0xFF5D4037), ['History: Amazing Facts', 'History: Knowledge', 'History: Love and Wisdom']),
  PhraseGroup('more', 'More', Icons.more_horiz, Color(0xFF757575), []),
];

const Map<String, String> _extraCategoryGroups = {
  'academic': 'edu',
  'education and university': 'edu',
  'university': 'edu',
  'study skills': 'edu',
  'agriculture': 'home',
  'weather and environment': 'home',
  'home and household': 'home',
  'cooking and food': 'food',
  'transportation': 'travel',
  'health and medicine': 'health',
  'emergency and safety': 'health',
  'banking and finance': 'biz',
  'finance': 'biz',
  'business': 'biz',
  'business and trade': 'biz',
  'law and legal services': 'culture',
  'government and public services': 'culture',
  'community and culture': 'culture',
  'everyday conversation': 'conv',
  'daily life': 'conv',
  'lectures and classes': 'edu',
  'academic writing': 'edu',
  'research and thesis': 'edu',
  'exams and grading': 'edu',
  'student and teacher talk': 'edu',
  'student services': 'edu',
  'faculty and staff': 'edu',
  'study habits': 'edu',
  'university life': 'edu',
  'library': 'edu',
  'teaching': 'edu',
  'writing and reading': 'edu',
  'math class': 'edu',
  'languages': 'edu',
  'class schedule': 'edu',
};

final Map<String, String> _catToGroup = {
  for (final g in phraseGroups)
    for (final c in g.categories) c.toLowerCase(): g.id,
  ..._extraCategoryGroups,
};

final List<PhraseEntry> allPhraseEntries = [
  for (final r in seedPhrases)
    if (r.length >= 4) PhraseEntry(r[0], r[1], r[2], r[3]),
];

final Map<String, List<PhraseEntry>> _entriesByGroup = () {
  final m = <String, List<PhraseEntry>>{};
  for (final e in allPhraseEntries) {
    final id = _catToGroup[e.category.toLowerCase()] ?? 'more';
    (m[id] ??= <PhraseEntry>[]).add(e);
  }
  return m;
}();

List<PhraseEntry> entriesForGroup(String id) =>
    _entriesByGroup[id] ?? <PhraseEntry>[];

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
  final AppLanguage appLanguage;
  const CategoryPhrasebookPage({super.key, required this.appLanguage});
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
        builder: (_) => g.id == 'tech'
            ? TechnologyPage(
                appLanguage: widget.appLanguage,
                onVocabularyTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PhraseListPage(
                        title: 'Technology',
                        entries: entriesForGroup('tech'),
                        appLanguage: widget.appLanguage,
                      ),
                    ),
                  );
                },
              )
            : PhraseListPage(
                title: phraseGroupTitle(widget.appLanguage, g.title),
                entries: entriesForGroup(g.id),
                appLanguage: widget.appLanguage,
              ),
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
            title: tr(widget.appLanguage, 'saved'),
            subtitle: '${saved.length} ${widget.appLanguage == AppLanguage.om ? 'kuufame' : widget.appLanguage == AppLanguage.am ? '?????' : 'saved'}',
            icon: Icons.star,
            color: const Color(0xFFF9A825),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SavedPage(appLanguage: widget.appLanguage)),
            ),
          ),
        ),
        for (final g in visible)
          _GroupCard(
            title: phraseGroupTitle(widget.appLanguage, g.title),
            subtitle: '',
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
      appBar: AppBar(title: Text(tr(widget.appLanguage, 'phrasebook'))),
      body: Container(
        color: const Color(0xFFF4F8F5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: TextField(
                controller: _search,
                onChanged: (v) => setState(() => _q = v),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF246B45)),
                  hintText: tr(widget.appLanguage, 'search_phrases'),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE1EBE3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE1EBE3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF246B45), width: 1.6),
                  ),
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
      color: Colors.white,
      elevation: 2,
      shadowColor: color.withValues(alpha: 0.12),
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
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 12)),
                  ],
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
  const PhraseListPage({super.key, required this.title, required this.entries, required this.appLanguage});
  final String title;
  final List<PhraseEntry> entries;
  final AppLanguage appLanguage;
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
        selectedColor: const Color(0xFFDDEFE3),
        backgroundColor: Colors.white,
        side: BorderSide(
          color: selected
              ? const Color(0xFF246B45)
              : const Color(0xFFE1EBE3),
        ),
        labelStyle: TextStyle(
          color: selected
              ? const Color(0xFF246B45)
              : const Color(0xFF52645A),
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
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
      body: Container(
        color: const Color(0xFFF4F8F5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: TextField(
                onChanged: (v) => setState(() => _q = v),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF246B45)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE1EBE3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE1EBE3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF246B45), width: 1.6),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  hintText: '${tr(widget.appLanguage, 'search')} ${widget.title}',
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
                  _chip(tr(widget.appLanguage, 'all'), _sub.isEmpty, () => setState(() => _sub = '')),
                  for (final c in _subs)
                    _chip(c, _sub == c, () => setState(() => _sub = c)),
                ],
              ),
            ),
          Expanded(child: PhraseListView(entries: shown, appLanguage: widget.appLanguage)),
          ],
        ),
      ),
    );
  }
}

class SavedPage extends StatelessWidget {
  final AppLanguage appLanguage;
  const SavedPage({super.key, required this.appLanguage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(appLanguage, 'saved'))),
      body: Container(
        color: const Color(0xFFF4F8F5),
        child: ValueListenableBuilder<Set<String>>(
          valueListenable: SavedPhrases.items,
          builder: (context, saved, _) => PhraseListView(
            entries: [
              for (final e in allPhraseEntries)
                if (saved.contains(e.en)) e,
            ],
            emptyText: appLanguage == AppLanguage.om ? 'Jechoota asitti kuusuuf urjii tuqi' : appLanguage == AppLanguage.am ? '???? ??? ?????? ???? ???' : 'Tap the star on any phrase to save it here',
            appLanguage: appLanguage,
          ),
        ),
      ),
    );
  }
}
class PhraseListView extends StatefulWidget {
  const PhraseListView({
    super.key,
    required this.entries,
    this.emptyText = 'No phrases found',
    this.appLanguage = AppLanguage.en,
  });

  final List<PhraseEntry> entries;
  final String emptyText;
  final AppLanguage appLanguage;

  @override
  State<PhraseListView> createState() => _PhraseListViewState();
}

class _PhraseListViewState extends State<PhraseListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty) {
      return Center(child: Text(widget.emptyText));
    }

    return ValueListenableBuilder<Set<String>>(
      valueListenable: SavedPhrases.items,
      builder: (context, saved, _) => Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        thickness: 6,
        radius: const Radius.circular(10),
        interactive: true,
        child: ListView.separated(
          controller: _scrollController,
          itemCount: widget.entries.length,
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
          separatorBuilder: (_, _) => const SizedBox(height: 9),
          itemBuilder: (context, i) {
            final e = widget.entries[i];
            final isSaved = saved.contains(e.en);

            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: const Color(0xFFE3ECE5)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF244B35).withValues(alpha: 0.035),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(16, 9, 10, 9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  title: Text(
                    e.en,
                    style: const TextStyle(
                      color: Color(0xFF1D3528),
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.translate, size: 16, color: Color(0xFF246B45)),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                e.om,
                                style: const TextStyle(
                                  color: Color(0xFF246B45),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.language, size: 16, color: Color(0xFF8A6A32)),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                e.am,
                                style: const TextStyle(
                                  color: Color(0xFF59645D),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    tooltip: isSaved
                        ? (widget.appLanguage == AppLanguage.om ? 'Kuusaa keessaa haqi' : widget.appLanguage == AppLanguage.am ? '?????? ?????' : 'Remove from saved')
                        : (widget.appLanguage == AppLanguage.om ? 'Jechoota kuusi' : widget.appLanguage == AppLanguage.am ? '???? ?????' : 'Save phrase'),
                    icon: Icon(
                      isSaved ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: isSaved ? const Color(0xFFF2B01E) : const Color(0xFF829087),
                    ),
                    onPressed: () => SavedPhrases.toggle(e.en),
                  ),
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: '${e.en}\n${e.om}\n${e.am}'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tr(widget.appLanguage, 'copied')),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



