import 'package:canarslan_website/i18n/site_copy.dart';

abstract class Routes {
  static const String home = '/';
  static const String projects = '/projects';
  static const String packages = '/packages';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String notFound = '/not-found';

  /// Internal storybook for the SIGNAL design system. Deliberately absent from
  /// [navigation] — it is a working tool, not part of the site.
  static const String design = '/design';

  /// The door in front of the private pages. Also absent from [navigation]:
  /// it is reached by someone who was told the address.
  static const String passcode = '/passcode';

  /// Where a page out of the vault is shown. One address for all of them, and
  /// a name that says nothing: which page is showing is held in memory, so the
  /// bundle carries no private path and the address bar gives none away.
  static const String private = '/p';

  /// The routes the navigation bar offers, in order.
  ///
  /// The label is a [Copy], not a string: the bar and the section stamp read
  /// the same entry, so a page cannot end up called one thing in the nav and
  /// another at the top of itself — in either language.
  static const List<(String path, Copy label)> navigation = [
    (home, SectionCopy.home),
    (projects, SectionCopy.projects),
    (packages, SectionCopy.packages),
    (about, SectionCopy.about),
    (contact, SectionCopy.contact),
  ];

  /// Which nav item to light, or -1 for a route that is not one of them.
  ///
  /// The 404 page and the passcode gate are real routes with no place in the
  /// bar; falling back to 0 lit "Home" on both, which told a visitor they were
  /// somewhere they were not.
  static int navigationIndexOf(String path) =>
      navigation.indexWhere((entry) => entry.$1 == path);

  static bool isKnown(String path) =>
      path == design ||
      path == passcode ||
      path == private ||
      path == notFound ||
      navigation.any((entry) => entry.$1 == path);

  /// Paths that used to exist here, and where they went.
  ///
  /// `/work` was the projects section until it was renamed. Anyone who shared
  /// that link still has it, and landing them on the 404 page for a change of
  /// our own making would be the wrong answer — `RouteService.initialRoute`
  /// sends them on instead.
  static const Map<String, String> moved = {'/work': projects};
}
