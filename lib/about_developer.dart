import 'package:flutter/material.dart';

import 'app_localizations.dart';

const String devName = 'Lamesa Bekele';
const String appVersionText = '0.3 (beta)';

const Map<String, Map<AppLanguage, String>> _about = {
  'title': {
    AppLanguage.en: 'About Hiikaa',
    AppLanguage.om: 'Waa’ee Hiikaa',
    AppLanguage.am: 'ስለ Hiikaa',
  },
  'tagline': {
    AppLanguage.en: 'Connecting languages, bringing people closer.',
    AppLanguage.om: 'Afaanota walitti fiduun namoota walitti dhiyeessuu.',
    AppLanguage.am: 'ቋንቋዎችን በማገናኘት ሰዎችን ማቀራረብ።',
  },
  'purpose_title': {
    AppLanguage.en: 'About the app',
    AppLanguage.om: 'Waa’ee appichaa',
    AppLanguage.am: 'ስለ መተግበሪያው',
  },
  'purpose': {
    AppLanguage.en: 'Hiikaa is an offline translator designed to help people translate between English, Afaan Oromoo and Amharic without an internet connection.',
    AppLanguage.om: 'Hiikaan appii interneetii malee afaan Ingiliffaa, Afaan Oromoo fi Afaan Amaaraa gidduutti hiikuuf qophaa’eedha.',
    AppLanguage.am:
        'Hiikaa ያለ ኢንተርኔት በእንግሊዝኛ፣ በኦሮምኛ እና በአማርኛ መካከል ለመተርጎም የተዘጋጀ መተግበሪያ ነው።',
  },
  'developer_title': {
    AppLanguage.en: 'Developer',
    AppLanguage.om: 'Nama appicha hojjetee',
    AppLanguage.am: 'ገንቢ',
  },
  'role': {
    AppLanguage.en: 'Software Engineering student',
    AppLanguage.om: 'Barataa Software Engineering',
    AppLanguage.am: 'የሶፍትዌር ምህንድስና ተማሪ',
  },
  'version_title': {
    AppLanguage.en: 'App version',
    AppLanguage.om: 'Versionii appichaa',
    AppLanguage.am: 'የመተግበሪያው ስሪት',
  },
  'sources_title': {
    AppLanguage.en: 'Data sources',
    AppLanguage.om: 'Madda daataa',
    AppLanguage.am: 'የመረጃ ምንጮች',
  },
  'sources': {
    AppLanguage.en: 'FLORES-200 by Meta AI, licensed under CC BY-SA 4.0, and the phrasebook prepared for this app.',
    AppLanguage.om: 'FLORES-200 kan Meta AI, hayyama CC BY-SA 4.0 jalatti; akkasumas kuusaa jechootaa appii kanaaf qophaa’e.',
    AppLanguage.am: 'በCC BY-SA 4.0 ፈቃድ የተለቀቀው FLORES-200 በMeta AI እና ለዚህ መተግበሪያ የተዘጋጀው የቃላት ስብስብ።',
  },
};

String _aboutText(AppLanguage language, String key) {
  return _about[key]?[language] ?? _about[key]?[AppLanguage.en] ?? key;
}

class AboutDeveloperPage extends StatelessWidget {
  const AboutDeveloperPage({super.key, required this.appLanguage});

  final AppLanguage appLanguage;

  Widget _infoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colors.surfaceContainerLow,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colors.primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_aboutText(appLanguage, 'title')),
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
                  colors.primary.withValues(alpha: 0.78),
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
                  _aboutText(appLanguage, 'tagline'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onPrimary.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _infoCard(
            context: context,
            icon: Icons.info_outline_rounded,
            title: _aboutText(appLanguage, 'purpose_title'),
            content: Text(
              _aboutText(appLanguage, 'purpose'),
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
          ),

          _infoCard(
            context: context,
            icon: Icons.person_outline_rounded,
            title: _aboutText(appLanguage, 'developer_title'),
            content: Column(
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
                  _aboutText(appLanguage, 'role'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          _infoCard(
            context: context,
            icon: Icons.verified_outlined,
            title: _aboutText(appLanguage, 'version_title'),
            content: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  appVersionText,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          _infoCard(
            context: context,
            icon: Icons.menu_book_outlined,
            title: _aboutText(appLanguage, 'sources_title'),
            content: Text(
              _aboutText(appLanguage, 'sources'),
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
