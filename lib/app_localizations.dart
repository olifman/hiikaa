enum AppLanguage { en, om, am }

const appLanguageLabel = {
  AppLanguage.en: 'English',
  AppLanguage.om: 'Afaan Oromoo',
  AppLanguage.am: 'አማርኛ',
};

const Map<String, Map<AppLanguage, String>> _translations = {
  'translate': {
    AppLanguage.en: 'Translate',
    AppLanguage.om: 'Hiiki',
    AppLanguage.am: 'ተርጉም',
  },
  'phrasebook': {
    AppLanguage.en: 'Phrasebook',
    AppLanguage.om: 'Kuusaa jechootaa',
    AppLanguage.am: 'የቃላት መዝገብ',
  },
  'sentences': {
    AppLanguage.en: 'Sentences',
    AppLanguage.om: 'Himoota',
    AppLanguage.am: 'ዓረፍተ ነገሮች',
  },
  'notes': {
    AppLanguage.en: 'My Notes',
    AppLanguage.om: 'Yaadannoo koo',
    AppLanguage.am: 'ማስታወሻዎቼ',
  },
  'settings': {
    AppLanguage.en: 'Settings',
    AppLanguage.om: 'Qindaa’ina',
    AppLanguage.am: 'ቅንብሮች',
  },
  'history': {
    AppLanguage.en: 'History',
    AppLanguage.om: 'Seenaa hiikkaa',
    AppLanguage.am: 'የትርጉም ታሪክ',
  },
  'search': {
    AppLanguage.en: 'Search',
    AppLanguage.om: 'Barbaadi',
    AppLanguage.am: 'ፈልግ',
  },
  'search_phrases': {
    AppLanguage.en: 'Search all phrases',
    AppLanguage.om: 'Jechoota hunda barbaadi',
    AppLanguage.am: 'ሁሉንም ሐረጎች ፈልግ',
  },
  'search_sentences': {
    AppLanguage.en: 'Search sentences in any language',
    AppLanguage.om: 'Himoota afaan kamiinuu barbaadi',
    AppLanguage.am: 'በማንኛውም ቋንቋ ዓረፍተ ነገሮችን ፈልግ',
  },
  'search_notes': {
    AppLanguage.en: 'Search notes...',
    AppLanguage.om: 'Yaadannoo barbaadi...',
    AppLanguage.am: 'ማስታወሻዎችን ፈልግ...',
  },
  'enter_text': {
    AppLanguage.en: 'Enter text',
    AppLanguage.om: 'Barruu galchi',
    AppLanguage.am: 'ጽሑፍ ያስገቡ',
  },
  'type_phrase': {
    AppLanguage.en: 'Type a word or phrase...',
    AppLanguage.om: 'Jechas ta’e hima barreessi...',
    AppLanguage.am: 'ቃል ወይም ሐረግ ይጻፉ...',
  },
  'translation_result': {
    AppLanguage.en: 'Translation result',
    AppLanguage.om: 'Bu’aa hiikkaa',
    AppLanguage.am: 'የትርጉም ውጤት',
  },
  'copy': {
    AppLanguage.en: 'Copy',
    AppLanguage.om: 'Garagalchi',
    AppLanguage.am: 'ቅዳ',
  },
  'copied': {
    AppLanguage.en: 'Copied',
    AppLanguage.om: 'Garagalfameera',
    AppLanguage.am: 'ተቀድቷል',
  },
  'previous': {
    AppLanguage.en: 'Previous',
    AppLanguage.om: 'Kan duraa',
    AppLanguage.am: 'ቀዳሚ',
  },
  'next': {
    AppLanguage.en: 'Next',
    AppLanguage.om: 'Kan itti aanu',
    AppLanguage.am: 'ቀጣይ',
  },
  'all': {
    AppLanguage.en: 'All',
    AppLanguage.om: 'Hunda',
    AppLanguage.am: 'ሁሉም',
  },
  'saved': {
    AppLanguage.en: 'Saved',
    AppLanguage.om: 'Kan kuufame',
    AppLanguage.am: 'የተቀመጡ',
  },
  'no_phrases': {
    AppLanguage.en: 'No phrases found',
    AppLanguage.om: 'Jechoonni hin argamne',
    AppLanguage.am: 'ምንም ሐረጎች አልተገኙም',
  },
  'no_sentences': {
    AppLanguage.en: 'No sentences found',
    AppLanguage.om: 'Himoonni hin argamne',
    AppLanguage.am: 'ምንም ዓረፍተ ነገሮች አልተገኙም',
  },
  'explore_sentences': {
    AppLanguage.en: 'Explore sentences',
    AppLanguage.om: 'Himoota qoradhu',
    AppLanguage.am: 'ዓረፍተ ነገሮችን ያስሱ',
  },
  'app_language': {
    AppLanguage.en: 'App language',
    AppLanguage.om: 'Afaan appii',
    AppLanguage.am: 'የመተግበሪያ ቋንቋ',
  },
  'appearance': {
    AppLanguage.en: 'Appearance',
    AppLanguage.om: 'Bifa',
    AppLanguage.am: 'መልክ',
  },
  'dark_theme': {
    AppLanguage.en: 'Dark theme',
    AppLanguage.om: 'Bifa dukkanaa’aa',
    AppLanguage.am: 'ጨለማ ገጽታ',
  },
  'use_dark_appearance': {
    AppLanguage.en: 'Use a dark appearance',
    AppLanguage.om: 'Bifa dukkanaa’aa fayyadami',
    AppLanguage.am: 'ጨለማ ገጽታ ይጠቀሙ',
  },
  'text_size': {
    AppLanguage.en: 'Text size',
    AppLanguage.om: 'Hammamtaa barruu',
    AppLanguage.am: 'የጽሑፍ መጠን',
  },
  'small': {
    AppLanguage.en: 'Small',
    AppLanguage.om: 'Xiqqaa',
    AppLanguage.am: 'ትንሽ',
  },
  'medium': {
    AppLanguage.en: 'Medium',
    AppLanguage.om: 'Giddugaleessa',
    AppLanguage.am: 'መካከለኛ',
  },
  'large': {
    AppLanguage.en: 'Large',
    AppLanguage.om: 'Guddaa',
    AppLanguage.am: 'ትልቅ',
  },
  'data': {
    AppLanguage.en: 'Data',
    AppLanguage.om: 'Kuusaa odeeffannoo',
    AppLanguage.am: 'ዳታ',
  },
  'clear_history': {
    AppLanguage.en: 'Clear translation history',
    AppLanguage.om: 'Seenaa hiikkaa haqi',
    AppLanguage.am: 'የትርጉም ታሪክን አጽዳ',
  },
  'about': {
    AppLanguage.en: 'About',
    AppLanguage.om: 'Waa’ee appii',
    AppLanguage.am: 'ስለ መተግበሪያው',
  },
  'cancel': {
    AppLanguage.en: 'Cancel',
    AppLanguage.om: 'Dhiisi',
    AppLanguage.am: 'ይቅር',
  },
  'clear': {
    AppLanguage.en: 'Clear',
    AppLanguage.om: 'Haqi',
    AppLanguage.am: 'አጽዳ',
  },
  'ok': {AppLanguage.en: 'OK', AppLanguage.om: 'Tole', AppLanguage.am: 'እሺ'},
  'favorites_only': {
    AppLanguage.en: 'Favorites only',
    AppLanguage.om: 'Jaallatamoo qofa',
    AppLanguage.am: 'ተወዳጆች ብቻ',
  },
  'new_note': {
    AppLanguage.en: 'New note',
    AppLanguage.om: 'Yaadannoo haaraa',
    AppLanguage.am: 'አዲስ ማስታወሻ',
  },
  'edit_note': {
    AppLanguage.en: 'Edit note',
    AppLanguage.om: 'Yaadannoo gulaali',
    AppLanguage.am: 'ማስታወሻ አርትዕ',
  },
  'enter_note_title': {
    AppLanguage.en: 'Please enter a title.',
    AppLanguage.om: 'Mata-duree galchi.',
    AppLanguage.am: 'እባክዎ ርዕስ ያስገቡ።',
  },
  'title': {
    AppLanguage.en: 'Title',
    AppLanguage.om: 'Mata-duree',
    AppLanguage.am: 'ርዕስ',
  },
  'content': {
    AppLanguage.en: 'Your text',
    AppLanguage.om: 'Barreeffama kee',
    AppLanguage.am: 'ጽሑፍዎ',
  },
  'write_here': {
    AppLanguage.en: 'Write your thoughts here...',
    AppLanguage.om: 'Yaada kee asitti barreessi...',
    AppLanguage.am: 'ሐሳብዎን እዚህ ይጻፉ...',
  },
  'category': {
    AppLanguage.en: 'Category',
    AppLanguage.om: 'Ramaddii',
    AppLanguage.am: 'ምድብ',
  },
  'icon': {
    AppLanguage.en: 'Icon',
    AppLanguage.om: 'Mallattoo',
    AppLanguage.am: 'ምልክት',
  },
  'color': {
    AppLanguage.en: 'Color',
    AppLanguage.om: 'Halluu',
    AppLanguage.am: 'ቀለም',
  },
  'save': {
    AppLanguage.en: 'Save',
    AppLanguage.om: 'Kuusi',
    AppLanguage.am: 'አስቀምጥ',
  },
  'delete': {
    AppLanguage.en: 'Delete',
    AppLanguage.om: 'Haqi',
    AppLanguage.am: 'ሰርዝ',
  },
  'private_note': {
    AppLanguage.en: 'Private note',
    AppLanguage.om: 'Yaadannoo iccitii',
    AppLanguage.am: 'የግል ማስታወሻ',
  },
  'no_notes': {
    AppLanguage.en: 'No notes yet',
    AppLanguage.om: 'Yaadannoon hin jiru',
    AppLanguage.am: 'ገና ማስታወሻ የለም',
  },
  'note_category_faith': {
    AppLanguage.en: 'Faith',
    AppLanguage.om: 'Mana Amantii',
    AppLanguage.am: 'እምነት',
  },
  'note_category_private': {
    AppLanguage.en: 'Private',
    AppLanguage.om: 'Iccitii',
    AppLanguage.am: 'የግል',
  },
  'note_category_study': {
    AppLanguage.en: 'Study',
    AppLanguage.om: 'Barnoota',
    AppLanguage.am: 'ትምህርት',
  },
  'note_category_personal': {
    AppLanguage.en: 'Personal',
    AppLanguage.om: 'Dhuunfaa',
    AppLanguage.am: 'የግል ጉዳይ',
  },
  'note_category_ideas': {
    AppLanguage.en: 'Ideas',
    AppLanguage.om: 'Yaada',
    AppLanguage.am: 'ሐሳቦች',
  },
  'note_category_other': {
    AppLanguage.en: 'Other',
    AppLanguage.om: 'Kan Biro',
    AppLanguage.am: 'ሌላ',
  },
  'note_search_hint': {
    AppLanguage.en: 'Search notes...',
    AppLanguage.om: 'Yaadannoo barbaadi...',
    AppLanguage.am: 'ማስታወሻዎችን ፈልግ...',
  },
  'notes_description': {
    AppLanguage.en: 'Keep your thoughts in one place.',
    AppLanguage.om: 'Yaada kee bakka tokkootti kuusi.',
    AppLanguage.am: 'ሐሳቦችህን በአንድ ቦታ አስቀምጥ።',
  },
  'save_your_ideas': {
    AppLanguage.en: 'Save your ideas.',
    AppLanguage.om: 'Yaada kee kuusi.',
    AppLanguage.am: 'ሐሳቦችህን አስቀምጥ።',
  },
  'start_first_note': {
    AppLanguage.en: 'Tap + to create your first note.',
    AppLanguage.om: 'Yaadannoo kee jalqabuuf + tuqi.',
    AppLanguage.am: 'የመጀመሪያ ማስታወሻህን ለመፍጠር + ንካ።',
  },
  'note_error': {
    AppLanguage.en: 'Error: ',
    AppLanguage.om: 'Dogoggora: ',
    AppLanguage.am: 'ስህተት፦ ',
  },
  'note_count_private': {
    AppLanguage.en: 'Private note',
    AppLanguage.om: 'Yaadannoo iccitii',
    AppLanguage.am: 'ሚስጥራዊ ማስታወሻ',
  },
  'pin_length': {
    AppLanguage.en: 'PIN (6-12 digits)',
    AppLanguage.om: 'PIN (lakkoofsa 6-12)',
    AppLanguage.am: 'PIN (6-12 አሃዞች)',
  },
  'pin_length_error': {
    AppLanguage.en: 'PIN must contain 6 to 12 digits.',
    AppLanguage.om: 'PIN lakkoofsa 6 hanga 12 qabaachuu qaba.',
    AppLanguage.am: 'PIN ከ6 እስከ 12 አሃዞች መያዝ አለበት።',
  },
  'private_lock_warning': {
    AppLanguage.en:
        'Changing a private note to a public note may expose its content.',
    AppLanguage.om: 'Yaadannoo iccitii gara uummataatti jijjiiruun qabiyyee isaa namootaaf mul’isuu danda’a.',
    AppLanguage.am: 'ሚስጥራዊ ማስታወሻን ወደ ይፋዊ ማስታወሻ መቀየር ይዘቱን ለሌሎች ሊያሳይ ይችላል።',
  },
  'pin_enter_title': {
    AppLanguage.en: 'Enter PIN',
    AppLanguage.om: 'PIN galchi',
    AppLanguage.am: 'PIN አስገባ',
  },
  'pin_label': {
    AppLanguage.en: 'PIN',
    AppLanguage.om: 'PIN',
    AppLanguage.am: 'PIN',
  },
  'forgot_pin': {
    AppLanguage.en: 'Forgot PIN?',
    AppLanguage.om: 'PIN dagattee?',
    AppLanguage.am: 'PIN ረሳህ?',
  },
  'unlock': {
    AppLanguage.en: 'Unlock',
    AppLanguage.om: 'Bani',
    AppLanguage.am: 'ክፈት',
  },
  'wrong_pin': {
    AppLanguage.en: 'Incorrect PIN.',
    AppLanguage.om: 'PIN sirrii miti.',
    AppLanguage.am: 'ትክክለኛ ያልሆነ PIN።',
  },
  'recovery_code_title': {
    AppLanguage.en: 'Your recovery code',
    AppLanguage.om: 'Koodii deebisanii argachuu kee',
    AppLanguage.am: 'የመልሶ ማግኛ ኮድህ',
  },
  'recovery_code_instruction': {
    AppLanguage.en: 'Store this code somewhere safe. You will need it if you forget your PIN.',
    AppLanguage.om: 'Koodii kana bakka nageenya qabu kuusi. PIN yoo dagatte si barbaachisa.',
    AppLanguage.am: 'ይህን ኮድ በደህና ቦታ አስቀምጥ። PIN ከረሳህ ያስፈልግሃል።',
  },
  'recovery_code_saved': {
    AppLanguage.en: 'I have saved it',
    AppLanguage.om: 'Kuuseera',
    AppLanguage.am: 'አስቀምጫለሁ',
  },
  'pin_setup_error': {
    AppLanguage.en: 'Could not set up PIN: ',
    AppLanguage.om: 'PIN qopheessuun hin milkoofne: ',
    AppLanguage.am: 'PIN ማዘጋጀት አልተሳካም፦ ',
  },
  'pin_setup_title': {
    AppLanguage.en: 'Set up private PIN',
    AppLanguage.om: 'PIN iccitii qopheessi',
    AppLanguage.am: 'ሚስጥራዊ PIN አዘጋጅ',
  },
  'pin_setup_instruction': {
    AppLanguage.en: 'Choose a PIN with 6 to 12 digits.',
    AppLanguage.om: 'PIN lakkoofsa 6 hanga 12 qabu filadhu.',
    AppLanguage.am: 'ከ6 እስከ 12 አሃዞች ያሉት PIN ምረጥ።',
  },
  'new_pin': {
    AppLanguage.en: 'New PIN',
    AppLanguage.om: 'PIN haaraa',
    AppLanguage.am: 'አዲስ PIN',
  },
  'confirm_pin': {
    AppLanguage.en: 'Confirm PIN',
    AppLanguage.om: 'PIN irra deebi’i',
    AppLanguage.am: 'PIN እንደገና አስገባ',
  },
  'setup_pin': {
    AppLanguage.en: 'Set up',
    AppLanguage.om: 'Qopheessi',
    AppLanguage.am: 'አዘጋጅ',
  },
  'pin_validation': {
    AppLanguage.en: 'PIN must be 6 to 12 digits.',
    AppLanguage.om: 'PIN lakkoofsa 6 hanga 12 ta’uu qaba.',
    AppLanguage.am: 'PIN ከ6 እስከ 12 አሃዞች መሆን አለበት።',
  },
  'swap_languages': {
    AppLanguage.en: 'Swap languages',
    AppLanguage.om: 'Afaan wal jijjiiri',
    AppLanguage.am:
        '\u124B\u1295\u124B\u12CE\u127D\u1295 \u1240\u12EB\u12ED\u122D',
  },
  'nothing_here_yet': {
    AppLanguage.en: 'Nothing here yet',
    AppLanguage.om: 'Hanga ammaa homtuu hin jiru',
    AppLanguage.am:
        '\u12A5\u1235\u12AB\u1201\u1295 \u121D\u1295\u121D \u12E8\u1208\u121D',
  },
  'clear_all': {
    AppLanguage.en: 'Clear all',
    AppLanguage.om: 'Hunda haqi',
    AppLanguage.am: '\u1201\u1209\u1295\u121D \u12A0\u133D\u12F3',
  },
  'change_pin': {
    AppLanguage.en: 'Change PIN',
    AppLanguage.om: 'PIN jijjiiri',
    AppLanguage.am: 'PIN \u1240\u12ED\u122D',
  },
  'lock_private_notes': {
    AppLanguage.en: 'Lock private notes',
    AppLanguage.om: 'Yaadannoo iccitii cufi',
    AppLanguage.am: '\u121A\u1235\u1325\u122B\u12CA \u121B\u1235\u1273\u12C8\u123B \u1246\u120D\u134D',
  },
  'private_notes_access': {
    AppLanguage.en: 'Open private notes',
    AppLanguage.om: 'Yaadannoo iccitii bani',
    AppLanguage.am: '\u121A\u1235\u1325\u122B\u12CA \u121B\u1235\u1273\u12C8\u123B \u12AD\u1348\u1275',
  },
  'pin_mismatch': {
    AppLanguage.en: 'The two PINs do not match.',
    AppLanguage.om: 'PIN lamaan wal hin fakkaatan.',
    AppLanguage.am: 'ሁለቱ PIN አይዛመዱም።',
  },
  'use_recovery_code': {
    AppLanguage.en: 'Use recovery code',
    AppLanguage.om: 'Koodii deebisanii argachuu fayyadami',
    AppLanguage.am: 'የመልሶ ማግኛ ኮድ ተጠቀም',
  },
  'recovery_code_label': {
    AppLanguage.en: 'Recovery code',
    AppLanguage.om: 'Koodii deebisanii argachuu',
    AppLanguage.am: 'የመልሶ ማግኛ ኮድ',
  },
  'recovery_code_error': {
    AppLanguage.en: 'Incorrect recovery code.',
    AppLanguage.om: 'Koodiin deebisanii argachuu sirrii miti.',
    AppLanguage.am: 'የመልሶ ማግኛ ኮዱ ትክክል አይደለም።',
  },
  'note_save_error': {
    AppLanguage.en: 'Could not save note: ',
    AppLanguage.om: 'Yaadannoo olkaa’uu hin dandeenye: ',
    AppLanguage.am: 'ማስታወሻውን ማስቀመጥ አልተቻለም፦ ',
  },
  'delete_note_title': {
    AppLanguage.en: 'Delete note?',
    AppLanguage.om: 'Yaadannoo haquu?',
    AppLanguage.am: 'ማስታወሻውን ልሰርዝ?',
  },
  'delete_note_message': {
    AppLanguage.en: 'Do you want to delete this note?',
    AppLanguage.om: 'Yaadannoo kana haquu barbaaddaa?',
    AppLanguage.am: 'ይህን ማስታወሻ መሰረዝ ትፈልጋለህ?',
  },
  'no': {AppLanguage.en: 'No', AppLanguage.om: 'Lakki', AppLanguage.am: 'አይ'},
  'favorite_remove': {
    AppLanguage.en: 'Remove from favorites',
    AppLanguage.om: 'Jaallatamoo keessaa baasi',
    AppLanguage.am: 'ከተወዳጆች አስወግድ',
  },
  'favorite_add': {
    AppLanguage.en: 'Add to favorites',
    AppLanguage.om: 'Jaallatamoo keessatti dabali',
    AppLanguage.am: 'ወደ ተወዳጆች ጨምር',
  },
  'edit': {
    AppLanguage.en: 'Edit',
    AppLanguage.om: 'Gulaali',
    AppLanguage.am: 'አርትዕ',
  },
  'custom_category': {
    AppLanguage.en: 'Custom category (optional)',
    AppLanguage.om: 'Ramaddii mataa keetii (filannoo)',
    AppLanguage.am: 'ብጁ ምድብ (አማራጭ)',
  },
  'custom_category_hint': {
    AppLanguage.en: 'Example: 2027 plan',
    AppLanguage.om: 'Fakkeenya: Karoora 2027',
    AppLanguage.am: 'ምሳሌ፦ የ2027 እቅድ',
  },
  'font_size': {
    AppLanguage.en: 'Text size',
    AppLanguage.om: 'Hammamtaa barruu',
    AppLanguage.am: 'የጽሑፍ መጠን',
  },
  'favorite': {
    AppLanguage.en: 'Favorites',
    AppLanguage.om: 'Jaallatamoo',
    AppLanguage.am: 'ተወዳጆች',
  },
  'security_warning_title': {
    AppLanguage.en: 'Security warning',
    AppLanguage.om: 'Akeekkachiisa nageenyaa',
    AppLanguage.am: 'የደህንነት ማስጠንቀቂያ',
  },
  'security_warning_message': {
    AppLanguage.en:
        'Changing this private note to public may expose its content.',
    AppLanguage.om: 'Yaadannoo iccitii kana uummataaf banaa gochuun qabiyyee isaa mul’isuu danda’a.',
    AppLanguage.am: 'ይህን ሚስጥራዊ ማስታወሻ ይፋ ማድረግ ይዘቱን ለሌሎች ሊያሳይ ይችላል።',
  },
  'confirm_change': {
    AppLanguage.en: 'Yes, change it',
    AppLanguage.om: 'Eeyyee, jijjiiri',
    AppLanguage.am: 'አዎ፣ ቀይር',
  },
  'private_note_subtitle': {
    AppLanguage.en: 'Stored using PIN and AES-GCM encryption.',
    AppLanguage.om: 'PIN fi AES-GCM encryption fayyadamuun kuufama.',
    AppLanguage.am: 'በPIN እና AES-GCM ምስጠራ ይቀመጣል።',
  },
  'settings_clear_history_title': {
    AppLanguage.en: 'Clear translation history?',
    AppLanguage.om: 'Seenaa hiikkaa haquu?',
    AppLanguage.am: 'የትርጉም ታሪክ ይጥፋ?',
  },
  'settings_clear_history_message': {
    AppLanguage.en: 'This will permanently delete all translation history. Your phrasebook and notes will not be affected.',
    AppLanguage.om: 'Kun seenaa hiikkaa hunda ni haqa. Galmee jechaa fi yaadannoo kee irratti dhiibbaa hin qabu.',
    AppLanguage.am:
        'ይህ ሁሉንም የትርጉም ታሪክ በቋሚነት ይሰርዛል። የሐረግ መዝገብህና ማስታወሻዎችህ አይነኩም።',
  },
  'clear_history_done': {
    AppLanguage.en: 'Translation history cleared.',
    AppLanguage.om: 'Seenaa hiikkaa haqameera.',
    AppLanguage.am: 'የትርጉም ታሪክ ተሰርዟል።',
  },
  'clear_history_only': {
    AppLanguage.en: 'Delete saved translation history only',
    AppLanguage.om: 'Seenaa hiikkaa kuufame qofa haqi',
    AppLanguage.am: 'የተቀመጠውን የትርጉም ታሪክ ብቻ ሰርዝ',
  },
  'about_hiikaa': {
    AppLanguage.en: 'About Hiikaa',
    AppLanguage.om: 'Waa’ee Hiikaa',
    AppLanguage.am: 'ስለ ሂካ',
  },
  'about_app_info': {
    AppLanguage.en: 'App information and version',
    AppLanguage.om: 'Odeeffannoo appii fi version',
    AppLanguage.am: 'የመተግበሪያ መረጃና ስሪት',
  },
  'about_description': {
    AppLanguage.en: 'Hiikaa is a language translation and phrasebook app designed to help people communicate.',
    AppLanguage.om: 'Hiikaa appii afaan hiikuu fi galmee jechaa namoonni akka wal qunnamaniif gargaaru dha.',
    AppLanguage.am: 'ሂካ ሰዎች እንዲግባቡ የሚረዳ የቋንቋ ትርጉምና የሐረግ መዝገብ መተግበሪያ ነው።',
  },
  'version_label': {
    AppLanguage.en: 'Hiikaa • Version 0.3 (beta)',
    AppLanguage.om: 'Hiikaa • Version 0.3 (beta)',
    AppLanguage.am: 'ሂካ • ስሪት 0.3 (ቤታ)',
  },
};

String tr(AppLanguage language, String key) {
  return _translations[key]?[language] ??
      _translations[key]?[AppLanguage.en] ??
      key;
}

String phraseGroupTitle(AppLanguage language, String title) {
  const translations = <String, Map<AppLanguage, String>>{
    'Greetings': {
      AppLanguage.en: 'Greetings',
      AppLanguage.om: 'Nagaa gaafachuu',
      AppLanguage.am: 'ሰላምታ',
    },
    'Conversation': {
      AppLanguage.en: 'Conversation',
      AppLanguage.om: 'Haasawa',
      AppLanguage.am: 'ሰላምታ',
    },
    'Shopping': {
      AppLanguage.en: 'Shopping',
      AppLanguage.om: 'Bittaa',
      AppLanguage.am: 'ሰላምታ',
    },
    'Food & Drink': {
      AppLanguage.en: 'Food & Drink',
      AppLanguage.om: 'Nyaataa fi Dhugaatii',
      AppLanguage.am: 'ምግብ እና መጠጥ',
    },
    'Travel': {
      AppLanguage.en: 'Travel',
      AppLanguage.om: 'Imala',
      AppLanguage.am: 'ጉዞ',
    },
    'Health': {
      AppLanguage.en: 'Health',
      AppLanguage.om: 'Fayyaa',
      AppLanguage.am: 'ጉዞ',
    },
    'Education': {
      AppLanguage.en: 'Education',
      AppLanguage.om: 'Barnoota',
      AppLanguage.am: 'ትምህርት',
    },
    'Business & Work': {
      AppLanguage.en: 'Business & Work',
      AppLanguage.om: 'Daldalaa fi Hojii',
      AppLanguage.am: 'ንግድ እና ሥራ',
    },
    'Family & People': {
      AppLanguage.en: 'Family & People',
      AppLanguage.om: 'Maatii fi Namoota',
      AppLanguage.am: 'ቤተሰብ እና ሰዎች',
    },
    'Numbers & Time': {
      AppLanguage.en: 'Numbers & Time',
      AppLanguage.om: 'Lakkoofsotaa fi Yeroo',
      AppLanguage.am: 'ቁጥሮች እና ጊዜ',
    },
    'Home & Nature': {
      AppLanguage.en: 'Home & Nature',
      AppLanguage.om: 'Mana fi Uumamaa',
      AppLanguage.am: 'ቤት እና ተፈጥሮ',
    },
    'Verbs & Words': {
      AppLanguage.en: 'Verbs & Words',
      AppLanguage.om: 'Gochootaa fi Jechoota',
      AppLanguage.am: 'ምግብ እና መጠጥ',
    },
    'Culture & Society': {
      AppLanguage.en: 'Culture & Society',
      AppLanguage.om: 'Aadaa fi Hawaasa',
      AppLanguage.am: 'ባህል እና ማህበረሰብ',
    },
    'Science & Tech': {
      AppLanguage.en: 'Science & Tech',
      AppLanguage.om: 'Saayinsii fi Teeknooloojii',
      AppLanguage.am: 'ሳይንስ እና ቴክኖሎጂ',
    },
    'Love & Relationships': {
      AppLanguage.en: 'Love & Relationships',
      AppLanguage.om: 'Jaalalaa fi Hariiroo',
      AppLanguage.am: 'ፍቅር እና ግንኙነቶች',
    },
    'Jobs & Interviews': {
      AppLanguage.en: 'Jobs & Interviews',
      AppLanguage.om: 'Hojii fi Gaaffii Qacarrii',
      AppLanguage.am: 'ሥራ እና ቃለ መጠይቅ',
    },
    'Government & Offices': {
      AppLanguage.en: 'Government & Offices',
      AppLanguage.om: 'Mootummaa fi Waajjiraalee',
      AppLanguage.am: 'መንግሥት እና ቢሮዎች',
    },
    'More': {
      AppLanguage.en: 'More',
      AppLanguage.om: 'Dabalata',
      AppLanguage.am: 'ሰላምታ',
    },
  };

  return translations[title]?[language] ?? title;
}

String noteCategoryTitle(AppLanguage language, String category) {
  const keys = <String, String>{
    'Mana Amantii': 'note_category_faith',
    'Iccitii': 'note_category_private',
    'Barnoota': 'note_category_study',
    'Dhuunfaa': 'note_category_personal',
    'Yaada': 'note_category_ideas',
    'Kan Biro': 'note_category_other',
  };

  final key = keys[category];
  return key == null ? category : tr(language, key);
}
