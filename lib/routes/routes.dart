import 'package:canarslan_website/i18n/site_copy.dart';

abstract class Routes {
  static const String home = '/';
  static const String work = '/work';
  static const String packages = '/packages';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String notFound = '/not-found';

  /// Internal storybook for the SIGNAL design system. Deliberately absent from
  /// [navigation] — it is a working tool, not part of the site.
  static const String design = '/design';

  /// The routes the navigation bar offers, in order.
  ///
  /// The label is a [Copy], not a string: the bar and the section stamp read
  /// the same entry, so a page cannot end up called one thing in the nav and
  /// another at the top of itself — in either language.
  static const List<(String path, Copy label)> navigation = [
    (home, SectionCopy.home),
    (work, SectionCopy.work),
    (packages, SectionCopy.packages),
    (about, SectionCopy.about),
    (contact, SectionCopy.contact),
  ];

  static int navigationIndexOf(String path) {
    final index = navigation.indexWhere((entry) => entry.$1 == path);
    return index == -1 ? 0 : index;
  }

  static bool isKnown(String path) =>
      path == design ||
      path == notFound ||
      navigation.any((entry) => entry.$1 == path);
}
