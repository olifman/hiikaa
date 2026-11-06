import 'package:flutter/material.dart';
import 'app_localizations.dart';

class TechnologyItem {
  const TechnologyItem({
    required this.category,
    required this.name,
    required this.year,
    required this.people,
    required this.country,
    required this.history,
    required this.uses,
    required this.explanation,
    this.research = false,
  });

  final String category;
  final List<String> name;
  final String year;
  final List<String> people;
  final List<String> country;
  final List<String> history;
  final List<String> uses;
  final List<String> explanation;
  final bool research;
}

class TechnologyPage extends StatefulWidget {
  const TechnologyPage({
    super.key,
    required this.appLanguage,
    required this.onVocabularyTap,
  });

  final AppLanguage appLanguage;
  final VoidCallback onVocabularyTap;

  @override
  State<TechnologyPage> createState() => _TechnologyPageState();
}

class _TechnologyPageState extends State<TechnologyPage> {
  String selected = 'all';

  String t(String en, String om, String am) {
    switch (widget.appLanguage) {
      case AppLanguage.om:
        return om;
      case AppLanguage.am:
        return am;
      case AppLanguage.en:
        return en;
    }
  }

  String value(List<String> values) =>
      values[widget.appLanguage.index];

  static const categories = [
    'social',
    'computer',
    'ai',
    'future',
  ];

  static const items = <TechnologyItem>[
    TechnologyItem(
      category: 'social',
      name: ['Facebook', 'Facebook', 'ፌስቡክ'],
      year: '2004',
      people: ['Mark Zuckerberg, Eduardo Saverin, Dustin Moskovitz, Chris Hughes', 'Mark Zuckerberg fi hiriyoota isaa Eduardo Saverin, Dustin Moskovitz fi Chris Hughes', 'ማርክ ዙከርበርግ፣ ኤድዋርዶ ሳቬሪን፣ ደስቲን ሞስኮቪትዝ እና ክሪስ ሂዩዝ'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Facebook launched at Harvard University on February 4, 2004, and later expanded to the public.', 'Facebook Fulbaana 4, 2004 Yunivarsiitii Harvard keessatti jalqabame; booda namoota hundaaf baname.', 'ፌስቡክ በየካቲት 4 ቀን 2004 በሃርቫርድ ዩኒቨርሲቲ ተጀመረ፣ በኋላም ለሕዝብ ተከፈተ።'],
      uses: ['Connecting with people, sharing posts, photos, videos and community information.', 'Namoota waliin walqunnamuuf, barruu, suuraa, viidiyoo fi odeeffannoo hawaasaa qooduuf.', 'ከሰዎች ጋር ለመገናኘት፣ ጽሑፎችን፣ ፎቶዎችን፣ ቪዲዮዎችን እና መረጃዎችን ለማጋራት።'],
      explanation: ['Facebook is a social networking service that helps people create profiles and communicate online.', 'Facebook tajaajila miidiyaa hawaasaa yoo ta’u, namoonni piroofaayilii uumanii interneetii irratti akka walqunnaman gargaara.', 'ፌስቡክ ሰዎች መገለጫ ፈጥረው በኢንተርኔት እንዲገናኙ የሚያግዝ የማህበራዊ ሚዲያ አገልግሎት ነው።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['Instagram', 'Instagram', 'ኢንስታግራም'],
      year: '2010',
      people: ['Kevin Systrom and Mike Krieger', 'Kevin Systrom fi Mike Krieger', 'ኬቪን ሲስትሮም እና ማይክ ክሪገር'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Instagram launched in October 2010 as a photo-sharing app.', 'Instagram Onkololeessa 2010 app suuraa qoodu ta’ee jalqabame.', 'ኢንስታግራም በጥቅምት 2010 ፎቶ ለማጋራት የሚያገለግል መተግበሪያ ሆኖ ተጀመረ።'],
      uses: ['Sharing photos, videos, stories and messages.', 'Suuraa, viidiyoo, seenaa fi ergaa qooduuf.', 'ፎቶዎችን፣ ቪዲዮዎችን፣ ታሪኮችን እና መልዕክቶችን ለማጋራት።'],
      explanation: ['Instagram is a social media platform focused on visual content such as photos and videos.', 'Instagram miidiyaa hawaasaa suuraa fi viidiyoo irratti xiyyeeffatu dha.', 'ኢንስታግራም በፎቶዎችና ቪዲዮዎች ላይ ያተኮረ የማህበራዊ ሚዲያ መድረክ ነው።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['WhatsApp', 'WhatsApp', 'ዋትስአፕ'],
      year: '2009',
      people: ['Jan Koum and Brian Acton', 'Jan Koum fi Brian Acton', 'ጃን ኩም እና ብራያን አክተን'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['WhatsApp began in 2009 as a simple status application and later added messaging.', 'WhatsApp bara 2009 app haala namaa agarsiisu ta’ee jalqabe; booda ergaa erguu dabalate.', 'ዋትስአፕ በ2009 የሰውን ሁኔታ ለማሳየት በሚያገለግል ቀላል መተግበሪያ ተጀመረ፣ በኋላም መልዕክት መላክ ተጨመረ።'],
      uses: ['Sending messages, making voice and video calls, and sharing files.', 'Ergaa erguu, bilbila sagalee fi viidiyoo bilbiluu, faayiloota qooduuf.', 'መልዕክት ለመላክ፣ የድምፅና የቪዲዮ ጥሪ ለማድረግ እና ፋይሎችን ለማጋራት።'],
      explanation: ['WhatsApp is an internet-based messaging and calling application.', 'WhatsApp app interneetii fayyadamuun ergaa fi bilbila dabarsuuf gargaaru dha.', 'ዋትስአፕ በኢንተርኔት መልዕክትና ጥሪ ለማድረግ የሚያገለግል መተግበሪያ ነው።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['YouTube', 'YouTube', 'ዩቲዩብ'],
      year: '2005',
      people: ['Steve Chen, Chad Hurley and Jawed Karim', 'Steve Chen, Chad Hurley fi Jawed Karim', 'ስቲቭ ቼን፣ ቻድ ሃርሊ እና ጃዌድ ካሪም'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['YouTube was founded in 2005 as a website for uploading and sharing videos.', 'YouTube bara 2005 marsariitii viidiyoo olkaa’uu fi qooduuf gargaaru ta’ee hundeeffame.', 'ዩቲዩብ በ2005 ቪዲዮዎችን ለመጫንና ለማጋራት የሚያገለግል ድረ-ገጽ ሆኖ ተመሠረተ።'],
      uses: ['Learning, entertainment, news, tutorials and sharing videos.', 'Barachuu, bashannanuu, oduu argachuu, leenjii fi viidiyoo qooduuf.', 'ለመማር፣ ለመዝናናት፣ ዜና ለማግኘት፣ ለስልጠና እና ቪዲዮ ለማጋራት።'],
      explanation: ['YouTube is an online video platform where people can watch, upload and share videos.', 'YouTube waltajjii viidiyoo interneetii irratti namoonni viidiyoo ilaalan, olkaa’an fi qoodan dha.', 'ዩቲዩብ ሰዎች ቪዲዮ የሚመለከቱበት፣ የሚጭኑበትና የሚያጋሩበት የመስመር ላይ መድረክ ነው።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['TikTok', 'TikTok', 'ቲክቶክ'],
      year: '2017 (global launch)',
      people: ['ByteDance, founded by Zhang Yiming', 'ByteDance, kan Zhang Yiming hundeesse', 'ባይትዳንስ፣ በዣንግ ይሚንግ የተመሠረተ'],
      country: ['China (company origin)', 'Chaayinaa (bakka dhaabbatichi irraa jalqabe)', 'ቻይና (የኩባንያው መነሻ)'],
      history: ['TikTok launched internationally in 2017. Its related Chinese app Douyin launched in 2016.', 'TikTok addunyaa irratti bara 2017 jalqabe. Appiin isaa kan Chaayinaa Douyin bara 2016 jalqabe.', 'ቲክቶክ በዓለም አቀፍ ደረጃ በ2017 ተጀመረ። ተዛማጁ የቻይና መተግበሪያ ዱዪን በ2016 ተጀመረ።'],
      uses: ['Creating, watching and sharing short videos.', 'Viidiyoo gabaabaa uumuu, ilaaluu fi qooduuf.', 'አጭር ቪዲዮዎችን ለመፍጠር፣ ለመመልከትና ለማጋራት።'],
      explanation: ['TikTok is a short-video platform that recommends content based on user interests and activity.', 'TikTok waltajjii viidiyoo gabaabaa yoo ta’u, fedhii fi sochii fayyadamaa irratti hundaa’ee viidiyoo gorsa.', 'ቲክቶክ በተጠቃሚው ፍላጎትና እንቅስቃሴ መሠረት ቪዲዮዎችን የሚመክር የአጭር ቪዲዮ መድረክ ነው።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['LinkedIn', 'LinkedIn', 'ሊንክድኢን'],
      year: '2003',
      people: ['Reid Hoffman, Allen Blue, Konstantin Guericke, Eric Ly and Jean-Luc Vaillant', 'Reid Hoffman, Allen Blue, Konstantin Guericke, Eric Ly fi Jean-Luc Vaillant', 'ሪድ ሆፍማን፣ አለን ብሉ፣ ኮንስታንቲን ጌሪኬ፣ ኤሪክ ሊ እና ዣን-ሉክ ቫያንት'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['LinkedIn officially launched on May 5, 2003, as a professional networking website.', 'LinkedIn Caamsaa 5, 2003 marsariitii walqunnamtii ogeessotaa ta’ee jalqabame.', 'ሊንክድኢን በግንቦት 5 ቀን 2003 የባለሙያዎች የግንኙነት ድረ-ገጽ ሆኖ ተጀመረ።'],
      uses: ['Finding jobs, building professional networks, sharing work experience and learning career skills.', 'Hojii barbaaduu, ogeessota waliin walqunnamuu, muuxannoo hojii qooduu fi dandeettii hojii barachuuf.', 'ሥራ ለመፈለግ፣ ከባለሙያዎች ጋር ለመገናኘት፣ የሥራ ልምድ ለማጋራትና የሙያ ክህሎት ለመማር።'],
      explanation: ['LinkedIn is a professional social network where people present their skills, experience and careers.', 'LinkedIn networkii hawaasaa ogeessotaa yoo ta’u, namoonni dandeettii, muuxannoo fi hojii isaanii itti agarsiisan dha.', 'ሊንክድኢን ሰዎች ክህሎታቸውን፣ ልምዳቸውንና ሙያቸውን የሚያሳዩበት የባለሙያዎች ማህበራዊ ኔትወርክ ነው።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['Reddit', 'Reddit', 'ሬዲት'],
      year: '2005',
      people: ['Steve Huffman and Alexis Ohanian', 'Steve Huffman fi Alexis Ohanian', 'ስቲቭ ሁፍማን እና አሌክሲስ ኦሃኒያን'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Reddit began in 2005 as an online community where users submit links, discuss topics and vote on posts.', 'Reddit bara 2005 hawaasa interneetii ta’ee jalqabe; fayyadamtoonni linkii dhiyeessu, mari’atu fi barruu irratti sagalee kennu.', 'ሬዲት በ2005 ተጠቃሚዎች ሊንኮችን የሚያቀርቡበት፣ ርዕሶችን የሚወያዩበትና ልጥፎችን የሚመርጡበት የመስመር ላይ ማህበረሰብ ሆኖ ተጀመረ።'],
      uses: ['Discussing interests, asking questions, sharing news and learning from online communities.', 'Fedhii irratti mari’achuu, gaaffii gaafachuu, oduu qooduu fi hawaasa interneetii irraa barachuuf.', 'ፍላጎቶችን ለመወያየት፣ ጥያቄ ለመጠየቅ፣ ዜና ለማጋራትና ከመስመር ላይ ማህበረሰቦች ለመማር።'],
      explanation: ['Reddit is a collection of topic-based communities where members post content and discuss it.', 'Reddit hawaasa mata duree adda addaatiin qoodame yoo ta’u, miseensonni barruu dhiyeessanii irratti mari’atu.', 'ሬዲት በተለያዩ ርዕሶች የተከፋፈሉ ማህበረሰቦች ስብስብ ነው፤ አባላትም ይዘት ያቀርባሉና ይወያያሉ።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['X (formerly Twitter)', 'X (Twitter duraanii)', 'X (የቀድሞው ትዊተር)'],
      year: '2006 (Twitter); renamed X in 2023',
      people: ['Jack Dorsey, Noah Glass, Biz Stone and Evan Williams', 'Jack Dorsey, Noah Glass, Biz Stone fi Evan Williams', 'ጃክ ዶርሲ፣ ኖህ ግላስ፣ ቢዝ ስቶን እና ኢቫን ዊሊያምስ'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Twitter launched publicly in July 2006 as a short-message service. It was renamed X in 2023.', 'Twitter Adoolessa 2006 ergaa gabaabaa qooduuf uummataaf baname. Bara 2023 maqaan isaa X jedhamee jijjiirame.', 'ትዊተር በሐምሌ 2006 አጭር መልዕክቶችን ለማጋራት ለሕዝብ ተከፈተ። በ2023 ስሙ ወደ X ተቀየረ።'],
      uses: ['Sharing short updates, following news, discussing events and communicating publicly.', 'Oduu gabaabaa qooduu, oduu hordofuu, taateewwan irratti mari’achuu fi uummata waliin walqunnamuuf.', 'አጭር መረጃዎችን ለማጋራት፣ ዜና ለመከታተል፣ ክስተቶችን ለመወያየትና በይፋ ለመገናኘት።'],
      explanation: ['X is a social platform for public posts, conversations, news and multimedia content.', 'X waltajjii hawaasaa barruu uummataa, marii, oduu fi qabiyyee miidiyaa qooduuf gargaaru dha.', 'X ይፋዊ ልጥፎችን፣ ውይይቶችን፣ ዜናዎችንና የተለያዩ ሚዲያዎችን ለማጋራት የሚያገለግል መድረክ ነው።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['Snapchat', 'Snapchat', 'ስናፕቻት'],
      year: '2011',
      people: ['Evan Spiegel, Bobby Murphy and Reggie Brown', 'Evan Spiegel, Bobby Murphy fi Reggie Brown', 'ኢቫን ስፒገል፣ ቦቢ መርፊ እና ሬጂ ብራውን'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Snapchat was launched in September 2011 after an early version called Picaboo.', 'Snapchat Fulbaana 2011 erga yaaliin isaa jalqabaa Picaboo jedhamu turee booda jalqabame.', 'ስናፕቻት ፒካቡ የተባለ የመጀመሪያ ስሪት ከተሞከረ በኋላ በመስከረም 2011 ተጀመረ።'],
      uses: ['Sending photos and videos, chatting, sharing stories and using camera effects.', 'Suuraa fi viidiyoo erguu, haasa’uu, seenaa qooduu fi miidhagina kaameraa fayyadamuuf.', 'ፎቶና ቪዲዮ ለመላክ፣ ለመወያየት፣ ታሪኮችን ለማጋራትና የካሜራ ተፅዕኖዎችን ለመጠቀም።'],
      explanation: ['Snapchat is a multimedia messaging app known for photos and videos that can disappear after viewing.', 'Snapchat app ergaa miidiyaa adda addaa erguu yoo ta’u, suuraa fi viidiyoo erga ilaalamanii booda baduu danda’an irratti beekama.', 'ስናፕቻት ከታዩ በኋላ ሊጠፉ በሚችሉ ፎቶዎችና ቪዲዮዎች የሚታወቅ የመልዕክት መተግበሪያ ነው።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['Pinterest', 'Pinterest', 'ፒንተረስት'],
      year: '2008 (founded); public launch in 2010',
      people: ['Ben Silbermann, Paul Sciarra and Evan Sharp', 'Ben Silbermann, Paul Sciarra fi Evan Sharp', 'ቤን ሲልበርማን፣ ፖል ሲያራ እና ኢቫን ሻርፕ'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Pinterest was founded in 2008 and later grew into a visual discovery platform for collecting and organizing ideas.', 'Pinterest bara 2008 hundeeffame; booda yaadota suuraan argaman walitti qabuu fi qindeessuuf waltajjii guddate.', 'ፒንተረስት በ2008 ተመሠረተ፤ በኋላም በምስል የሚታዩ ሐሳቦችን ለመሰብሰብና ለማደራጀት የሚያገለግል መድረክ ሆነ።'],
      uses: ['Collecting ideas for cooking, design, education, fashion, crafts and projects.', 'Yaada nyaataa, dizaayinii, barnoota, uffata, hojii harkaa fi pirojektootaaf walitti qabuuf.', 'ለምግብ ዝግጅት፣ ዲዛይን፣ ትምህርት፣ ፋሽን፣ የእጅ ሥራና ፕሮጀክቶች ሐሳቦችን ለመሰብሰብ።'],
      explanation: ['Pinterest is a visual discovery platform where users save images and links into collections called boards.', 'Pinterest waltajjii yaada suuraan argamu yoo ta’u, fayyadamtoonni suuraa fi linkii kuusaa board jedhaman keessatti olkaa’u.', 'ፒንተረስት ተጠቃሚዎች ምስሎችንና ሊንኮችን ቦርድ በሚባሉ ስብስቦች ውስጥ የሚያስቀምጡበት የምስል ፍለጋ መድረክ ነው።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['Telegram', 'Telegram', 'ቴሌግራም'],
      year: '2013',
      people: ['Pavel Durov and Nikolai Durov', 'Pavel Durov fi Nikolai Durov', 'ፓቬል ዱሮቭ እና ኒኮላይ ዱሮቭ'],
      country: ['International service founded by Russian entrepreneurs', 'Tajaajila addunyaa kan daldaltoota Raashiyaa jalqaban', 'በሩሲያ ሥራ ፈጣሪዎች የተጀመረ ዓለም አቀፍ አገልግሎት'],
      history: ['Telegram for iOS launched on August 14, 2013. It later expanded to Android, computers and other devices.', 'Telegram iOS irratti Hagayya 14, 2013 jalqabame. Booda Android, kompiitaraa fi meeshaalee biroo irratti babal’ate.', 'ቴሌግራም ለiOS በነሐሴ 14 ቀን 2013 ተጀመረ። በኋላም ወደ Android፣ ኮምፒውተሮችና ሌሎች መሣሪያዎች ተስፋፋ።'],
      uses: ['Sending messages, creating groups and channels, sharing files and making calls.', 'Ergaa erguu, garee fi chaanaalii uumuu, faayila qooduu fi bilbiluu.', 'መልዕክት ለመላክ፣ ቡድኖችና ቻናሎች ለመፍጠር፣ ፋይሎችን ለማጋራትና ለመደወል።'],
      explanation: ['Telegram is a cloud-based messaging service that works across phones, tablets and computers.', 'Telegram tajaajila ergaa cloud irratti hundaa’e yoo ta’u, bilbila, taableetii fi kompiitara irratti hojjeta.', 'ቴሌግራም በክላውድ ላይ የተመሠረተ በስልኮች፣ ታብሌቶችና ኮምፒውተሮች ላይ የሚሠራ የመልዕክት አገልግሎት ነው።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['Discord', 'Discord', 'ዲስኮርድ'],
      year: '2015',
      people: ['Jason Citron and Stanislav Vishnevskiy', 'Jason Citron fi Stanislav Vishnevskiy', 'ጄሰን ሲትሮን እና ስታኒስላቭ ቪሽኔቭስኪ'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Discord launched in 2015 to help people communicate while playing online games. It later grew into communities for many interests.', 'Discord bara 2015 namoonni yeroo tapha interneetii taphatan akka walqunnaman gargaaruuf jalqabame. Booda hawaasa fedhii adda addaatiif guddate.', 'ዲስኮርድ በ2015 ሰዎች የመስመር ላይ ጨዋታ ሲጫወቱ እንዲገናኙ ለመርዳት ተጀመረ። በኋላም ለብዙ ፍላጎቶች የሚያገለግል ማህበረሰብ ሆነ።'],
      uses: ['Voice calls, video calls, text chat, gaming groups and study communities.', 'Bilbila sagalee, bilbila viidiyoo, haasaa barruu, garee taphaa fi hawaasa barnootaaf.', 'የድምፅ ጥሪ፣ የቪዲዮ ጥሪ፣ የጽሑፍ ውይይት፣ የጨዋታ ቡድኖችና የትምህርት ማህበረሰቦች።'],
      explanation: ['Discord is a communication platform with servers, channels, voice, video and text conversations.', 'Discord waltajjii qunnamtii server, channel, sagalee, viidiyoo fi haasaa barruu qabu dha.', 'ዲስኮርድ ሰርቨሮች፣ ቻናሎች፣ ድምፅ፣ ቪዲዮና የጽሑፍ ውይይቶች ያሉት የግንኙነት መድረክ ነው።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['Twitch', 'Twitch', 'ትዊች'],
      year: '2011',
      people: ['Justin Kan and Emmett Shear; developed by the Justin.tv team', 'Justin Kan fi Emmett Shear; garee Justin.tv tiin guddate', 'ጀስቲን ካን እና ኤሜት ሺር፤ በJustin.tv ቡድን የተዳበረ'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Twitch launched on June 6, 2011, growing out of the live-streaming service Justin.tv.', 'Twitch Waxabajjii 6, 2011 tajaajila tamsaasa kallattii Justin.tv irraa guddatee jalqabame.', 'ትዊች ከቀጥታ ስርጭት አገልግሎት Justin.tv በማደግ ሰኔ 6 ቀን 2011 ተጀመረ።'],
      uses: ['Live-streaming games, music, events and conversations; viewers can chat with streamers.', 'Tapha, muuziqaa, taateewwan fi marii kallattiin tamsaasuu; daawwattoonni tamsaasitoota waliin haasa’uu danda’u.', 'ጨዋታዎችን፣ ሙዚቃን፣ ክስተቶችንና ውይይቶችን በቀጥታ ለማሰራጨት፤ ተመልካቾችም ከስርጭት አቅራቢዎች ጋር መወያየት ይችላሉ።'],
      explanation: ['Twitch is a live-streaming platform especially known for video game broadcasts.', 'Twitch waltajjii tamsaasa kallattii keessumaa tapha viidiyoo tamsaasuuf beekamu dha.', 'ትዊች በተለይ የቪዲዮ ጨዋታዎችን በቀጥታ በማሰራጨት የሚታወቅ መድረክ ነው።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['Tumblr', 'Tumblr', 'ታምብለር'],
      year: '2007',
      people: ['David Karp and Marco Arment', 'David Karp fi Marco Arment', 'ዴቪድ ካርፕ እና ማርኮ አርመንት'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Tumblr launched in 2007 as a microblogging platform for publishing text, images, links and other media.', 'Tumblr bara 2007 waltajjii blog gabaabaa barruu, suuraa, linkii fi miidiyaa biroo maxxansuuf jalqabame.', 'ታምብለር በ2007 ጽሑፍ፣ ምስል፣ ሊንክና ሌሎች ሚዲያዎችን ለማተም የሚያገለግል አጭር ብሎግ መድረክ ሆኖ ተጀመረ።'],
      uses: ['Publishing blogs, sharing artwork, following creators and collecting media.', 'Blog barreessuu, hojii aartii qooduu, kalaqtoota hordofuu fi miidiyaa walitti qabuuf.', 'ብሎጎችን ለማተም፣ የጥበብ ሥራዎችን ለማጋራት፣ ፈጣሪዎችን ለመከታተልና ሚዲያዎችን ለመሰብሰብ።'],
      explanation: ['Tumblr is a microblogging and social networking website where users publish and follow posts.', 'Tumblr marsariitii blog gabaabaa fi network hawaasaa yoo ta’u, fayyadamtoonni barruu maxxansanii kanneen biroo hordofu.', 'ታምብለር ተጠቃሚዎች ልጥፎችን የሚያትሙበትና ሌሎችን የሚከታተሉበት አጭር ብሎግና ማህበራዊ ድረ-ገጽ ነው።'],
    ),
    TechnologyItem(
      category: 'social',
      name: ['Flickr', 'Flickr', 'ፍሊከር'],
      year: '2004',
      people: ['Stewart Butterfield and Caterina Fake', 'Stewart Butterfield fi Caterina Fake', 'ስቱዋርት በተርፊልድ እና ካተሪና ፌክ'],
      country: ['Canada (Vancouver-based company)', 'Kanaadaa (dhaabbata Vancouver keessatti hundaa’e)', 'ካናዳ (በቫንኩቨር የተመሠረተ ኩባንያ)'],
      history: ['Flickr launched in February 2004 as an online photo-sharing service created by the company Ludicorp.', 'Flickr Guraandhala 2004 tajaajila suuraa interneetii irratti qoodu ta’ee dhaabbata Ludicorp tiin jalqabame.', 'ፍሊከር በየካቲት 2004 በLudicorp ኩባንያ የተፈጠረ የመስመር ላይ ፎቶ ማጋሪያ አገልግሎት ሆኖ ተጀመረ።'],
      uses: ['Uploading, organizing, storing and sharing photographs with other people.', 'Suuraa olkaa’uu, qindeessuu, kuusuu fi namoota biroo waliin qooduuf.', 'ፎቶዎችን ለመጫን፣ ለማደራጀት፣ ለማከማቸትና ከሌሎች ጋር ለማጋራት።'],
      explanation: ['Flickr is an online photo-management and sharing service used by photographers and communities.', 'Flickr tajaajila suuraa interneetii irratti qindeessuu fi qooduuf gargaaru yoo ta’u, suuraa kaastotaa fi hawaasaaf oola.', 'ፍሊከር በፎቶ አንሺዎችና በማህበረሰቦች የሚጠቀሙበት የመስመር ላይ ፎቶ ማደራጃና ማጋሪያ አገልግሎት ነው።'],
    ),    TechnologyItem(
      category: 'computer',
      name: ['Computer', 'Kompitara', 'ኮምፒውተር'],
      year: '19th century concepts; modern electronic computers in the 20th century',
      people: ['Charles Babbage; many later engineers and scientists', 'Charles Babbage fi injinarootaafi saayintistoota hedduu kanneen booda dhufan', 'ቻርለስ ባቤጅ እና በኋላ የመጡ ብዙ መሐንዲሶችና ሳይንቲስቶች'],
      country: ['United Kingdom and many other countries', 'United Kingdom fi biyyoota biroo hedduu', 'እንግሊዝ እና ሌሎች ብዙ አገሮች'],
      history: ['Charles Babbage designed the Analytical Engine in the 1830s. Modern computers developed through the work of many people.', 'Charles Babbage bara 1830moota keessa Analytical Engine qopheesse. Kompiitarri ammayyaa hojii namoota hedduu irraa guddate.', 'ቻርለስ ባቤጅ በ1830ዎቹ የአናሊቲካል ኢንጂን ንድፍ አዘጋጀ። ዘመናዊ ኮምፒውተር በብዙ ሰዎች ሥራ እድገት አገኘ።'],
      uses: ['Calculating, writing, storing information, communication and learning.', 'Herreguu, barreessuu, odeeffannoo kuusuu, qunnamtii fi barachuuf.', 'ለማስላት፣ ለመጻፍ፣ መረጃ ለማከማቸት፣ ለመገናኘትና ለመማር።'],
      explanation: ['A computer is an electronic machine that processes information according to instructions called programs.', 'Kompitarri meeshaa elektirooniksii ajaja sagantaa jedhamu hordofee odeeffannoo qindeessu dha.', 'ኮምፒውተር ፕሮግራም በሚባሉ መመሪያዎች መሠረት መረጃን የሚያስኬድ ኤሌክትሮኒክ ማሽን ነው።'],
    ),
    TechnologyItem(
      category: 'computer',
      name: ['Internet', 'Intarneetii', 'ኢንተርኔት'],
      year: '1969 (ARPANET beginnings)',
      people: ['Many researchers; Vint Cerf and Bob Kahn helped develop core Internet protocols', 'Qorattoota hedduu; Vint Cerf fi Bob Kahn pirootokoolota ijoo irratti gumaachan', 'ብዙ ተመራማሪዎች፤ ቪንት ሰርፍ እና ቦብ ካን ዋና የኢንተርኔት ፕሮቶኮሎችን ለማዳበር አግዘዋል'],
      country: ['United States (early ARPANET)', 'Ameerikaa (ARPANET jalqabaa)', 'አሜሪካ (የመጀመሪያው ARPANET)'],
      history: ['The early ARPANET connected computers in 1969. The Internet later grew into a worldwide network.', 'ARPANET jalqabaa bara 1969 kompiitaroota wal qunnamsiise. Boodarra Intarneetiin gara network addunyaatti guddate.', 'የመጀመሪያው ARPANET በ1969 ኮምፒውተሮችን አገናኘ። በኋላም ኢንተርኔት ዓለም አቀፍ ኔትወርክ ሆነ።'],
      uses: ['Finding information, communication, education, business and entertainment.', 'Odeeffannoo barbaaduu, qunnamtii, barnoota, daldalaa fi bashannanaaf.', 'መረጃ ለመፈለግ፣ ለመገናኘት፣ ለትምህርት፣ ለንግድና ለመዝናናት።'],
      explanation: ['The Internet is a worldwide network of connected computer networks that exchange data.', 'Intarneetiin network kompiitaraa addunyaa guutuu walitti hidhamee odeeffannoo wal jijjiiru dha.', 'ኢንተርኔት መረጃ የሚለዋወጡ በዓለም ዙሪያ የተገናኙ የኮምፒውተር ኔትወርኮች ስብስብ ነው።'],
    ),
    TechnologyItem(
      category: 'computer',
      name: ['Email', 'Imeelii', 'ኢሜይል'],
      year: '1971 (network email milestone)',
      people: ['Ray Tomlinson is widely credited with developing network email and the @ format', 'Ray Tomlinson imeelii network fi mallattoo @ irratti hojii guddaa hojjete', 'ሬይ ቶምሊንሰን የኔትወርክ ኢሜይልንና @ ምልክትን በማዳበር ይታወቃል'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Network email became possible in the early 1970s and changed how people send written messages.', 'Imeeliin network bara 1970moota jalqabaa keessatti babal’ate; ergaa barreeffamaa erguu jijjiire.', 'የኔትወርክ ኢሜይል በ1970ዎቹ መጀመሪያ ተስፋፋ፣ የጽሑፍ መልዕክት መላክንም ቀየረ።'],
      uses: ['Sending letters, documents and files electronically.', 'Xalayaa, galmee fi faayila karaa elektirooniksiin erguuf.', 'ደብዳቤዎችን፣ ሰነዶችንና ፋይሎችን በኤሌክትሮኒክ መንገድ ለመላክ።'],
      explanation: ['Email is a system for sending and receiving digital messages over networks.', 'Imeeliin sirna ergaa dijitaalaa network irratti erguu fi fudhachuu dha.', 'ኢሜይል በኔትወርክ ዲጂታል መልዕክቶችን ለመላክና ለመቀበል የሚያገለግል ሥርዓት ነው።'],
    ),
    TechnologyItem(
      category: 'ai',
      name: ['Artificial Intelligence (AI)', 'Ogummaa Namaa Fakkeessu (AI)', 'ሰው ሰራሽ ብልህነት (AI)'],
      year: '1956 (the term AI was established)',
      people: ['John McCarthy and other early AI researchers', 'John McCarthy fi qorattoota AI jalqabaa biroo', 'ጆን ማካርቲ እና ሌሎች የAI ቀደምት ተመራማሪዎች'],
      country: ['United States (Dartmouth workshop)', 'Ameerikaa (Dartmouth)', 'አሜሪካ (ዳርትማውዝ)'],
      history: ['The term Artificial Intelligence became established at the 1956 Dartmouth workshop. The field has developed over many decades.', 'Maqaan Artificial Intelligence bara 1956 waltajjii qorannoo Dartmouth irratti beekamtii argate. Dameen kun waggoota hedduu keessatti guddate.', 'ሰው ሰራሽ ብልህነት የሚለው ቃል በ1956 በዳርትማውዝ የምርምር ስብሰባ ታወቀ። ይህ ዘርፍ በብዙ ዓመታት አድጓል።'],
      uses: ['Language translation, image recognition, recommendations and helping people analyze information.', 'Afaan hiikuu, suuraa adda baasuu, gorsa kennuu fi odeeffannoo xiinxaluuf gargaaruu.', 'ቋንቋ ለመተርጎም፣ ምስል ለመለየት፣ ምክር ለመስጠትና መረጃን ለመተንተን።'],
      explanation: ['AI is a field of computing that builds systems able to perform tasks that usually require human-like intelligence.', 'AI damee kompiitaraa hojii yeroo baay’ee ogummaa namaa barbaadu raawwachuu danda’an ijaaru dha.', 'AI ብዙውን ጊዜ የሰው ብልህነት የሚፈልጉ ተግባራትን ማከናወን የሚችሉ ሥርዓቶችን የሚገነባ የኮምፒውተር ዘርፍ ነው።'],
    ),
    TechnologyItem(
      category: 'ai',
      name: ['ChatGPT', 'ChatGPT', 'ቻትጂፒቲ'],
      year: '2022',
      people: ['OpenAI', 'OpenAI', 'ኦፕንኤአይ'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['OpenAI introduced ChatGPT on November 30, 2022, as a conversational AI research preview.', 'OpenAI ChatGPT Sadaasa 30, 2022 akka AI haasawaaf gargaaru qorannoo jalqabaa ta’ee beeksise.', 'ኦፕንኤአይ ቻትጂፒቲን በኅዳር 30 ቀን 2022 እንደ የውይይት AI የምርምር ሙከራ አቀረበ።'],
      uses: ['Answering questions, explaining lessons, drafting text, translating and helping with coding.', 'Gaaffii deebisuu, barnoota ibsuu, barruu qopheessuu, hiikuu fi koodii barreessuu gargaaruu.', 'ጥያቄዎችን ለመመለስ፣ ትምህርት ለማብራራት፣ ጽሑፍ ለማዘጋጀት፣ ለመተርጎምና በኮድ ሥራ ለመርዳት።'],
      explanation: ['ChatGPT is an AI assistant that can understand and generate text in a conversational format. Its answers can sometimes be wrong.', 'ChatGPT gargaaraa AI kan haala haasaatiin barruu hubachuu fi maddisiisuu danda’u dha. Deebiin isaa yeroo tokko tokko dogoggora ta’uu danda’a.', 'ቻትጂፒቲ በውይይት መልክ ጽሑፍን መረዳትና ማመንጨት የሚችል AI ረዳት ነው። መልሶቹ አንዳንድ ጊዜ ሊሳሳቱ ይችላሉ።'],
    ),
    TechnologyItem(
      category: 'ai',
      name: ['Robot', 'Roobootii', 'ሮቦት'],
      year: 'Modern robotics developed during the 20th century',
      people: ['Many engineers and researchers; no single inventor', 'Injinarootaafi qorattoota hedduu; nama tokko qofaan hin uumamne', 'ብዙ መሐንዲሶችና ተመራማሪዎች፤ አንድ ፈጣሪ ብቻ የለውም'],
      country: ['Developed internationally', 'Biyyoota adda addaa keessatti', 'በተለያዩ አገሮች የተዳበረ'],
      history: ['Robots developed from mechanical inventions into programmable machines used in factories, hospitals and research.', 'Roobootiin meeshaalee makaanikaa irraa gara maashinoota sagantaan to’ataman warshaalee, hospitaala fi qorannoo keessatti fayyadamanitti guddate.', 'ሮቦቶች ከሜካኒካል ፈጠራዎች ወደ በፋብሪካዎች፣ በሆስፒታሎችና በምርምር የሚጠቀሙ ፕሮግራም የሚቆጣጠራቸው ማሽኖች አደጉ።'],
      uses: ['Manufacturing, surgery assistance, exploration, agriculture and repetitive tasks.', 'Oomisha warshaa, yaala fayyaa gargaaruu, qorannoo, qonnaa fi hojii irra deddeebi’amuuf.', 'በማምረት፣ በሕክምና ድጋፍ፣ በፍለጋ፣ በግብርናና ተደጋጋሚ ሥራዎች ላይ።'],
      explanation: ['A robot is a machine that can perform actions automatically or under computer control.', 'Roobootiin maashina ofumaan ykn to’annoo kompiitaraan hojii raawwachuu danda’u dha.', 'ሮቦት በራሱ ወይም በኮምፒውተር ቁጥጥር ተግባራትን ማከናወን የሚችል ማሽን ነው።'],
    ),
    TechnologyItem(
      category: 'future',
      name: ['Quantum Computing', 'Herrega Kuwaantamii', 'ኳንተም ኮምፒውቲንግ'],
      year: 'Research field developed since the 1980s',
      people: ['Richard Feynman, David Deutsch and many researchers', 'Richard Feynman, David Deutsch fi qorattoota hedduu', 'ሪቻርድ ፌይንማን፣ ዴቪድ ዶይች እና ብዙ ተመራማሪዎች'],
      country: ['International research', 'Qorannoo biyyoota hedduu', 'ዓለም አቀፍ ምርምር'],
      history: ['Quantum computing is an active research field. Researchers are building and testing quantum processors, but practical large-scale systems remain challenging.', 'Herregni Kuwaantamii damee qorannoo itti fufaa jiru dha. Qorattoonni processor kuwaantamii ijaaraa fi qorachaa jiru; garuu sirna guddaa hojii irra oolchuuf rakkoon jira.', 'ኳንተም ኮምፒውቲንግ ንቁ የምርምር ዘርፍ ነው። ተመራማሪዎች ኳንተም ፕሮሰሰሮችን እየገነቡና እየፈተኑ ነው፣ ግን በትልቅ ደረጃ ተግባራዊ ማድረግ አሁንም ፈታኝ ነው።'],
      uses: ['Potential future applications include some chemistry, materials and optimization problems.', 'Gara fuula duraatti keemistirii, meeshaalee haaraa fi rakkoolee optimization tokko tokko irratti gargaaruu danda’a.', 'ወደፊት በኬሚስትሪ፣ በአዳዲስ ቁሳቁሶችና በአንዳንድ የማመቻቸት ችግሮች ላይ ሊረዳ ይችላል።'],
      explanation: ['Quantum computers use quantum states to process information in ways different from ordinary computers.', 'Kompitarri Kuwaantamii haala kuwaantamii fayyadamuun odeeffannoo kompiitara idilee irraa adda ta’een qindeessa.', 'ኳንተም ኮምፒውተሮች ከመደበኛ ኮምፒውተሮች በተለየ መንገድ መረጃን ለማስኬድ የኳንተም ሁኔታዎችን ይጠቀማሉ።'],
      research: true,
    ),
    TechnologyItem(
      category: 'future',
      name: ['Self-driving Cars', 'Konkolaataa Ofiin Oofu', 'ራሱን የሚያሽከረክር መኪና'],
      year: 'Research and testing ongoing',
      people: ['Many automotive and technology companies and research teams', 'Dhaabbilee konkolaataa, teknooloojii fi gareewwan qorannoo hedduu', 'ብዙ የመኪናና የቴክኖሎጂ ኩባንያዎች እና የምርምር ቡድኖች'],
      country: ['International development', 'Biyyoota hedduu keessatti hojjetamaa jira', 'በብዙ አገሮች እየተሠራ ነው'],
      history: ['Autonomous vehicle research has developed over decades. Some driver-assistance systems are available, while fully autonomous use is limited and regulated.', 'Qorannoon konkolaataa ofiin oofu waggoota hedduu keessatti guddate. Sirnoonni gargaarsa konkolaachisaa tokko tokko jiru; garuu ofiin guutummaatti oofuun daangeffamaa fi seeraan to’atama.', 'በራስ-ሰር የሚነዱ መኪናዎች ምርምር ለብዙ ዓመታት አድጓል። አንዳንድ የሾፌር ድጋፍ ሥርዓቶች ቢኖሩም ሙሉ በሙሉ ራስ-ሰር መንዳት ውስንና በሕግ የተቆጣጠረ ነው።'],
      uses: ['Potentially helping with transport and mobility; safety testing is essential.', 'Geejjiba gargaaruu fi sochii namootaa salphisuu danda’a; garuu nageenya qorachuun barbaachisaa dha.', 'በመጓጓዣና በእንቅስቃሴ ሊረዳ ይችላል፤ የደህንነት ሙከራ ግን አስፈላጊ ነው።'],
      explanation: ['These vehicles use sensors, cameras, maps and AI systems to understand the road and make driving decisions.', 'Konkolaataan kun sensor, kaameraa, kaartaa fi AI fayyadamuun karaa hubatee murtii oofuu kenna.', 'እነዚህ መኪናዎች መንገድን ለመረዳትና የመንዳት ውሳኔ ለመስጠት ሴንሰሮችን፣ ካሜራዎችን፣ ካርታዎችንና AI ይጠቀማሉ።'],
      research: true,
    ),
    TechnologyItem(
      category: 'future',
      name: ['Brain-Computer Interface', 'Walqunnamtii Sammuu fi Kompiitaraa', 'የአንጎልና ኮምፒውተር በይነገጽ'],
      year: 'Research ongoing',
      people: ['Many neuroscientists, engineers and research teams', 'Saayintistoota sammuu, injinaroota fi gareewwan qorannoo hedduu', 'ብዙ የነርቭ ሳይንቲስቶች፣ መሐንዲሶችና የምርምር ቡድኖች'],
      country: ['International research', 'Qorannoo addunyaa guutuu', 'ዓለም አቀፍ ምርምር'],
      history: ['Brain-computer interface research explores direct communication between brain activity and external devices. Some medical applications exist, but the field is still developing.', 'Qorannoon kun sochii sammuu fi meeshaalee alaa gidduutti qunnamtii kallattii qorata. Fayyadamni yaalaa tokko tokko jira; garuu dameen kun ammallee guddachaa jira.', 'ይህ ምርምር በአንጎል እንቅስቃሴና በውጫዊ መሣሪያዎች መካከል ቀጥተኛ ግንኙነትን ይመረምራል። አንዳንድ የሕክምና አጠቃቀሞች ቢኖሩም ዘርፉ እየተዳበረ ነው።'],
      uses: ['Potential medical support for communication or movement in some people with disabilities.', 'Namoota qaama miidhamtoota tokko tokkoof qunnamtii ykn sochii gargaaruu danda’a.', 'አንዳንድ አካል ጉዳተኞች ለመገናኘት ወይም ለመንቀሳቀስ የሕክምና ድጋፍ ሊሰጥ ይችላል።'],
      explanation: ['A brain-computer interface measures brain signals and translates them into commands for a computer or another device.', 'Meeshaan mallattoo sammuu safaruun gara ajaja kompiitaraa ykn meeshaa biraatti jijjiira.', 'የአንጎልና ኮምፒውተር በይነገጽ የአንጎል ምልክቶችን ይለካልና ወደ ኮምፒውተር ወይም ሌላ መሣሪያ ትእዛዝ ይቀይራል።'],
      research: true,
    ),
    TechnologyItem(
      category: 'space',
      name: ['Geostationary Communication Satellite', 'Saateelaayitii Quunnamtii Marsaa Geosteeshinarii', 'ጂኦስታሽነሪ የመገናኛ ሳተላይት'],
      year: '1964',
      people: ['Arthur C. Clarke and Harold Rosen', 'Arthur C. Clarke fi Harold Rosen', 'አርተር ክላርክ እና ሃሮልድ ሮዘን'],
      country: ['United Kingdom and United States', 'Biriteenii fi Ameerikaa', 'እንግሊዝ እና አሜሪካ'],
      history: ['Arthur C. Clarke proposed the idea in 1945. Syncom 3 became the first satellite placed in geostationary orbit in 1964.', 'Arthur C. Clarke bara 1945 yaada kana dhiyeesse. Syncom 3 bara 1964 saateelaayitii marsaa geosteeshinarii keessa kaa’ame isa jalqabaa ta’e.', 'አርተር ክላርክ ይህን ሐሳብ በ1945 አቀረበ። ሲንኮም 3 በ1964 ወደ ጂኦስታሽነሪ ምህዋር የገባ የመጀመሪያው ሳተላይት ሆነ።'],
      uses: ['Carries television, telephone, internet and other communication signals.', 'Mallattoo televizhinii, bilbilaa, interneetii fi quunnamtii biroo dabarsa.', 'የቴሌቪዥን፣ የስልክ፣ የኢንተርኔት እና ሌሎች የመገናኛ ምልክቶችን ያስተላልፋል።'],
      explanation: ['It orbits above the equator at about 35,786 km and appears nearly stationary from the ground.', 'Sarara walqixxummaa lafaa olitti kiilomeetira 35,786 irratti naanna’a; lafa irraa yeroo ilaalamu bakka tokko irratti dhaabbatee fakkaata.', 'ከምድር ወገብ በላይ ወደ 35,786 ኪሎ ሜትር ከፍታ ላይ ይዞራል፤ ከምድር ላይ ሲታይም በአንድ ቦታ የቆመ ይመስላል።'],
    ),
    TechnologyItem(
      category: 'space',
      name: ['Meteorological Weather Satellite', 'Saateelaayitii Hordoffii Haala Qilleensaa', 'የአየር ሁኔታ መቆጣጠሪያ ሳተላይት'],
      year: '1960',
      people: ['NASA TIROS-1 project team', 'Garee pirojektii NASA TIROS-1', 'የናሳ ቲሮስ-1 ፕሮጀክት ቡድን'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['NASA launched TIROS-1 on April 1, 1960. It was the first successful weather satellite.', 'NASA TIROS-1 Ebla 1, 1960 furgugsiise. Inni saateelaayitii haala qilleensaa milkaa’inaan hojjetee isa jalqabaa ture.', 'ናሳ ቲሮስ-1ን ኤፕሪል 1 ቀን 1960 ወደ ህዋ ላከ። ይህም በተሳካ ሁኔታ የሠራ የመጀመሪያው የአየር ሁኔታ ሳተላይት ነበር።'],
      uses: ['Monitors clouds, storms and atmospheric conditions to support weather forecasts.', 'Duumessa, bubbee fi haala qilleensaa hordofuun tilmaama haala qilleensaa qopheessuuf gargaara.', 'ደመናን፣ አውሎ ነፋስን እና የከባቢ አየር ሁኔታን በመከታተል የአየር ትንበያን ይደግፋል።'],
      explanation: ['Its cameras and sensors observe clouds and atmospheric conditions from orbit.', 'Kaameraa fi saansaroota isaa fayyadamuun duumessaa fi haala qilleensaa marsaa irraa ilaala.', 'ካሜራዎቹና ዳሳሾቹ ከምህዋር ሆነው ደመናንና የከባቢ አየር ሁኔታን ይመለከታሉ።'],
    ),
    TechnologyItem(
      category: 'space',
      name: ['Earth Observation and Remote Sensing Satellite', 'Saateelaayitii Sakatta’insa Lafaa fi Daataa Fagoo', 'የምድር ምልከታና የርቀት ዳሰሳ ሳተላይት'],
      year: '1972',
      people: ['NASA Landsat program team', 'Garee pirojektii NASA Landsat', 'የናሳ ላንድሳት ፕሮግራም ቡድን'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Landsat 1 was launched on July 23, 1972, beginning a long-running Earth observation program.', 'Landsat 1 Adoolessa 23, 1972 furgugsiifame; kunis pirojektii yeroo dheeraa lafa sakatta’uu jalqabe.', 'ላንድሳት 1 ጁላይ 23 ቀን 1972 ወደ ህዋ ተላከ፤ ይህም የረጅም ጊዜ የምድር ምልከታ ፕሮግራምን ጀመረ።'],
      uses: ['Studies forests, farms, water resources, land changes and natural disasters.', 'Bosona, qonna, qabeenya bishaanii, jijjiirama lafaa fi balaa uumamaa qorata.', 'ደኖችን፣ እርሻዎችን፣ የውሃ ሀብቶችን፣ የመሬት ለውጦችንና የተፈጥሮ አደጋዎችን ያጠናል።'],
      explanation: ['Sensors measure reflected or emitted energy from Earth. Scientists use the data to study land, water and environmental changes.', 'Saansaroonni anniisaa lafaa irraa calaqqisu ykn bahu safaru. Saayintistoonni daataa kanaan lafa, bishaanii fi jijjiirama naannoo qoratu.', 'ዳሳሾች ከምድር የሚንጸባረቅን ወይም የሚወጣን ኃይል ይለካሉ። ሳይንቲስቶችም ይህን መረጃ መሬትን፣ ውሃንና የአካባቢ ለውጦችን ለማጥናት ይጠቀማሉ።'],
    ),
    TechnologyItem(
      category: 'space',
      name: ['Global Navigation Satellite System Receiver', 'Simataa Sirna Argama Addunyaa (GNSS)', 'የዓለም አቀፍ የሳተላይት አሰሳ ሲስተም ተቀባይ'],
      year: '1978 onward',
      people: ['NAVSTAR GPS development teams', 'Gareewwan sirna NAVSTAR GPS guddisan', 'የናቭስታር ጂፒኤስ ልማት ቡድኖች'],
      country: ['United States and other participating countries', 'Ameerikaa fi biyyoota biroo', 'አሜሪካና ሌሎች ተሳታፊ አገሮች'],
      history: ['The first NAVSTAR GPS satellite was launched in 1978. The system later became widely used for civilian navigation.', 'Saateelaayitiin NAVSTAR GPS jalqabaa bara 1978 furgugsiifame. Sirnichi booda hojii qajeelcha karaa sivilii keessatti bal’inaan fayyadame.', 'የመጀመሪያው የናቭስታር ጂፒኤስ ሳተላይት በ1978 ወደ ህዋ ተላከ። ከዚያም ሲስተሙ ለሲቪል አሰሳ በስፋት መጠቀም ጀመረ።'],
      uses: ['Provides location, navigation, mapping and accurate time information.', 'Bakka namaa agarsiisa, karaa qajeelcha, maapii fi odeeffannoo sa’aatii sirrii kenna.', 'የቦታ መረጃን፣ አሰሳን፣ ካርታንና ትክክለኛ የሰዓት መረጃን ይሰጣል።'],
      explanation: ['It receives timed signals from several satellites and calculates its position from the signal travel times.', 'Mallattoowwan yeroo isaanii beekamu saateelaayitii hedduu irraa fudhatee yeroo imala mallattoo irratti hundaa’uun bakka isaa shallaga.', 'ከብዙ ሳተላይቶች የጊዜ መረጃ ያላቸውን ምልክቶች ይቀበላል፤ ከምልክቶቹ የጉዞ ጊዜ በመነሳትም ቦታውን ያሰላል።'],
    ),
    TechnologyItem(
      category: 'future',
      name: ['Room-Temperature Superconducting Material', 'Meeshaa Superconductor Ho’a Kutaa Keessatti Hojjetu', 'በክፍል ሙቀት የሚሰራ ሱፐርኮንዳክተር ቁሳቁስ'],
      year: '1911 onward',
      people: ['Heike Kamerlingh Onnes and later researchers', 'Heike Kamerlingh Onnes fi qorattoota boodaa', 'ሄይክ ካመርሊንግ ኦነስ እና በኋላ የተነሱ ተመራማሪዎች'],
      country: ['Netherlands and international research', 'Nezerlaandii fi qorannoo idil-addunyaa', 'ኔዘርላንድስና ዓለም አቀፍ ምርምር'],
      history: ['Superconductivity was discovered in mercury in 1911 at very low temperature. A reliable room-temperature superconductor at ordinary pressure has not yet been demonstrated.', 'Superconductivity bara 1911 mekurii keessatti qabbana baay’ee gadi aanaa irratti argame. Meeshaan ho’a kutaa fi dhiibbaa idilee irratti amanamummaadhaan hojjetu hanga ammaatti hin mirkanoofne.', 'ሱፐርኮንዳክቲቪቲ በ1911 በሜርኩሪ ውስጥ በጣም ዝቅተኛ ሙቀት ላይ ተገኘ። በመደበኛ ግፊት እና በክፍል ሙቀት የሚሰራ አስተማማኝ ቁሳቁስ ግን እስካሁን አልተረጋገጠም።'],
      uses: ['If achieved, it could improve electricity transmission, medical magnets and advanced electronics.', 'Yoo milkaa’e dabarsa elektiriikii, maagneetii yaalaa fi elektirooniksii ammayyaa fooyyessuu danda’a.', 'ከተሳካ የኤሌክትሪክ ማስተላለፍን፣ የሕክምና ማግኔቶችንና የላቁ ኤሌክትሮኒክስን ሊያሻሽል ይችላል።'],
      explanation: ['Below a critical temperature, a superconductor can carry direct current without electrical resistance. Researchers are seeking materials that work at room temperature and ordinary pressure.', 'Ho’a murtaa’e gadiitti superconductor elektiriikii osoo hin mormin dabarsuu danda’a. Qorattoonni meeshaa ho’a kutaa fi dhiibbaa idileetti hojjetu barbaadu.', 'ከወሳኝ ሙቀት በታች ሱፐርኮንዳክተር የቀጥታ ኤሌክትሪክን ያለ ተቃውሞ ማስተላለፍ ይችላል። ተመራማሪዎች በክፍል ሙቀትና በመደበኛ ግፊት የሚሰሩ ቁሳቁሶችን እየፈለጉ ነው።'],
      research: true,
    ),
    TechnologyItem(
      category: 'future',
      name: ['Solid-State Electrolyte Battery', 'Baateerii Elektiroolayitii Jajjaboo', 'ጠጣር ኤሌክትሮላይት ባትሪ'],
      year: '1950s onward',
      people: ['Solid-state ionics and battery research teams', 'Gareewwan qorannoo ayoonikii jajjaboo fi baateerii', 'የጠጣር አዮኒክስና የባትሪ ምርምር ቡድኖች'],
      country: ['International research', 'Qorannoo idil-addunyaa', 'ዓለም አቀፍ ምርምር'],
      history: ['Solid ionic conductors have been studied since the mid-20th century. Modern research is developing rechargeable batteries that use solid electrolytes.', 'Meeshaaleen ayoonii jajjaboo dabarsan jaarraa 20ffaa walakkaa irraa eegalee qorannoo keessa turan. Qorannoon ammayyaa baateerii elektiroolayitii jajjaboo fayyadamu irratti xiyyeeffata.', 'ጠጣር አዮን አስተላላፊ ቁሳቁሶች ከ20ኛው ክፍለ ዘመን አጋማሽ ጀምሮ ተጠንተዋል። ዘመናዊ ምርምር ጠጣር ኤሌክትሮላይት የሚጠቀሙ ባትሪዎችን እያዳበረ ነው።'],
      uses: ['Potential uses include electric vehicles, portable electronics and energy storage.', 'Konkolaataa elektirikii, meeshaalee elektirooniksii fi kuusaa anniisaa keessatti fayyadamuu danda’a.', 'ሊጠቅምባቸው የሚችሉ መስኮች የኤሌክትሪክ መኪናዎች፣ ተንቀሳቃሽ ኤሌክትሮኒክስና የኃይል ማከማቻ ናቸው።'],
      explanation: ['It uses a solid material to conduct ions instead of the liquid electrolyte found in many conventional batteries. Researchers are still improving performance and safety.', 'Elektiroolayitii dhangala’aa baateerii idilee bakka buusuun meeshaa jajjaboo ayoonii dabarsu fayyadama. Qorattoonni ammas hojii irra oolmaa fi nageenya isaa fooyyessaa jiru.', 'በብዙ ባህላዊ ባትሪዎች ውስጥ ያለውን ፈሳሽ ኤሌክትሮላይት በአዮን አስተላላፊ ጠጣር ቁሳቁስ ይተካል። ተመራማሪዎች አፈጻጸሙንና ደህንነቱን እያሻሻሉ ነው።'],
      research: true,
    ),
    TechnologyItem(
      category: 'future',
      name: ['Synthetic Biology Gene Synthesis Platform', 'Waltajjii Tolcha Jiinii Baayoloojii Sintetikii', 'የሰው ሠራሽ ባዮሎጂ ጂን ማምረቻ መድረክ'],
      year: '2003–2010',
      people: ['J. Craig Venter, Hamilton Smith and research teams', 'J. Craig Venter, Hamilton Smith fi gareewwan qorannoo', 'ጄ. ክሬግ ቬንተር፣ ሃሚልተን ስሚዝ እና የምርምር ቡድኖች'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Synthetic biology advanced through the synthesis of a viral genome in 2003 and the announcement of a synthetic bacterial genome in 2010.', 'Baayoloojiin sintetikii bara 2003 jiinoomii vaayirasii tolchuu fi bara 2010 jiinoomii baakteeriyaa sintetikii beeksisuun guddate.', 'የሰው ሠራሽ ባዮሎጂ በ2003 የቫይረስ ጂኖም በላቦራቶሪ መሥራትና በ2010 የሰው ሠራሽ የባክቴሪያ ጂኖም ማሳወቅ በመሳሰሉ ስኬቶች አደገ።'],
      uses: ['Supports research into medicines, enzymes, engineered microbes and biological products.', 'Qorannoo qoricha, enzaayimii, maayikiroo-orgaanizimoota fooyya’anii fi oomisha baayoloojii keessatti gargaara.', 'የመድኃኒት፣ የኢንዛይም፣ የተቀየሩ ጥቃቅን ሕያዋን ፍጥረታትና የባዮሎጂ ምርቶች ምርምርን ይደግፋል።'],
      explanation: ['Scientists design and chemically synthesize DNA sequences, then study how they function in cells or organisms.', 'Saayintistoonni tartiiba DNA qopheessanii keemikaalaan tolchu; achiis seelii ykn lubbu-qabeessa keessatti hojii isaa qoratu.', 'ሳይንቲስቶች የዲኤንኤ ቅደም ተከተሎችን ንድፍ በማውጣት በኬሚካል ያመርታሉ፤ ከዚያም በሴሎች ወይም በሕያዋን ፍጥረታት ውስጥ እንዴት እንደሚሠሩ ያጠናሉ።'],
      research: true,
    ),
    TechnologyItem(
      category: 'agriculture',
      name: ['Precision Agriculture Variable-Rate Fertilizer Applicator', 'Meeshaa Raabsa Xaa’oo Qotiisa Sirrii', 'በትክክለኛ ግብርና የተለያየ መጠን ማዳበሪያ መበተኛ መሣሪያ'],
      year: '1980s–1990s',
      people: ['Agricultural engineers and precision farming researchers', 'Injinariingota qonnaa fi qorattoota qotiisa sirrii', 'የግብርና መሐንዲሶችና የትክክለኛ እርሻ ተመራማሪዎች'],
      country: ['United States and other countries', 'Ameerikaa fi biyyoota biroo', 'አሜሪካና ሌሎች አገሮች'],
      history: ['Precision agriculture grew with GPS, field mapping and improved farm machinery during the 1980s and 1990s.', 'Qotiisni sirrii guddina GPS, maapii dirree fi maashinoota qonnaatiin bara 1980mootaa fi 1990mootaa keessatti guddate.', 'ትክክለኛ ግብርና በ1980ዎቹና በ1990ዎቹ የጂፒኤስ፣ የእርሻ ካርታና የግብርና ማሽኖች እድገት ጋር ተስፋፋ።'],
      uses: ['Applies fertilizer according to soil and crop needs, helping reduce waste.', 'Akka fedhii biyyee fi midhaaniitti xaa’oo raabsa; qisaasama hir’isuuf gargaara.', 'እንደ አፈሩና እንደ ሰብሉ ፍላጎት ማዳበሪያ ይበትናል፤ ብክነትንም ለመቀነስ ይረዳል።'],
      explanation: ['GPS, field maps and sensors help the machine adjust fertilizer amounts in different parts of a field.', 'GPS, maapii dirree fi saansaroonni maashiniin bakka garaagaraatti hamma xaa’oo barbaachisu akka raabsu gargaara.', 'ጂፒኤስ፣ የእርሻ ካርታዎችና ዳሳሾች ማሽኑ በተለያዩ የእርሻ ክፍሎች የሚያስፈልገውን የማዳበሪያ መጠን እንዲያስተካክል ይረዳሉ።'],
    ),
    TechnologyItem(
      category: 'agriculture',
      name: ['Agricultural Drone Spraying System', 'Sirna Diroonii Qonnaa Qoricha Facaasu', 'የግብርና መድኃኒት መርጫ ድሮን ሲስተም'],
      year: '2015',
      people: ['DJI Agriculture and agricultural drone developers', 'DJI Agriculture fi hojjettoota diroonii qonnaa', 'ዲጂአይ አግሪካልቸር እና የግብርና ድሮን አበልጻጊዎች'],
      country: ['China', 'Chaayinaa', 'ቻይና'],
      history: ['DJI introduced the MG-1 agricultural spraying drone in 2015, helping expand commercial agricultural drone use.', 'DJI bara 2015 diroonii facaasa qonnaa MG-1 beeksise; kunis fayyadama diroonii qonnaa daldalaa babal’ise.', 'ዲጂአይ በ2015 የኤምጂ-1 የግብርና መርጫ ድሮንን አስተዋወቀ፤ ይህም የግብርና ድሮን የንግድ አጠቃቀምን አስፋፋ።'],
      uses: ['Sprays crop-protection products and can reach areas that are difficult for ground equipment.', 'Qoricha eegumsa midhaanii facaasa; bakka meeshaaleen lafa irra deemanii hin geenye ga’uu danda’a.', 'የሰብል መከላከያ መድኃኒቶችን ይረጫል፤ በመሬት ላይ ያሉ መሣሪያዎች ለመድረስ የሚቸገሩባቸውን ቦታዎችም ሊደርስ ይችላል።'],
      explanation: ['The drone follows planned routes and sprays liquid through controlled nozzles. Safe operation requires trained operators and compliance with local rules.', 'Dirooniin karaa balalii dursee qophaa’e hordofee noozilii to’atamuun dhangala’aa facaasa. Nageenyaaf leenjii fi seera naannoo hordofuun barbaachisa.', 'ድሮኑ የታቀደ የበረራ መንገድን ተከትሎ በተቆጣጠሩ መርጫዎች ፈሳሽ ይረጫል። ለደህንነት የሰለጠኑ ኦፕሬተሮችና የአካባቢ ሕጎችን መከተል ያስፈልጋል።'],
    ),
    TechnologyItem(
      category: 'energy',
      name: ['Lithium Iron Phosphate Battery', 'Baateerii Liitiyeem Ayiran Foosfeetii (LFP)', 'ሊቲየም ብረት ፎስፌት ባትሪ'],
      year: '1997',
      people: ['A. K. Padhi, K. S. Nanjundaswamy and John B. Goodenough', 'A. K. Padhi, K. S. Nanjundaswamy fi John B. Goodenough', 'ኤ. ኬ. ፓዲ፣ ኬ. ኤስ. ናንጁንዳስዋሚ እና ጆን ቢ. ጉድኖፍ'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['A landmark 1997 study by Padhi, Nanjundaswamy and Goodenough identified lithium iron phosphate as a promising battery cathode material.', 'Qorannoon beekamaan bara 1997 Padhi, Nanjundaswamy fi Goodenough LFP akka meeshaa kaatoodii baateerii abdachiisaatti ibse.', 'በፓዲ፣ ናንጁንዳስዋሚና ጉድኖፍ የተደረገው የ1997 ጥናት ሊቲየም ብረት ፎስፌትን ተስፋ ሰጪ የባትሪ ካቶድ ቁሳቁስ እንደሆነ አሳየ።'],
      uses: ['Powers electric vehicles, energy storage systems and other rechargeable devices.', 'Konkolaataa elektirikii, sirna kuusaa anniisaa fi meeshaalee irra deebi’anii chaarjii godhatan tajaajila.', 'የኤሌክትሪክ መኪናዎችን፣ የኃይል ማከማቻ ሲስተሞችንና ሌሎች እንደገና የሚሞሉ መሣሪያዎችን ያሠራል።'],
      explanation: ['Lithium ions move between the battery electrodes. LFP batteries are known for thermal stability and long cycle life.', 'Ayoononni liitiyeemii elektiroodota baateerii gidduutti socho’u. Baateeriin LFP tasgabbii ho’aa fi umurii marsaa dheeraa qaba.', 'ከሊቲየም አዮኖች በባትሪው ኤሌክትሮዶች መካከል ይንቀሳቀሳሉ። የኤልኤፍፒ ባትሪዎች በሙቀት መረጋጋትና በረጅም የአጠቃቀም ዑደት ይታወቃሉ።'],
    ),
    TechnologyItem(
      category: 'energy',
      name: ['Proton Exchange Membrane Fuel Cell', 'Seelii Boba’aa Membreenii Jijjiiraa Protoonii (PEMFC)', 'የፕሮቶን ልውውጥ ሽፋን ያለው የነዳጅ ሴል'],
      year: '1955 onward',
      people: ['Thomas Grubb and Leonard Niedrach', 'Thomas Grubb fi Leonard Niedrach', 'ቶማስ ግራብ እና ሊዮናርድ ኒድራክ'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Thomas Grubb developed a membrane fuel-cell design in 1955, and Leonard Niedrach later improved it.', 'Thomas Grubb bara 1955 dizaayinii seelii boba’aa membireenii qopheesse; Leonard Niedrach immoo booda fooyyesse.', 'ቶማስ ግራብ በ1955 የሽፋን ነዳጅ ሴል ንድፍ አዘጋጀ፤ ሊዮናርድ ኒድራክም በኋላ አሻሻለው።'],
      uses: ['Produces electricity for hydrogen vehicles, backup power and some aerospace systems.', 'Konkolaataa haayidiroojiinii, humna bakka bu’aa fi sirna hawaa tokko tokkoof elektiriikii uuma.', 'ለሃይድሮጂን መኪናዎች፣ ለተተኪ ኃይልና ለአንዳንድ የህዋ ሲስተሞች ኤሌክትሪክ ያመነጫል።'],
      explanation: ['Hydrogen reacts at a catalyst. Protons pass through a polymer membrane while electrons flow through an external circuit, producing electricity and water.', 'Haayidiroojiiniin kaataalaayizarii irratti walnyaata. Protoononni membireenii poolimeerii keessa darbu; elektiroononni marsaa alaa keessa yaa’uun elektiriikii fi bishaan uumu.', 'ሃይድሮጂን በካታሊስት ላይ ይሠራል። ፕሮቶኖች በፖሊመር ሽፋን ውስጥ ያልፋሉ፤ ኤሌክትሮኖች ደግሞ በውጫዊ ዑደት ይፈሳሉ፣ በዚህም ኤሌክትሪክና ውሃ ይፈጠራሉ።'],
    ),
    TechnologyItem(
      category: 'energy',
      name: ['Concentrated Solar Power Tower System', 'Sirna Tawaara Humna Solaaraa Walitti Qabame', 'የተጠናከረ የፀሐይ ኃይል ግንብ ሲስተም'],
      year: '1982',
      people: ['Solar One project team', 'Garee pirojektii Solar One', 'የሶላር ዋን ፕሮጀክት ቡድን'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['The Solar One demonstration power tower in California began operation in 1982.', 'Tawaarri humna yaalii Solar One kan Kaalifoorniyaa bara 1982 hojii jalqabe.', 'በካሊፎርኒያ የሚገኘው የሶላር ዋን የሙከራ የኃይል ግንብ በ1982 ሥራ ጀመረ።'],
      uses: ['Generates electricity and can store heat for later use.', 'Elektiriikii uuma; ho’a walitti qabames yeroo booda fayyadamuuf kuusuu danda’a.', 'ኤሌክትሪክ ያመነጫል፤ የተሰበሰበውን ሙቀትም ለቀጣይ ጊዜ ማከማቸት ይችላል።'],
      explanation: ['Many mirrors reflect sunlight onto a receiver at the top of a tower. The receiver heats a fluid, which can produce steam to drive a turbine.', 'Daawwitiiwwan hedduun ifa aduu gara fudhataa tawaara gubbaa jiruotti deebisu. Fudhataan dhangala’aa ho’isa; inni hurka uumuun tarbaayinii sochoosa.', 'ብዙ መስተዋቶች የፀሐይ ብርሃንን በግንቡ ላይ ወዳለ ተቀባይ ይመልሳሉ። ተቀባዩ ፈሳሽን ያሞቃል፤ ይህም ተርባይንን የሚያንቀሳቅስ እንፋሎት ሊፈጥር ይችላል።'],
    ),
    TechnologyItem(
      category: 'medical',
      name: ['Polymerase Chain Reaction DNA Amplification', 'Baay’isuu DNA Tooftaa PCR', 'በፖሊመሬዝ ሰንሰለታዊ ምላሽ ዲኤንኤን ማባዛት'],
      year: '1983',
      people: ['Kary Mullis', 'Kary Mullis', 'ካሪ ሙሊስ'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Kary Mullis conceived the PCR method in 1983. He received the 1993 Nobel Prize in Chemistry for this work.', 'Kary Mullis bara 1983 mala PCR yaade. Hojii kanaaf bara 1993 badhaasa Nobel Keemistirii argate.', 'ካሪ ሙሊስ የፒሲአር ዘዴን በ1983 ፈጠረ። ለዚህ ሥራውም በ1993 የኬሚስትሪ የኖቤል ሽልማት አገኘ።'],
      uses: ['Detects infectious organisms and supports genetic testing, forensic analysis and medical research.', 'Jarmii dhukkuba fidu adda baasa; qorannoo jiinii, ragaa yakkaa fi qorannoo fayyaa keessatti gargaara.', 'ተላላፊ በሽታ አምጪ ፍጥረታትን ለመለየት፣ የጂን ምርመራን፣ የፎረንሲክ ትንተናንና የሕክምና ምርምርን ይደግፋል።'],
      explanation: ['PCR repeatedly heats and cools a sample so DNA strands separate, primers attach and an enzyme copies the target DNA section many times.', 'PCR saampilii irra deddeebi’ee ho’isa fi qabbaneessa; DNA addaan ba’a, primers itti maxxanu, enzaayimiin kutaa DNA barbaadame yeroo hedduu baay’isa.', 'ፒሲአር ናሙናውን ደጋግሞ ያሞቃልና ያቀዘቅዛል፤ የዲኤንኤ ክሮች ይለያያሉ፣ ፕራይመሮች ይጣበቃሉ፣ ኢንዛይምም የታለመውን የዲኤንኤ ክፍል ብዙ ጊዜ ያባዛል።'],
    ),
    TechnologyItem(
      category: 'medical',
      name: ['Automated External Defibrillator (AED)', 'Meeshaa Deebii Onnee Ofumaan Kennu (AED)', 'ራሱን ችሎ የሚሠራ ውጫዊ የልብ ምት ማስተካከያ (AED)'],
      year: '1970s',
      people: ['Frank Pantridge and Arch Diack', 'Frank Pantridge fi Arch Diack', 'ፍራንክ ፓንትሪጅ እና አርች ዳያክ'],
      country: ['United Kingdom and United States', 'Biriteenii fi Ameerikaa', 'እንግሊዝ እና አሜሪካ'],
      history: ['Frank Pantridge introduced a portable defibrillator in 1965. Automated external defibrillators were developed later during the 1970s.', 'Frank Pantridge bara 1965 meeshaa defibrillator socho’uu danda’u dhiheesse. Meeshaaleen AED ofumaan hojjetan booda bara 1970mootaa keessatti guddatani.', 'ፍራንክ ፓንትሪጅ በ1965 ተንቀሳቃሽ የልብ ምት ማስተካከያ አቀረበ። ራሳቸውን ችለው የሚሠሩ ውጫዊ መሣሪያዎች በ1970ዎቹ ተሻሻሉ።'],
      uses: ['Provides emergency assistance during certain types of sudden cardiac arrest.', 'Yeroo onneen namaa akka tasaa dhaabbatu gargaarsa ariifachiisaa kenna.', 'በአንዳንድ ድንገተኛ የልብ ሥራ መቆም ሁኔታዎች የአደጋ ጊዜ እርዳታ ይሰጣል።'],
      explanation: ['Pads read the heart rhythm. The device checks whether an electric shock is advised and guides the user through the process.', 'Paadiin qaama irratti maxxanu rukuttaa onnee dubbisa. Meeshaan kun dhiibbaan elektiriikii barbaachisaa ta’uu isaa qoratee fayyadamaa qajeelcha.', 'በሰውነት ላይ የሚለጠፉ ፓዶች የልብ ምትን ያነባሉ። መሣሪያው የኤሌክትሪክ ድንጋጤ አስፈላጊ መሆኑን ይመረምራል፤ ተጠቃሚውንም ይመራል።'],
    ),
    TechnologyItem(
      category: 'medical',
      name: ['Robotic Surgical System', 'Sirna Baqaqsanii Yaalii Roobootii', 'የሮቦት ቀዶ ጥገና ሲስተም'],
      year: '1999–2000',
      people: ['Intuitive Surgical and the da Vinci development team', 'Intuitive Surgical fi garee da Vinci', 'ኢንቱኢቲቭ ሰርጂካል እና የዳ ቪንቺ ልማት ቡድን'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['The da Vinci surgical system was introduced in 1999 and received US FDA clearance for certain surgery in 2000.', 'Sirni baqaqsanii yaalii da Vinci bara 1999 dhihaate; bara 2000 hayyama FDA Ameerikaa argate.', 'የዳ ቪንቺ የቀዶ ጥገና ሲስተም በ1999 ቀረበ፤ በ2000 ከአሜሪካ ኤፍዲኤ ፈቃድ አገኘ።'],
      uses: ['Assists surgeons with selected minimally invasive operations.', 'Ogeessota yaalaa hojii baqaqsanii yaalii qaama xiqqoo muranii hojjetamu keessatti gargaara.', 'በተመረጡ አነስተኛ ቁስል በሚያስፈልጋቸው ቀዶ ጥገናዎች ሐኪሞችን ይረዳል።'],
      explanation: ['A surgeon controls robotic instruments from a console. The system supports precise movement but does not perform surgery independently.', 'Ogeessi yaalaa meeshaa roobootii konsoolii irraa to’ata. Sirnichi sochii sirrii gargaara; ofumaan garuu hin baqaqsu.', 'ቀዶ ጥገና ሐኪሙ የሮቦት መሣሪያዎችን ከመቆጣጠሪያ ይቆጣጠራል። ሲስተሙ ትክክለኛ እንቅስቃሴን ይደግፋል እንጂ ቀዶ ጥገናውን በራሱ አያከናውንም።'],
    ),
    TechnologyItem(
      category: 'robotics',
      name: ['Automated Guided Vehicle (AGV)', 'Konkolaataa Ofumaan Qajeelfamu (AGV)', 'በራስ ሰር የሚመራ ተሽከርካሪ (AGV)'],
      year: '1953',
      people: ['Arthur Barrett', 'Arthur Barrett', 'አርተር ባሬት'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['Arthur Barrett developed an early guided industrial vehicle in 1953 to move materials in factories and warehouses.', 'Arthur Barrett bara 1953 konkolaataa industirii meeshaalee warshaalee fi kuusaalee keessatti geejjibu qopheesse.', 'አርተር ባሬት በ1953 በፋብሪካዎችና በመጋዘኖች ውስጥ ቁሳቁሶችን ለማጓጓዝ ቀደምት የኢንዱስትሪ መሪ ተሽከርካሪ አዘጋጀ።'],
      uses: ['Moves materials and goods in factories, warehouses and distribution centers.', 'Meeshaalee fi oomisha warshaalee, kuusaalee fi wiirtuu raabsa keessatti geejjiba.', 'በፋብሪካዎች፣ በመጋዘኖችና በማከፋፈያ ማዕከላት ውስጥ ቁሳቁሶችንና ምርቶችን ያጓጉዛል።'],
      explanation: ['It follows a planned route using wires, magnetic markers, floor lines or navigation sensors.', 'Sarara, mallattoo maagneetii, sarara lafa irratti jiru ykn saansara qajeelfamaa fayyadamuun karaa dursee qophaa’e hordofa.', 'ሽቦዎችን፣ መግነጢሳዊ ምልክቶችን፣ የወለል መስመሮችን ወይም የአሰሳ ዳሳሾችን በመጠቀም የታቀደ መንገድን ይከተላል።'],
    ),
    TechnologyItem(
      category: 'robotics',
      name: ['Collaborative Robot (Cobot)', 'Roobootii Walta’insaa (Cobot)', 'ተባባሪ ሮቦት (ኮቦት)'],
      year: '1990s',
      people: ['J. Edward Colgate and Michael Peshkin', 'J. Edward Colgate fi Michael Peshkin', 'ጄ. ኤድዋርድ ኮልጌት እና ማይክል ፔሽኪን'],
      country: ['United States', 'Ameerikaa', 'አሜሪካ'],
      history: ['J. Edward Colgate and Michael Peshkin developed the cobot concept during the 1990s. Collaborative robots later entered industrial use.', 'J. Edward Colgate fi Michael Peshkin yaada cobot bara 1990mootaa keessatti guddisan. Roobootonni walta’insaa booda industirii keessatti hojii jalqaban.', 'ጄ. ኤድዋርድ ኮልጌትና ማይክል ፔሽኪን የኮቦት ጽንሰ ሐሳብን በ1990ዎቹ አዳበሩ። በኋላም ተባባሪ ሮቦቶች በኢንዱስትሪ ውስጥ መጠቀም ጀመሩ።'],
      uses: ['Helps people with assembly, packaging, machine tending and repetitive tasks.', 'Namoota hojii walitti qabuu, saamsuu, maashinii tajaajiluu fi hojii irra deddeebi’amu keessatti gargaara.', 'በመገጣጠም፣ በማሸግ፣ ማሽኖችን በማስኬድና በተደጋጋሚ ሥራዎች ሰዎችን ይረዳል።'],
      explanation: ['Cobots are designed to work near people with safety features such as force sensing and speed limits. Safety requirements depend on the task.', 'Cobot namoota bira hojjechuuf safartuu humnaa fi daangaa saffisaa fakkaatan qaba. Nageenyi hojii irratti hundaa’a.', 'ኮቦቶች ከሰዎች አጠገብ እንዲሠሩ የኃይል መለኪያና የፍጥነት ገደብ ያሉ የደህንነት ባህሪያት አሏቸው። የደህንነት መስፈርቶች እንደ ሥራው ይለያያሉ።'],
    ),
    TechnologyItem(
      category: 'robotics',
      name: ['Simultaneous Localization and Mapping (SLAM)', 'Tooftaa Yeroo Tokkotti Teessoo Beekuu fi Maapii Uumuu (SLAM)', 'በአንድ ጊዜ ቦታን መለየትና ካርታ መሥራት (SLAM)'],
      year: '1986 onward',
      people: ['R. Smith, P. Cheeseman, R. Self and later SLAM researchers', 'R. Smith, P. Cheeseman, R. Self fi qorattoota SLAM boodaa', 'አር. ስሚዝ፣ ፒ. ቺዝማን፣ አር. ሴልፍ እና በኋላ የSLAM ተመራማሪዎች'],
      country: ['International research', 'Qorannoo idil-addunyaa', 'ዓለም አቀፍ ምርምር'],
      history: ['The SLAM problem was developed in robotics research during the 1980s and later improved by many researchers.', 'Rakkoon SLAM qorannoo roobootii keessatti bara 1980mootaa keessa guddate; booda qorattoota hedduun fooyya’e.', 'የSLAM ችግር በ1980ዎቹ በሮቦቲክስ ምርምር ውስጥ ተዳብሮ በኋላ በብዙ ተመራማሪዎች ተሻሻለ።'],
      uses: ['Helps mobile robots, autonomous vehicles and space rovers map unknown places and estimate their positions.', 'Roobootiin socho’u, konkolaataan ofiin deemu fi rooveriin hawaa naannoo hin beekamne maapii gochuu fi bakka isaanii tilmaamuuf gargaara.', 'ተንቀሳቃሽ ሮቦቶች፣ ራሳቸውን የሚነዱ ተሽከርካሪዎችና የህዋ መመርመሪያዎች ያልታወቁ ቦታዎችን ካርታ እንዲሠሩና ቦታቸውን እንዲገምቱ ይረዳል።'],
      explanation: ['It uses cameras, LiDAR or other sensors to build a map while estimating the device position within that map.', 'Kaameraa, LiDAR ykn saansaroota biroo fayyadamuun maapii ijaara; yeroo wal fakkaatutti bakka meeshaan jiru tilmaama.', 'ካሜራዎችን፣ ሊዳርን ወይም ሌሎች ዳሳሾችን በመጠቀም ካርታ ይሠራል፤ በተመሳሳይ ጊዜም መሣሪያው በዚያ ካርታ ውስጥ ያለበትን ቦታ ይገምታል።'],
    ),
  ];

  String categoryName(String id) {
    switch (id) {
      case 'social':
        return t('Social Media', 'Miidiyaa Hawaasaa', 'ማህበራዊ ሚዲያ');
      case 'computer':
        return t('Computer & Internet', 'Kompitaraa fi Intarneetii', 'ኮምፒውተር እና ኢንተርኔት');
      case 'ai':
        return t('AI & Robotics', 'AI fi Roobootii', 'AI እና ሮቦቲክስ');
      default:
        return t('Future Technologies', 'Teknooloojiiwwan Fuulduraa', 'የወደፊት ቴክኖሎጂዎች');
    }
  }

  Widget sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00897B)),
          const SizedBox(width: 9),
          Expanded(
            child: Text(title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget detailLine(String label, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF00897B))),
          const SizedBox(height: 3),
          Text(text, style: const TextStyle(height: 1.4)),
        ],
      ),
    );
  }

  Widget itemCard(TechnologyItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE0F2F1),
          child: Icon(
            item.research ? Icons.science_outlined : Icons.devices_outlined,
            color: const Color(0xFF00897B),
          ),
        ),
        title: Text(value(item.name),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${t('Started', 'Bara', 'ዓመት')}: ${item.year}',
          style: const TextStyle(fontSize: 12),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.research)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Chip(
                avatar: const Icon(Icons.science, size: 17),
                label: Text(t('Research / developing', 'Qorannoo / guddachaa jira', 'በምርምር / በእድገት ላይ')),
                backgroundColor: const Color(0xFFFFF3E0),
              ),
            ),
          detailLine(t('People / creators', 'Namoota / kalaqtoota', 'ፈጣሪዎች / ሰዎች'), value(item.people)),
          detailLine(t('Country / origin', 'Biyya / bakka jalqabaa', 'አገር / መነሻ'), value(item.country)),
          detailLine(t('History', 'Seenaa', 'ታሪክ'), value(item.history)),
          detailLine(t('How it works', 'Akkaataa itti hojjetu', 'እንዴት እንደሚሠራ'), value(item.explanation)),
          detailLine(t('Uses and benefits', 'Faayidaa fi itti fayyadama', 'ጥቅምና አጠቃቀም'), value(item.uses)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = selected == 'all'
        ? items
        : items.where((item) => item.category == selected).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(t('Technology', 'Teknooloojii', 'ቴክኖሎጂ')),
      ),
      backgroundColor: const Color(0xFFF4F8F5),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(14, 14, 14, 4),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00695C), Color(0xFF26A69A)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.memory, color: Colors.white, size: 34),
                const SizedBox(height: 10),
                Text(
                  t('Learn about technology', 'Waa’ee teknooloojii baradhu', 'ስለ ቴክኖሎጂ ይማሩ'),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  t(
                    'Discover the history, creators and uses of important technologies.',
                    'Seenaa, kalaqtoota fi faayidaa teknooloojiiwwan beekamoo baradhu.',
                    'የታወቁ ቴክኖሎጂዎችን ታሪክ፣ ፈጣሪዎችና ጥቅሞች ይወቁ።',
                  ),
                  style: const TextStyle(color: Colors.white, height: 1.4),
                ),
              ],
            ),
          ),
          sectionTitle(
            t('Categories', 'Ramaddiiwwan', 'ምድቦች'),
            Icons.category_outlined,
          ),
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: ChoiceChip(
                    label: Text(t('All', 'Hunda', 'ሁሉም')),
                    selected: selected == 'all',
                    onSelected: (_) => setState(() => selected = 'all'),
                  ),
                ),
                for (final category in categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: ChoiceChip(
                      label: Text(categoryName(category)),
                      selected: selected == category,
                      onSelected: (_) => setState(() => selected = category),
                    ),
                  ),
              ],
            ),
          ),
          for (final item in visible) itemCard(item),
          sectionTitle(
            t('Technology Vocabulary', 'Jechoota Teknooloojii', 'የቴክኖሎጂ ቃላት'),
            Icons.menu_book_outlined,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE0F2F1),
                  child: Icon(Icons.translate, color: Color(0xFF00897B)),
                ),
                title: Text(t('Learn technology words', 'Jechoota teknooloojii baradhu', 'የቴክኖሎጂ ቃላትን ይማሩ')),
                subtitle: Text(t('Open the existing phrase list', 'Tarree jechootaa duraan jiru bani', 'ያለውን የቃላት ዝርዝር ይክፈቱ')),
                trailing: const Icon(Icons.arrow_forward_ios, size: 17),
                onTap: widget.onVocabularyTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
