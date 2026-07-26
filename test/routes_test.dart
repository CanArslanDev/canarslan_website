import 'package:canarslan_website/routes/routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('routes', () {
    test('the nav offers exactly the site sections', () {
      expect(
        Routes.navigation.map((entry) => entry.$1),
        [
          Routes.home,
          Routes.projects,
          Routes.packages,
          Routes.about,
          Routes.contact,
        ],
      );
    });

    test('every navigable path is known', () {
      for (final (path, _) in Routes.navigation) {
        expect(Routes.isKnown(path), isTrue, reason: path);
      }
      expect(Routes.isKnown(Routes.design), isTrue);
      expect(Routes.isKnown('/nope'), isFalse);
    });

    test('a path we retired still leads somewhere', () {
      // /work was the projects section. Somebody has that link; landing them
      // on the 404 page for a rename of our own making would be our mistake,
      // not theirs.
      for (final entry in Routes.moved.entries) {
        expect(
          Routes.isKnown(entry.key),
          isFalse,
          reason: '${entry.key} is still a live route — it should not be in '
              'the moved map',
        );
        expect(
          Routes.isKnown(entry.value),
          isTrue,
          reason: '${entry.key} redirects to ${entry.value}, which does not '
              'exist',
        );
      }
      expect(Routes.moved['/work'], Routes.projects);
    });
  });
}
