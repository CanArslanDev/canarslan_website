import 'package:canarslan_website/data/vault.dart';
import 'package:canarslan_website/pages/not_found/not_found_page.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// A page that exists only behind the passcode.
///
/// It is a whole route, not a panel inside the gate — entering the code takes
/// you to it the way any other link would, and what it draws is entirely up to
/// its builder — a page made for one person can be exactly that, with no
/// navigation bar and nothing of this site in it.
@immutable
class PrivatePage {
  const PrivatePage({
    required this.path,
    required this.title,
    required this.build,
  });

  /// Where it lives. Not in `Routes`, because that file is public — the path
  /// arrives with the page.
  final String path;

  /// Shown only when there is more than one page and the gate has to ask
  /// which. With a single page nobody ever sees it.
  final String title;

  final WidgetBuilder build;
}

/// The private pages, registered before the app starts.
///
/// **Empty in this repository, and that is the whole point.** These are real
/// Flutter pages, and code cannot be encrypted the way the vault's data is —
/// it has to run. What it can do is not be here.
///
/// The registration happens in a second entrypoint that is not committed:
///
/// ```dart
/// // lib/main_private.dart — gitignored, and so is lib/private/
/// import 'package:canarslan_website/main.dart' as app;
/// import 'package:canarslan_website/pages/passcode/private_pages.dart';
/// import 'package:canarslan_website/private/some_page.dart';
///
/// void main() {
///   PrivatePages.register([
///     PrivatePage(
///       path: '/somewhere',
///       title: 'Somewhere',
///       build: (_) => const SomePage(),
///     ),
///   ]);
///   app.main();
/// }
/// ```
///
/// ```bash
/// flutter build web --release -t lib/main_private.dart
/// ```
///
/// A second entrypoint rather than a stub file someone has to keep in sync, or
/// a tracked file carrying local edits: `lib/main.dart` is untouched, still
/// builds and still passes its tests. It registers nothing, so on a fresh
/// clone the door opens onto an empty room and nothing is broken.
///
/// **What this is worth.** A page built this way ships as compiled code in
/// `main.dart.js`, so the passcode is a curtain in front of it rather than a
/// lock on it. Anything that must not be readable at all belongs in the
/// vault, which stays ciphertext until the code opens it — and a private page
/// can read it through `Vault.data`.
abstract class PrivatePages {
  static List<PrivatePage> _pages = const [];

  static List<PrivatePage> get all => _pages;

  static void register(List<PrivatePage> pages) =>
      _pages = List.unmodifiable(pages);

  /// The routes, for the router to append to its own.
  static List<GetPage<void>> get routes => [
        for (final page in _pages)
          GetPage(name: page.path, page: () => _Guarded(page: page)),
      ];
}

/// A private route is only a private route while the vault is open.
///
/// Typing the address without the code lands on the 404 page rather than
/// anything that would confirm the path exists. The vault is held in memory
/// only, so a reload closes it again and the address stops working — which is
/// the same rule as everywhere else here, not a special case.
class _Guarded extends StatelessWidget {
  const _Guarded({required this.page});

  final PrivatePage page;

  @override
  Widget build(BuildContext context) =>
      Vault.isOpen ? page.build(context) : const NotFoundPage();
}
