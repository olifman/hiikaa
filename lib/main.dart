import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'phrasebook_page.dart';

import 'package:flutter/services.dart';

import 'db.dart';
import 'phrases.dart';
import 'private_notes_security.dart';
import 'app_localizations.dart';
import 'note_content.dart';

void main() => runApp(const HiikaaApp());

enum Lang { en, om, am }

const langLabel = {
  Lang.en: 'English',
  Lang.om: 'Afaan Oromoo',
  Lang.am: '\u12A0\u121B\u122D\u129B',
};

class HiikaaApp extends StatefulWidget {
  const HiikaaApp({super.key});

  @override
  State<HiikaaApp> createState() => _HiikaaAppState();
}

class _HiikaaAppState extends State<HiikaaApp> {
  bool isDark = false;
  double fontScale = 1.0;
  AppLanguage appLanguage = AppLanguage.en;
  bool settingsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      isDark = prefs.getBool('hiikaa_dark_theme') ?? false;
      fontScale = prefs.getDouble('hiikaa_font_scale') ?? 1.0;

      final savedLanguage = prefs.getString('hiikaa_app_language') ?? 'en';
      appLanguage = AppLanguage.values.firstWhere(
        (language) => language.name == savedLanguage,
        orElse: () => AppLanguage.en,
      );

      settingsLoaded = true;
    });
  }

  Future<void> _setDark(bool value) async {
    setState(() => isDark = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hiikaa_dark_theme', value);
  }

  Future<void> _setFontScale(double value) async {
    setState(() => fontScale = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('hiikaa_font_scale', value);
  }

  Future<void> _setAppLanguage(AppLanguage value) async {
    setState(() => appLanguage = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hiikaa_app_language', value.name);
  }

  ThemeData _makeTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF246B45),
        brightness: brightness,
      ),
      scaffoldBackgroundColor: isLight
          ? const Color(0xFFF4F8F5)
          : const Color(0xFF121A15),
      fontFamily: 'NotoSansEthiopic',
      appBarTheme: AppBarTheme(
        backgroundColor: isLight
            ? const Color(0xFFF4F8F5)
            : const Color(0xFF121A15),
        foregroundColor: isLight ? const Color(0xFF1D3528) : Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: isLight ? const Color(0xFF1D3528) : Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          fontFamily: 'NotoSansEthiopic',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hiikaa',
      theme: _makeTheme(Brightness.light),
      darkTheme: _makeTheme(Brightness.dark),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: FlutterQuillLocalizations.localizationsDelegates,
      supportedLocales: FlutterQuillLocalizations.supportedLocales,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(fontScale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: HomePage(
        isDark: isDark,
        fontScale: fontScale,
        appLanguage: appLanguage,
        onDarkChanged: _setDark,
        onFontScaleChanged: _setFontScale,
        onAppLanguageChanged: _setAppLanguage,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDark;
  final double fontScale;
  final AppLanguage appLanguage;
  final ValueChanged<bool> onDarkChanged;
  final ValueChanged<double> onFontScaleChanged;
  final ValueChanged<AppLanguage> onAppLanguageChanged;

  const HomePage({
    super.key,
    required this.isDark,
    required this.fontScale,
    required this.appLanguage,
    required this.onDarkChanged,
    required this.onFontScaleChanged,
    required this.onAppLanguageChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      TranslatePage(
        appLanguage: widget.appLanguage,
        onHistory: () => setState(() => index = 2),
        onSettings: () => setState(() => index = 5),
      ),
      CategoryPhrasebookPage(appLanguage: widget.appLanguage),
      const HistoryPage(),
      SentencesPage(appLanguage: widget.appLanguage),
      NotesPage(appLanguage: widget.appLanguage),
      SettingsPage(
        isDark: widget.isDark,
        fontScale: widget.fontScale,
        appLanguage: widget.appLanguage,
        onDarkChanged: widget.onDarkChanged,
        onFontScaleChanged: widget.onFontScaleChanged,
        onAppLanguageChanged: widget.onAppLanguageChanged,
      ),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        height: 74,
        elevation: 3,
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: index == 0
            ? 0
            : index == 1
            ? 1
            : index == 3
            ? 2
            : index == 4
            ? 3
            : 0,
        onDestinationSelected: (i) => setState(() => index = [0, 1, 3, 4][i]),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.translate),
            label: tr(widget.appLanguage, 'translate'),
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: tr(widget.appLanguage, 'phrasebook'),
          ),

          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            label: tr(widget.appLanguage, 'sentences'),
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_rounded),
            label: tr(widget.appLanguage, 'notes'),
          ),
        ],
      ),
    );
  }
}

class TranslatePage extends StatefulWidget {
  final AppLanguage appLanguage;
  final VoidCallback onHistory;
  final VoidCallback onSettings;

  const TranslatePage({
    super.key,
    required this.appLanguage,
    required this.onHistory,
    required this.onSettings,
  });
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

  Widget picker(Lang value, ValueChanged<Lang> onChanged) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1EBE3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Lang>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF246B45),
            size: 20,
          ),
          iconSize: 20,
          borderRadius: BorderRadius.circular(14),
          dropdownColor: Colors.white,
          style: const TextStyle(
            color: Color(0xFF1D3528),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          selectedItemBuilder: (context) => [
            for (final l in Lang.values)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  langLabel[l]!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
          ],
          items: [
            for (final l in Lang.values)
              DropdownMenuItem<Lang>(
                value: l,
                child: Text(
                  langLabel[l]!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (l) {
            if (l != null) onChanged(l);
          },
        ),
      ),
    );
  }

  Future<void> translate() async {
    FocusScope.of(context).unfocus();

    final text = controller.text.trim();
    if (text.isEmpty) return;
    final r = await Db.lookup(text, src.name, tgt.name);
    final en = r == null ? null : await Db.lookupEn(text, src.name);
    if (!mounted) return;
    setState(() {
      found = r != null;
      verified = en != null && verifiedEn.contains(en);
      output =
          r ??
          'Not in phrasebook yet. The AI model will be added in a later stage.';
    });
    if (r != null) {
      await Db.addHistory(src.name, tgt.name, text, r);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: AppBar(
      title: const Text('Hiikaa'),
      actions: [
        IconButton(
          tooltip: 'History',
          icon: const Icon(Icons.history_rounded),
          onPressed: widget.onHistory,
        ),
        IconButton(
          tooltip: 'Settings',
          icon: const Icon(Icons.settings_outlined),
          onPressed: widget.onSettings,
        ),
        IconButton(
          tooltip: 'About Hiikaa',
          icon: const Icon(Icons.info_outline_rounded),
          onPressed: () => showDialog(
            context: context,
            builder: (c) => AlertDialog(
              title: Text(tr(widget.appLanguage, 'about_hiikaa')),
              content: const Text(
                'Offline translator for English, Afaan Oromoo and Amharic.\n\nVersion 0.3 (beta)\nWorks without internet. Do not rely on them for medical or legal decisions.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(c),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1D6844), Color(0xFF39966B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF246B45).withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.translate_rounded, color: Colors.white, size: 24),
              SizedBox(height: 12),
              Text(
                'Break language barriers.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Translate between English, Afaan Oromoo and Amharic.',
                style: TextStyle(color: Colors.white, height: 1.45),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE1EBE3)),
          ),
          child: Row(
            children: [
              Expanded(child: picker(src, (l) => setState(() => src = l))),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4ED),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: IconButton(
                  tooltip: 'Swap languages',
                  icon: const Icon(
                    Icons.swap_horiz_rounded,
                    color: Color(0xFF246B45),
                  ),
                  onPressed: () => setState(() {
                    final t = src;
                    src = tgt;
                    tgt = t;
                  }),
                ),
              ),
              Expanded(child: picker(tgt, (l) => setState(() => tgt = l))),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE1EBE3)),
          ),
          child: TextField(
            controller: controller,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Enter text',
              hintText: 'Type a word or phrase...',
              prefixIcon: const Icon(
                Icons.edit_note_rounded,
                color: Color(0xFF39815A),
              ),
              filled: true,
              fillColor: const Color(0xFFF7FAF7),
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE5EDE7)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF39815A),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 54,
          child: FilledButton.icon(
            onPressed: translate,
            icon: const Icon(Icons.translate_rounded),
            label: const Text(
              'Translate',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF246B45),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        if (output.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFDCE9DF)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF244D34).withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Color(0xFF39815A),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Translation result',
                        style: TextStyle(
                          color: Color(0xFF246B45),
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (found)
                      IconButton(
                        tooltip: 'Copy',
                        icon: const Icon(
                          Icons.copy_rounded,
                          color: Color(0xFF39815A),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: output));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied')),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  output,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF20392A),
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
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
    resizeToAvoidBottomInset: true,
    appBar: AppBar(title: const Text('Phrasebook')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: (v) => setState(() => query = v),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              hintText: 'Search',
            ),
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
                        Text(
                          r['category'] as String,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(height: 4),
                        verifiedEn.contains(r['en'])
                            ? const Text(
                                '\u2713 Verified',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 11,
                                ),
                              )
                            : const Text(
                                'Draft',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 11,
                                ),
                              ),
                      ],
                    ),
                    onLongPress: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: '${r['en']}\n${r['om']}\n${r['am']}',
                        ),
                      );
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Copied')));
                    },
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

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool favOnly = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: true,
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
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Favorites only'),
                selected: favOnly,
                onSelected: (v) => setState(() => favOnly = v),
              ),
            ],
          ),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                      ],
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

class SentencesPage extends StatefulWidget {
  final AppLanguage appLanguage;
  const SentencesPage({super.key, required this.appLanguage});

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
                borderSide: const BorderSide(color: Color(0xFFE1E7F0)),
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
                return const Center(child: CircularProgressIndicator());
              }

              final rows = snap.data!;
              if (rows.isEmpty) {
                return const Center(child: Text('No sentences found'));
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
                            side: const BorderSide(color: Color(0xFFE7EBF2)),
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
                                        borderRadius: BorderRadius.circular(10),
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
                                const SizedBox(height: 8),
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
                                  label: 'አማርኛ / AMHARIC',
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
                      border: Border(top: BorderSide(color: Color(0xFFE7EBF2))),
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
  '??',
  '?',
  '??',
  '??',
  '??',
  '??',
  '??',
  '?',
  '??',
  '??',
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
  const _PinEntryDialog({required this.appLanguage});

  final AppLanguage appLanguage;

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
      title: Text(tr(widget.appLanguage, 'pin_enter_title')),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        obscureText: true,
        maxLength: 12,
        decoration: InputDecoration(
          labelText: tr(widget.appLanguage, 'pin_length'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(tr(widget.appLanguage, 'cancel')),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, '__RECOVER__'),
          child: Text(tr(widget.appLanguage, 'forgot_pin')),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: Text(tr(widget.appLanguage, 'unlock')),
        ),
      ],
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key, required this.appLanguage});

  final AppLanguage appLanguage;

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
            SnackBar(content: Text(tr(widget.appLanguage, 'wrong_pin'))),
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
            title: Text(tr(widget.appLanguage, 'recovery_code_title')),
            content: SelectableText(
              '$recoveryCode\n\n${tr(widget.appLanguage, 'recovery_code_note')}',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Text(tr(widget.appLanguage, 'recovery_code_saved')),
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
          SnackBar(
            content: Text('${tr(widget.appLanguage, 'pin_setup_error')}$e'),
          ),
        );
      }
      return false;
    }
  }

  Future<String?> _showPinDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => _PinEntryDialog(appLanguage: widget.appLanguage),
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
          title: Text(tr(widget.appLanguage, 'pin_setup_title')),
          scrollable: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tr(widget.appLanguage, 'pin_setup_instruction')),
              TextField(
                controller: pin,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 12,
                decoration: InputDecoration(
                  labelText: tr(widget.appLanguage, 'new_pin'),
                ),
              ),
              TextField(
                controller: confirm,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 12,
                decoration: InputDecoration(
                  labelText: tr(widget.appLanguage, 'confirm_pin'),
                ),
              ),
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tr(widget.appLanguage, 'cancel')),
            ),
            FilledButton(
              onPressed: () {
                if (!RegExp(r'^\d{6,12}$').hasMatch(pin.text.trim())) {
                  setDialogState(
                    () => error = tr(widget.appLanguage, 'pin_validation'),
                  );
                } else if (pin.text.trim() != confirm.text.trim()) {
                  setDialogState(
                    () => error = tr(widget.appLanguage, 'pin_mismatch'),
                  );
                } else {
                  Navigator.pop(context, pin.text.trim());
                }
              },
              child: Text(tr(widget.appLanguage, 'setup_pin')),
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
          title: Text(tr(widget.appLanguage, 'use_recovery_code')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: code,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: tr(widget.appLanguage, 'recovery_code_label'),
                ),
              ),
              TextField(
                controller: pin,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 12,
                decoration: InputDecoration(
                  labelText: tr(widget.appLanguage, 'new_pin'),
                ),
              ),
              TextField(
                controller: confirm,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 12,
                decoration: InputDecoration(
                  labelText: tr(widget.appLanguage, 'confirm_pin'),
                ),
              ),
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tr(widget.appLanguage, 'cancel')),
            ),
            FilledButton(
              onPressed: () {
                if (!RegExp(r'^\d{6,12}$').hasMatch(pin.text.trim())) {
                  setDialogState(
                    () => error = tr(widget.appLanguage, 'pin_validation'),
                  );
                } else if (pin.text.trim() != confirm.text.trim()) {
                  setDialogState(
                    () => error = tr(widget.appLanguage, 'pin_mismatch'),
                  );
                } else {
                  Navigator.pop(context, [code.text.trim(), pin.text.trim()]);
                }
              },
              child: Text(tr(widget.appLanguage, 'change_pin')),
            ),
          ],
        ),
      ),
    );
    code.dispose();
    pin.dispose();
    confirm.dispose();
    if (values == null) return false;
    final ok = await PrivateNotesSecurity.instance.recoverWithCode(
      values[0],
      values[1],
    );
    if (!ok) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr(widget.appLanguage, 'recovery_code_error')),
          ),
        );
      }
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
    if (note != null &&
        (note['is_private'] as int? ?? 0) == 1 &&
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
      builder: (_) => NoteEditor(note: note, appLanguage: widget.appLanguage),
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
          content: Text('Yaadannoo olkaa’uun hin milkoofne: ${e.toString()}'),
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
        title: Text(tr(widget.appLanguage, 'delete_note_title')),
        content: Text(
          '${note['title']} - ${tr(widget.appLanguage, 'delete_note_message')}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr(widget.appLanguage, 'no')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(tr(widget.appLanguage, 'delete')),
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
        title: Text(
          tr(widget.appLanguage, 'notes'),
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFFF7F8FC),
        actions: [
          IconButton(
            tooltip: PrivateNotesSecurity.instance.isUnlocked
                ? tr(widget.appLanguage, 'lock_private_notes')
                : tr(widget.appLanguage, 'private_notes_access'),
            onPressed: _managePrivateAccess,
            icon: Icon(
              PrivateNotesSecurity.instance.isUnlocked
                  ? Icons.lock_open_rounded
                  : Icons.lock_outline_rounded,
            ),
          ),
          IconButton(
            tooltip: tr(widget.appLanguage, 'favorites_only'),
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
        label: Text(tr(widget.appLanguage, 'new_note')),
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
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
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
                hintText: tr(widget.appLanguage, 'note_search_hint'),
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
                      label: Text(
                        item == 'All'
                            ? tr(widget.appLanguage, 'all')
                            : noteCategoryTitle(widget.appLanguage, item),
                      ),
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
                          Icon(
                            Icons.sticky_note_2_outlined,
                            size: 64,
                            color: Colors.green.shade300,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tr(widget.appLanguage, 'no_notes'),
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tr(widget.appLanguage, 'start_first_note'),
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
                    final content = notePlainText(
                      note['content'] as String? ?? '',
                    );
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
                                      isPrivate ? '🔒 ' : content,
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
                                    await Db.updateNote(note['id'] as int, {
                                      'is_favorite': isFavorite ? 0 : 1,
                                    });
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
                                    child: Text(
                                      isFavorite
                                          ? tr(
                                              widget.appLanguage,
                                              'favorite_remove',
                                            )
                                          : tr(
                                              widget.appLanguage,
                                              'favorite_add',
                                            ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text(tr(widget.appLanguage, 'edit')),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text(
                                      tr(widget.appLanguage, 'delete'),
                                    ),
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

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key, this.note, required this.appLanguage});

  final Map<String, Object?>? note;
  final AppLanguage appLanguage;

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late final TextEditingController titleController;
  late final QuillController contentController;
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
    final savedContent = note?['content'] as String? ?? '';
    Document noteDocument;

    try {
      final decoded = jsonDecode(savedContent);
      if (decoded is List &&
          decoded.isNotEmpty &&
          decoded.every((item) => item is Map && item.containsKey('insert'))) {
        noteDocument = Document.fromJson(decoded);
      } else {
        noteDocument = Document.fromJson([
          {
            'insert': savedContent.endsWith('\n')
                ? savedContent
                : '$savedContent\n',
          },
        ]);
      }
    } catch (_) {
      noteDocument = Document.fromJson([
        {
          'insert': savedContent.endsWith('\n')
              ? savedContent
              : '$savedContent\n',
        },
      ]);
    }

    contentController = QuillController(
      document: noteDocument,
      selection: const TextSelection.collapsed(offset: 0),
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
        SnackBar(content: Text(tr(widget.appLanguage, 'enter_note_title'))),
      );
      return;
    }
    final customCategory = customCategoryController.text.trim();
    Navigator.pop<Map<String, Object?>>(context, {
      'title': title,
      'content': jsonEncode(contentController.document.toDelta().toJson()),
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
                tr(
                  widget.appLanguage,
                  widget.note == null ? 'new_note' : 'edit_note',
                ),
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: tr(widget.appLanguage, 'title'),
                  prefixIcon: const Icon(Icons.title_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tr(widget.appLanguage, 'content'),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    QuillSimpleToolbar(
                      controller: contentController,
                      config: const QuillSimpleToolbarConfig(
                        multiRowsDisplay: true,
                        showAlignmentButtons: true,
                        showFontSize: true,
                        showColorButton: true,
                        showBackgroundColorButton: true,
                      ),
                    ),
                    const Divider(height: 1),
                    SizedBox(
                      height: 280,
                      child: QuillEditor.basic(
                        controller: contentController,
                        config: QuillEditorConfig(
                          scrollable: true,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          placeholder: tr(widget.appLanguage, 'write_here'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                tr(widget.appLanguage, 'category'),
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
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
                    DropdownMenuItem(
                      value: item,
                      child: Text(noteCategoryTitle(widget.appLanguage, item)),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => category = value);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: customCategoryController,
                decoration: InputDecoration(
                  labelText: tr(widget.appLanguage, 'custom_category'),
                  hintText: tr(widget.appLanguage, 'custom_category_hint'),
                  prefixIcon: Icon(Icons.create_new_folder_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                tr(widget.appLanguage, 'icon'),
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
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
              const SizedBox(height: 10),
              Text(
                tr(widget.appLanguage, 'color'),
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
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
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.format_size_rounded),
                  const SizedBox(width: 8),
                  Text(tr(widget.appLanguage, 'font_size')),
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
                title: Text(tr(widget.appLanguage, 'favorite')),
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
                        title: Text(
                          tr(widget.appLanguage, 'security_warning_title'),
                        ),
                        content: Text(
                          tr(widget.appLanguage, 'security_warning_message'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: Text(tr(widget.appLanguage, 'cancel')),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: Text(
                              tr(widget.appLanguage, 'confirm_change'),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (!mounted || confirmed != true) return;
                  }
                  setState(() => isPrivate = value);
                },
                secondary: const Icon(Icons.lock_outline_rounded),
                title: Text(tr(widget.appLanguage, 'private_note')),
                subtitle: Text(tr(widget.appLanguage, 'private_note_subtitle')),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check_rounded),
                  label: Padding(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    child: Text(tr(widget.appLanguage, 'save')),
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

class SettingsPage extends StatefulWidget {
  final bool isDark;
  final double fontScale;
  final AppLanguage appLanguage;
  final ValueChanged<bool> onDarkChanged;
  final ValueChanged<double> onFontScaleChanged;
  final ValueChanged<AppLanguage> onAppLanguageChanged;

  const SettingsPage({
    super.key,
    required this.isDark,
    required this.fontScale,
    required this.appLanguage,
    required this.onDarkChanged,
    required this.onFontScaleChanged,
    required this.onAppLanguageChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(tr(widget.appLanguage, 'settings_clear_history_title')),
        content: const Text(
          'This will permanently delete all translation history. '
          'Your phrasebook and notes will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(tr(widget.appLanguage, 'cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(tr(widget.appLanguage, 'clear_history')),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await Db.clearHistory();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr(widget.appLanguage, 'clear_history_done'))),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Hiikaa',
      applicationVersion: '0.1',
      applicationIcon: const Icon(
        Icons.translate_rounded,
        size: 42,
        color: Color(0xFF246B45),
      ),
      children: const [
        Text(
          'Hiikaa is a language translation and phrasebook app '
          'designed to help people communicate.',
        ),
        SizedBox(height: 10),
        Text('Created by Lamesa Bekele'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentSize = widget.fontScale == 0.9
        ? tr(widget.appLanguage, 'small')
        : widget.fontScale == 1.1
        ? tr(widget.appLanguage, 'large')
        : tr(widget.appLanguage, 'medium');

    return Scaffold(
      appBar: AppBar(title: Text(tr(widget.appLanguage, 'settings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            tr(widget.appLanguage, 'appearance'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(tr(widget.appLanguage, 'app_language')),
                  subtitle: Text(appLanguageLabel[widget.appLanguage]!),
                  trailing: DropdownButton<AppLanguage>(
                    value: widget.appLanguage,
                    items: AppLanguage.values.map((language) {
                      return DropdownMenuItem<AppLanguage>(
                        value: language,
                        child: Text(appLanguageLabel[language]!),
                      );
                    }).toList(),
                    onChanged: (language) {
                      if (language != null) {
                        widget.onAppLanguageChanged(language);
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(
                    widget.isDark
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                  ),
                  title: Text(tr(widget.appLanguage, 'dark_theme')),
                  subtitle: Text(tr(widget.appLanguage, 'use_dark_appearance')),
                  value: widget.isDark,
                  onChanged: widget.onDarkChanged,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.format_size_rounded),
                  title: Text(tr(widget.appLanguage, 'text_size')),
                  subtitle: Text('Current size: $currentSize'),
                  trailing: DropdownButton<double>(
                    value: widget.fontScale,
                    items: [
                      DropdownMenuItem(
                        value: 0.9,
                        child: Text(tr(widget.appLanguage, 'small')),
                      ),
                      DropdownMenuItem(
                        value: 1.0,
                        child: Text(tr(widget.appLanguage, 'medium')),
                      ),
                      DropdownMenuItem(
                        value: 1.1,
                        child: Text(tr(widget.appLanguage, 'large')),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        widget.onFontScaleChanged(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            tr(widget.appLanguage, 'data'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: Text(tr(widget.appLanguage, 'clear_history')),
              subtitle: Text(tr(widget.appLanguage, 'clear_history_only')),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: _clearHistory,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            tr(widget.appLanguage, 'about'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: Text(tr(widget.appLanguage, 'about_hiikaa')),
              subtitle: Text(tr(widget.appLanguage, 'about_app_info')),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: _showAbout,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Hiikaa • Version 0.1',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
