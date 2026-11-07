import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_localizations.dart';

const String devName = 'Lamesa Bekele Gemechu';
const String appVersionText = '0.3.0';

String _t(AppLanguage language, String en, String om, String am) {
  switch (language) {
    case AppLanguage.en:
      return en;
    case AppLanguage.om:
      return om;
    case AppLanguage.am:
      return am;
  }
}


Future<void> _openContact(String value) async {
  final uri = Uri.parse(value);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
class _AboutEntry {
  const _AboutEntry(this.name, this.description, this.icon, this.color);

  final String name;
  final String description;
  final IconData icon;
  final Color color;
}

class AboutDeveloperPage extends StatelessWidget {
  const AboutDeveloperPage({super.key, required this.appLanguage});

  final AppLanguage appLanguage;

  Widget _sectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colors.surfaceContainerLow,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: color.withValues(alpha: 0.30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            child,
          ],
        ),
      ),
    );
  }

  Widget _entryList(
    BuildContext context,
    List<_AboutEntry> entries,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        for (int i = 0; i < entries.length; i++) ...[
          if (i > 0) const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(entries[i].icon, color: entries[i].color, size: 21),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entries[i].name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      entries[i].description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final features = <_AboutEntry>[
      _AboutEntry(
        _t(appLanguage, 'Offline translation', 'Hiikkaa interneetii malee', 'ከኢንተርኔት ውጭ ትርጉም'),
        _t(appLanguage, 'Use built-in language data without internet.', 'Daataa afaanii app keessa jiru interneetii malee fayyadami.', 'በመተግበሪያው ያለውን የቋንቋ መረጃ ያለ ኢንተርኔት ይጠቀሙ።'),
        Icons.wifi_off_rounded,
        Colors.teal,
      ),
      _AboutEntry(
        _t(appLanguage, 'Phrasebook', 'Kuusaa himootaa', 'የሐረጎች ስብስብ'),
        _t(appLanguage, 'Search useful phrases in three languages.', 'Himoota barbaachisoo afaanota sadaniin barbaadi.', 'በሶስቱ ቋንቋዎች ጠቃሚ ሐረጎችን ይፈልጉ።'),
        Icons.menu_book_rounded,
        Colors.orange,
      ),
      _AboutEntry(
        _t(appLanguage, 'Sentence collection', 'Kuusaa himoota guutuu', 'የዓረፍተ ነገር ስብስብ'),
        _t(appLanguage, 'Explore 2,009 FLORES-200 sentence pairs.', 'Himoota FLORES-200 2,009 qoradhu.', '2,009 የFLORES-200 የዓረፍተ ነገር ጥንዶችን ይመልከቱ።'),
        Icons.translate_rounded,
        Colors.blue,
      ),
      _AboutEntry(
        _t(appLanguage, 'Technology vocabulary', 'Jechoota teeknooloojii', 'የቴክኖሎጂ ቃላት'),
        _t(appLanguage, 'Learn technology terms in three languages.', 'Jechoota teeknooloojii afaanota sadaniin baradhu.', 'የቴክኖሎጂ ቃላትን በሶስቱ ቋንቋዎች ይማሩ።'),
        Icons.memory_rounded,
        Colors.deepPurple,
      ),
      _AboutEntry(
        _t(appLanguage, 'Notes and private notes', 'Yaadannoo fi yaadannoo dhuunfaa', 'ማስታወሻዎች እና የግል ማስታወሻዎች'),
        _t(appLanguage, 'Write notes and protect private notes with encryption.', 'Yaadannoo barreessi; kan dhuunfaa immoo icciitiidhaan eegi.', 'ማስታወሻ ይጻፉ፤ የግል ማስታወሻዎችን በምስጠራ ይጠብቁ።'),
        Icons.lock_outline_rounded,
        Colors.redAccent,
      ),
      _AboutEntry(
        _t(appLanguage, 'History and favorites', 'Seenaa fi kan jaallataman', 'ታሪክ እና ተወዳጆች'),
        _t(appLanguage, 'Keep track of translations and save useful items.', 'Hiikkaa kee hordofi; wantoota barbaachisoo olkaa’i.', 'የትርጉም ታሪክን ይከታተሉ እና ጠቃሚ ነገሮችን ያስቀምጡ።'),
        Icons.favorite_outline_rounded,
        Colors.pink,
      ),
    ];

    final technologies = <_AboutEntry>[
      _AboutEntry(
        'Flutter',
        _t(appLanguage, 'Builds the app interface for Android.', 'Fuula appicha Android irratti ijaara.', 'የAndroid መተግበሪያ ገጽታን ይገነባል።'),
        Icons.phone_android_rounded,
        Colors.blue,
      ),
      _AboutEntry(
        'Dart',
        _t(appLanguage, 'Programming language used to develop Hiikaa.', 'Afaan programming Hiikaa ittiin hojjetame.', 'Hiikaa ለመገንባት የተጠቀምንበት የፕሮግራሚንግ ቋንቋ።'),
        Icons.code_rounded,
        Colors.indigo,
      ),
      _AboutEntry(
        'SQLite + sqflite',
        _t(appLanguage, 'Stores app data locally on the device.', 'Daataa appicha bilbila keessatti kuusa.', 'የመተግበሪያ መረጃን በስልኩ ውስጥ ያስቀምጣል።'),
        Icons.storage_rounded,
        Colors.teal,
      ),
      _AboutEntry(
        'SharedPreferences',
        _t(appLanguage, 'Remembers small app settings and preferences.', 'Settings fi filannoo xixiqqoo yaadachiisa.', 'ትንንሽ የመተግበሪያ ቅንብሮችን ያስታውሳል።'),
        Icons.tune_rounded,
        Colors.orange,
      ),
      _AboutEntry(
        'path + path_provider',
        _t(appLanguage, 'Finds safe file and database locations.', 'Bakka faayilaa fi database argachuuf gargaara.', 'የፋይል እና የዳታቤዝ ቦታዎችን ያገኛል።'),
        Icons.folder_open_rounded,
        Colors.brown,
      ),
      _AboutEntry(
        'cryptography',
        _t(appLanguage, 'Provides AES-256-GCM encryption for private notes.', 'Private notes AES-256-GCM’n icciitii godha.', 'የግል ማስታወሻዎችን በAES-256-GCM ይመሰጥራል።'),
        Icons.enhanced_encryption_rounded,
        Colors.redAccent,
      ),
      _AboutEntry(
        'flutter_secure_storage',
        _t(appLanguage, 'Stores sensitive security keys safely.', 'Furtuuwwan nageenyaa bakka eegumsa qabu keessatti kuusa.', 'ሚስጥራዊ የደህንነት ቁልፎችን በጥንቃቄ ያስቀምጣል።'),
        Icons.security_rounded,
        Colors.green,
      ),
      _AboutEntry(
        'flutter_quill',
        _t(appLanguage, 'Supports rich-text note editing.', 'Yaadannoo barruu bareechuu fi gulaaluu gargaara.', 'የበለጸገ ጽሑፍ ማስታወሻ ማስተካከልን ይደግፋል።'),
        Icons.edit_note_rounded,
        Colors.deepPurple,
      ),
      _AboutEntry(
        'Noto Sans Ethiopic',
        _t(appLanguage, 'Displays Ethiopic and Amharic characters.', 'Qubee Afaan Amaaraa fi mallattoolee Ethiopic agarsiisa.', 'የአማርኛ እና የኢትዮጵያ ፊደላትን ያሳያል።'),
        Icons.text_fields_rounded,
        Colors.pink,
      ),
      _AboutEntry(
        'FLORES-200',
        _t(appLanguage, 'Provides multilingual sentence data from Meta AI.', 'Daataa himoota afaanota hedduu Meta AI irraa kenna.', 'ከMeta AI የብዙ ቋንቋዎች የዓረፍተ ነገር መረጃ ያቀርባል።'),
        Icons.language_rounded,
        Colors.cyan,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_t(appLanguage, 'About Hiikaa', 'Waa’ee Hiikaa', 'ስለ Hiikaa')),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primary,
                  colors.tertiary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: colors.onPrimary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.translate_rounded,
                    size: 36,
                    color: colors.onPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Hiikaa',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _t(
                    appLanguage,
                    'Connecting languages, bringing people closer.',
                    'Afaanota walitti fiduun namoota walitti dhiyeessuu.',
                    'ቋንቋዎችን በማገናኘት ሰዎችን ማቀራረብ።',
                  ),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onPrimary.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionCard(
            context: context,
            title: _t(appLanguage, 'About the app', 'Waa’ee appichaa', 'ስለ መተግበሪያው'),
            icon: Icons.info_outline_rounded,
            color: Colors.blue,
            child: Text(
              _t(
                appLanguage,
                'Hiikaa helps people explore English, Afaan Oromoo and Amharic language data offline.',
                'Hiikaan namoonni daataa afaan Ingiliffaa, Afaan Oromoo fi Afaan Amaaraa interneetii malee akka fayyadaman gargaara.',
                'Hiikaa የእንግሊዝኛ፣ የኦሮምኛ እና የአማርኛ መረጃን ያለ ኢንተርኔት እንዲጠቀሙ ይረዳል።',
              ),
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
          ),
          _sectionCard(
            context: context,
            title: _t(appLanguage, 'Main features', 'Amaloota ijoo', 'ዋና ዋና ባህሪያት'),
            icon: Icons.auto_awesome_rounded,
            color: Colors.deepPurple,
            child: _entryList(context, features),
          ),
          _sectionCard(
            context: context,
            title: _t(appLanguage, 'Technologies used', 'Teeknooloojiiwwan fayyadaman', 'የተጠቀምናቸው ቴክኖሎጂዎች'),
            icon: Icons.developer_board_rounded,
            color: Colors.teal,
            child: _entryList(context, technologies),
          ),
          _sectionCard(
            context: context,
            title: _t(appLanguage, 'Developer & Contact', 'Developer fi Quunnamtii', 'ገንቢ እና ግንኙነት'),
            icon: Icons.person_outline_rounded,
            color: Colors.orange,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  devName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _t(
                    appLanguage,
                    'Software Engineering Student',
                    'Barataa Software Engineering',
                    'የሶፍትዌር ምህንድስና ተማሪ',
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bule Hora University',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.code_rounded),
                  title: const Text('GitHub • olifman'),
                  onTap: () => _openContact('https://github.com/olifman'),
                ),                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.language_rounded, color: Colors.teal),
                  title: const Text('Portfolio Website'),
                  subtitle: const Text('lamesa-bekele.netlify.app'),
                  onTap: () => _openContact('https://lamesa-bekele.netlify.app'),
                ),
              ],
            ),
          ),
          _sectionCard(
            context: context,
            title: _t(appLanguage, 'Version and data sources', 'Versionii fi madda daataa', 'ስሪት እና የመረጃ ምንጮች'),
            icon: Icons.verified_outlined,
            color: Colors.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hiikaa $appVersionText',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _t(
                    appLanguage,
                    'Sentence data: FLORES-200 by Meta AI (CC BY-SA 4.0), together with the phrasebook and app vocabulary.',
                    'Daataan himootaa: FLORES-200 kan Meta AI (CC BY-SA 4.0), kuusaa himootaa fi jechoota appichaa waliin.',
                    'የዓረፍተ ነገር መረጃ፦ FLORES-200 ከMeta AI (CC BY-SA 4.0) እንዲሁም የሐረጎች እና የመተግበሪያው ቃላት ስብስብ።',
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
