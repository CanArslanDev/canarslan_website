abstract class Routes {
  static const String mainPage = '/';
  static const String homePage = '/home';
  static const String contactPage = '/contact';
  static const String projectsPage = '/projects';
  static const String notFoundPage = '/not-found';

  /// Internal storybook for the SIGNAL design system. Not linked from the
  /// navigation; registered so the route guard does not bounce it to 404.
  static const String designPage = '/design';
}
