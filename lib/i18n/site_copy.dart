import 'package:canarslan_website/i18n/site_locale.dart';
import 'package:flutter/widgets.dart';

/// Every word the site says, in both languages, on adjacent lines.
///
/// The pairing is the point. A key-per-language map lets one side be edited
/// and the other forgotten; here the two are arguments to the same constructor,
/// so a string cannot be added, changed or removed in one language without the
/// other being right there. There is no key lookup and no missing-key
/// fallback — a typo is a compile error.
///
/// **Two conventions, both load-bearing:**
///
/// 1. **Copy destined for an uppercase slot is authored uppercase**, in both
///    languages. `String.toUpperCase()` is locale-independent and maps `i` to a
///    dotless `I`, so *İletişim* would render as *ILETIŞIM*. Writing the final
///    form in the source removes the trap and makes the file read as what the
///    page shows. See `DESIGN.md` § Turkish in uppercase labels.
/// 2. **Prose uses ability forms, not imperatives** — *yazabilirsiniz* rather
///    than *yazın* — and addresses the reader as *siz*. Buttons are the one
///    exception: a control names its action, so *İLETİŞİME GEÇİN* stays.
///
/// Components take plain `String`s and know nothing about language. Pages
/// resolve copy at the point of use with `.of(context)`, which is also what
/// subscribes them to the switch.
@immutable
class Copy {
  const Copy(this.en, this.tr);

  final String en;
  final String tr;

  String at(SiteLocale locale) => switch (locale) {
        SiteLocale.en => en,
        SiteLocale.tr => tr,
      };

  /// Resolves against the language in force, and registers the caller as a
  /// dependent of it.
  String of(BuildContext context) => at(SiteLocaleScope.of(context));
}

/// Words that belong to no single page.
abstract class CommonCopy {
  static const role = Copy('SOFTWARE DEVELOPER', 'YAZILIM GELİŞTİRİCİ');
  static const getInTouch = Copy('Get in touch', 'İLETİŞİME GEÇİN');

  /// The nav bar's action once the links no longer fit beside it.
  static const menu = Copy('Menu', 'MENÜ');
  static const close = Copy('Close', 'KAPAT');

  static const loadingRepos = Copy(
    'Loading repositories',
    'Repolar yükleniyor',
  );
  static const noRepos = Copy(
    'Repositories are unavailable right now',
    'Repolara şu anda ulaşılamıyor',
  );
  static const loadingPackages = Copy(
    'Loading packages',
    'Paketler yükleniyor',
  );
  static const noPackages = Copy(
    'Packages are unavailable right now',
    'Paketlere şu anda ulaşılamıyor',
  );

  /// GitHub's own field, empty on a fair number of repositories.
  static const noDescription = Copy('No description.', 'Açıklama yok.');
}

/// The five sections, as the nav bar and the section stamps name them.
///
/// One entry each, used in both places, so a page can never be called one
/// thing in the bar and another at the top of itself.
abstract class SectionCopy {
  static const home = Copy('Home', 'ANASAYFA');

  /// Keyed to `Routes.work` and to `/work`, which stay as they are: a path is
  /// an address someone may have bookmarked, and renaming it would break
  /// every link to it. The identifier names the route; the value names it to
  /// the reader.
  static const work = Copy('Projects', 'PROJELER');
  static const packages = Copy('Packages', 'PAKETLER');
  static const about = Copy('About', 'HAKKIMDA');
  static const contact = Copy('Contact', 'İLETİŞİM');
}

abstract class HomeCopy {
  static const heroEyebrow = Copy(
    'Software developer // Flutter & Dart // TÜRKİYE',
    'YAZILIM GELİŞTİRİCİ // FLUTTER & DART // TÜRKİYE',
  );
  static const heroLede = Copy(
    'I write software and build products.',
    'Yazılım geliştiriciyim ve ürünler yapıyorum.',
  );
  static const heroSecondLine = Copy(
    'I share my open source work on GitHub and pub.dev.',
    "Open source projelerimi GitHub ve pub.dev'de paylaşıyorum.",
  );
  /// The home page's own four, where [allProjects] leads to all of them.
  static const myProjects = Copy('My projects', 'PROJELERİM');

  static const specPackages = Copy('Packages', 'PAKET');
  static const specPublisherLabel = Copy('pub.dev', 'pub.dev');
  static const specPublisherValue = Copy('Publisher', 'YAYINCI');
  static const specOpenLabel = Copy('Open', 'AÇIK');
  static const specOpenValue = Copy('Source', 'KAYNAK');
  static const specLive = Copy('Live', 'CANLI');

  /// Ticker items. Uppercased by the marquee, hence the authored case.
  static const marquee = [
    Copy('Flutter', 'FLUTTER'),
    Copy('Dart', 'DART'),
    Copy('pub.dev publisher', 'PUB.DEV YAYINCISI'),
    Copy('Open source', 'AÇIK KAYNAK'),
    Copy('Mobile', 'MOBİL'),
    Copy('Web', 'WEB'),
  ];

  static const workEyebrow = Copy('Repositories', 'REPOLAR');
  static const workLede = Copy(
    'My four most-starred projects on GitHub.'
        '\nThe full list is on the Projects page.',
    "GitHub'da en çok yıldız alan dört projem."
        '\nTamamına Projeler sayfasından ulaşabilirsiniz.',
  );
  static const allProjects = Copy('All projects', 'TÜM PROJELER');

  static const packagesLede = Copy(
    'The open source packages I publish on GitHub and pub.dev.'
        '\nThe full list is on the Packages page.',
    "GitHub'da ve pub.dev'de paylaştığım açık kaynaklı paketlerim."
        '\nTamamına Paketler sayfasından ulaşabilirsiniz.',
  );
  static const allPackages = Copy('All packages', 'TÜM PAKETLER');

  static const moreAboutMe = Copy('More about me', 'DAHA FAZLASI');

  static const contributionsStamp = Copy('Last year', 'SON BİR YIL');
  static const contributionsLede = Copy(
    'A year of contributions, read live from GitHub.',
    "Son bir yılın katkı takvimi, canlı olarak GitHub'dan çekiliyor.",
  );
  static const loadingCalendar = Copy(
    'Loading the calendar',
    'Takvim yükleniyor',
  );
  static const noCalendar = Copy(
    'The contribution calendar is unavailable right now',
    'Katkı takvimine şu anda ulaşılamıyor',
  );
}

abstract class WorkCopy {
  static const lede = Copy(
    'Every public repository, sorted by stars.'
        '\nYou can filter them by language.',
    'Açık kaynak repolarımın tamamı, yıldız sayısına göre sıralıdır.'
        '\nYazılım diline göre filtreleyebilirsiniz.',
  );

  /// The leading filter. Not uppercased — `SignalTabs` renders labels as given.
  static const filterAll = Copy('All', 'Tümü');

  /// Trails the `n / m` count.
  static const repoUnit = Copy('repos', 'repo');
}

abstract class PackagesCopy {
  static const lede = Copy(
    'Some of the tools and techniques I use myself, packaged up.'
        '\nAll open source, all published on pub.dev.',
    'Kendi kullandığım teknolojilerin ve yöntemlerin bazılarını paket olarak '
        'paylaşıyorum.'
        '\nHepsi açık kaynak ve pub.dev üzerinden yayında.',
  );
  static const publisher = Copy(
    'Publisher on pub.dev',
    'PUB.DEV YAYINCI SAYFASI',
  );

  static const likes = Copy('likes', 'BEĞENİ');
  static const points = Copy('points', 'PUAN');
  static const downloads = Copy('downloads', 'İNDİRME');

  /// How long ago a package was last published.
  ///
  /// Formatted here rather than at fetch time: the data is cached for the
  /// session and the language is not, so a string baked when the response
  /// arrived would be stuck in whichever language happened to be showing.
  ///
  /// Turkish does not pluralise a counted noun — *3 ay önce*, not *3 aylar
  /// önce* — which is exactly the kind of thing a shared format string gets
  /// wrong.
  static String publishedAgo(DateTime published, SiteLocale locale) {
    final days = DateTime.now().toUtc().difference(published.toUtc()).inDays;
    final turkish = locale == SiteLocale.tr;

    String plural(int n, String unit) => '$n $unit${n > 1 ? 's' : ''} ago';

    if (days >= 365) {
      final years = days ~/ 365;
      return turkish ? '$years yıl önce' : plural(years, 'year');
    }
    if (days >= 30) {
      final months = days ~/ 30;
      return turkish ? '$months ay önce' : plural(months, 'month');
    }
    if (days >= 1) {
      return turkish ? '$days gün önce' : plural(days, 'day');
    }
    return turkish ? 'bugün' : 'today';
  }
}

abstract class AboutCopy {
  static const eyebrow = Copy(
    'Can Arslan // SOFTWARE DEVELOPER',
    'Can Arslan // YAZILIM GELİŞTİRİCİ',
  );

  static const certificates = Copy('Certificates', 'SERTİFİKALAR');
  static const certificate = Copy('Certificate', 'SERTİFİKA');
  static const competitions = Copy('Competitions', 'YARIŞMALAR');
  static const projectManager = Copy('Project manager', 'PROJE YÖNETİCİSİ');

  static Copy greeting(int age) => Copy(
        "Hello, I'm Can. I am $age and I build software.",
        'Merhaba, ben Can. $age yaşındayım ve yazılım geliştiriyorum.',
      );

  static const work = Copy(
    'I work mostly in Flutter and Dart, on mobile and on the web. When '
        'something I built turns out to be useful on its own, I package it up '
        'and publish it on pub.dev.',
    'Çoğunlukla Flutter ve Dart ile çalışıyorum. Mobil ve web tarafında '
        'ürünler yazıyorum, işime yarayan bir şey çıkınca da paketleyip '
        "pub.dev'de paylaşıyorum.",
  );
  static const openSource = Copy(
    'I like leaving what I learn out in the open. The code and the design of '
        'this site are both on GitHub, if you want a look.',
    'Öğrendiklerimi açık kaynak bırakmayı seviyorum. Bu sitenin kodu da '
        "tasarımı da GitHub'da duruyor, dilerseniz bakabilirsiniz.",
  );
}

abstract class ContactCopy {
  static const eyebrow = Copy('Say hello', 'MERHABA');
  static const lede = Copy(
    'If you have an idea, a question, or simply curiosity, you can write.'
        '\nI usually get back to email the same day.',
    'Bir fikriniz, bir sorunuz ya da sadece merakınız varsa yazabilirsiniz.'
        '\nE-postalara genelde aynı gün içinde dönüyorum.',
  );

  static const elsewhere = Copy('Elsewhere', 'BAŞKA YERLERDE');

  static const github = Copy(
    'My projects, my packages, and the source of this site.',
    'Projelerim, paketlerim ve bu sitenin kaynak kodu.',
  );
  static const githubMeta = Copy('Open source', 'AÇIK KAYNAK');
  static const linkedin = Copy(
    'Where my work history and professional contact live.',
    'İş geçmişim ve profesyonel iletişim için.',
  );
  static const linkedinMeta = Copy('Profile', 'PROFİL');
  static const x = Copy(
    'Where I write about what I am up to, now and then.',
    'Ara sıra neler yaptığımı yazdığım yer.',
  );
  static const xMeta = Copy('Feed', 'AKIŞ');
  static const pubDev = Copy(
    'The Flutter and Dart packages I publish.',
    'Yayımladığım Flutter ve Dart paketleri.',
  );
  static const pubDevMeta = Copy('Publisher', 'YAYINCI');

  static const basedIn = Copy('Based in', 'MERKEZ');
  static const repliesLabel = Copy('Usually replies', 'GENELDE YANIT');
  static const repliesValue = Copy('Same day', 'AYNI GÜN');
  static const localTime = Copy('Local time', 'YEREL SAAT');
  static const now = Copy('Now', 'ŞİMDİ');

  static const sendEmail = Copy('Send an email', 'E-POSTA GÖNDERİN');
  static const copyAddress = Copy('Copy address', 'ADRESİ KOPYALAYIN');
  static const copied = Copy('Copied', 'KOPYALANDI');
}

abstract class NotFoundCopy {
  static const eyebrow = Copy('Error // 404', 'HATA // 404');
  static const title = Copy('Not found', 'BULUNAMADI');
  static const lede = Copy(
    'The page you are looking for is not here. It may have moved, or it may '
        'never have existed.'
        '\nYou can carry on from one of the links below.',
    'Aradığınız sayfa burada değil. Taşınmış ya da hiç var olmamış olabilir.'
        '\nAşağıdaki bağlantılardan devam edebilirsiniz.',
  );
}

/// The contribution calendar's own labels.
abstract class CalendarCopy {
  static const less = Copy('Less', 'AZ');
  static const more = Copy('More', 'ÇOK');

  static Copy total(int contributions) => Copy(
        '$contributions contributions // last year',
        '$contributions katkı // son bir yıl',
      );

  /// Three letters, because that is all a week column is wide.
  static const _en = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];
  static const _tr = [
    'OCA', 'ŞUB', 'MAR', 'NİS', 'MAY', 'HAZ',
    'TEM', 'AĞU', 'EYL', 'EKİ', 'KAS', 'ARA',
  ];

  static List<String> months(SiteLocale locale) =>
      locale == SiteLocale.tr ? _tr : _en;
}
