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
  static const List<(String path, String label)> navigation = [
    (home, 'Home'),
    (work, 'Work'),
    (packages, 'Packages'),
    (about, 'About'),
    (contact, 'Contact'),
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
