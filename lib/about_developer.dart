import 'package:flutter/material.dart';

import 'app_localizations.dart';

// ---- Jijjiiruu dandeessa (duwwaa yoo ta'e app keessatti hin mul'atu) ----
const String devName = 'Lamesa Bekele';
const String devUniversity = '';
const String devEmail = '';
const String devPhone = '';
const String appVersionText = '0.3 (beta)';
// -------------------------------------------------------------------------

const Map<String, Map<AppLanguage, String>> _about = {
  'about_title': {
    AppLanguage.en: 'About the developer',
    AppLanguage.om: 'Waa’ee kan hojjete',
    AppLanguage.am: 'ስለ ገንቢው',
  },
  'about_tile_sub': {
    AppLanguage.en: 'Developer and app information',
    AppLanguage.om: 'Odeeffannoo kan hojjete fi appii',
    AppLanguage.am: 'የገንቢውና የመተግበሪያው መረጃ',
  },
  'developed_by': {
    AppLanguage.en: 'Developed by',
    AppLanguage.om: 'Kan hojjete',
    AppLanguage.am: 'የተሠራው በ',
  },
  'role': {
    AppLanguage.en: 'Software Engineering student',
    AppLanguage.om: 'Barataa Software Engineering',
    AppLanguage.am: 'የሶፍትዌር ምህንድስና ተማሪ',
  },
  'university': {
    AppLanguage.en: 'University',
    AppLanguage.om: 'Yuunivarsiitii',
    AppLanguage.am: 'ዩኒቨርሲቲ',
  },
  'contact': {
    AppLanguage.en: 'Contact',
    AppLanguage.om: 'Quunnamtii',
    AppLanguage.am: 'ግንኙነት',
  },
  'about_app': {
    AppLanguage.en: 'About Hiikaa',
    AppLanguage.om: 'Waa’ee Hiikaa',
    AppLanguage.am: 'ስለ Hiikaa',
  },
  'about_app_text': {
    AppLanguage.en:
        'Hiikaa is an offline translator for English, Afaan Oromoo and Amharic. It works without internet, so people in places with little or no connection can use it.',
    AppLanguage.om:
        'Hiikaan afaan Ingiliffaa, Afaan Oromoo fi Amaaraa gidduutti interneetii malee hiika. Namoonni interneetii hin qabne illee itti fayyadamuu danda’u.',
    AppLanguage.am:
        'Hiikaa በእንግሊዝኛ፣ በኦሮምኛ እና በአማርኛ መካከል ያለ ኢንተርኔት የሚተረጉም መተግበሪያ ነው። ኢንተርኔት በሌለባቸው ቦታዎችም መጠቀም ይቻላል።',
  },
  'version': {
    AppLanguage.en: 'Version',
    AppLanguage.om: 'Version',
    AppLanguage.am: 'ስሪት',
  },
  'data_sources': {
    AppLanguage.en: 'Data sources',
    AppLanguage.om: 'Madda daataa',
    AppLanguage.am: 'የመረጃ ምንጮች',
  },
  'data_sources_text': {
    AppLanguage.en:
        'Sentences: FLORES-200 (Meta AI), licensed CC BY-SA 4.0. Phrasebook: written for this app.',
    AppLanguage.om:
        'Himoota: FLORES-200 (Meta AI), CC BY-SA 4.0. Kuusaa jechootaa: appii kanaaf barreeffame.',
    AppLanguage.am:
        'ዓረፍተ ነገሮች፦ FLORES-200 (Meta AI)፣ CC BY-SA 4.0። የቃላት መዝገብ፦ ለዚህ መተግበሪያ የተጻፈ።',
  },
  'draft_note': {
    AppLanguage.en:
        'Many phrases are still drafts and are being reviewed by native speakers. Please do not rely on them for medical or legal decisions.',
    AppLanguage.om:
        'Jechoonni fi himoonni baay’een ammaaf Draft dha; dubbattoota afaanii irraa mirkaneeffamaa jira. Murtee fayyaa yookiin seeraaf itti hin hirkatin.',
    AppLanguage.am:
        'ብዙዎቹ ሐረጎች ገና ረቂቅ ናቸው፤ በቋንቋ ባለሙያዎች እየተረጋገጡ ነው። ለሕክምና ወይም ለሕግ ውሳኔ አትመኩባቸው።',
  },
  'thanks': {
    AppLanguage.en: 'Thank you for using Hiikaa.',
    AppLanguage.om: 'Hiikaa fayyadamuu keef galatoomi.',
    AppLanguage.am: 'Hiikaa ስለተጠቀሙ እናመሰግናለን።',
  },
};

String _t(AppLanguage lang, String key) =>
    _about[key]?[lang] ?? _about[key]?[AppLanguage.en] ?? key;

/// Tile to place inside the Settings list.
class AboutDeveloperTile extends StatelessWidget {
  const AboutDeveloperTile({super.key, required this.appLanguage});
  final AppLanguage appLanguage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: Text(_t(appLanguage, 'about_title')),
      subtitle: Text(_t(appLanguage, 'about_tile_sub')),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AboutDeveloperPage(appLanguage: appLanguage),
        ),
      ),
    );
  }
}

class AboutDeveloperPage extends StatelessWidget {
  const AboutDeveloperPage({super.key, required this.appLanguage});
  final AppLanguage appLanguage;

  String _initials() {
    final parts = devName.trim().split(RegExp(r'\s+'));
    final a = parts.isNotEmpty && parts[0].isNotEmpty ? parts[0][0] : '';
    final b = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return (a + b).toUpperCase();
  }

  Widget _section(BuildContext context, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(body),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: SelectableText(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(_t(appLanguage, 'about_title'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                _initials(),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: scheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              _t(appLanguage, 'developed_by'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Center(
            child: Text(
              devName,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 4),
          Center(child: Text(_t(appLanguage, 'role'))),
          if (devUniversity.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Center(child: Text(devUniversity)),
            ),
          const SizedBox(height: 18),
          if (devEmail.isNotEmpty || devPhone.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _t(appLanguage, 'contact'),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (devEmail.isNotEmpty) _info(Icons.email_outlined, devEmail),
                  if (devPhone.isNotEmpty) _info(Icons.phone_outlined, devPhone),
                ],
              ),
            ),
          const Divider(),
          const SizedBox(height: 12),
          _section(context, _t(appLanguage, 'about_app'),
              _t(appLanguage, 'about_app_text')),
          _section(context, _t(appLanguage, 'version'), appVersionText),
          _section(context, _t(appLanguage, 'data_sources'),
              _t(appLanguage, 'data_sources_text')),
          _section(context, '', _t(appLanguage, 'draft_note')),
          const SizedBox(height: 8),
          Center(child: Text(_t(appLanguage, 'thanks'))),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}