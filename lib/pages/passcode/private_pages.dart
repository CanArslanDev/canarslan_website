import 'package:flutter/widgets.dart';

/// A page that exists only behind the passcode.
@immutable
class PrivatePage {
  const PrivatePage({required this.title, required this.build});

  final String title;
  final WidgetBuilder build;
}

/// The private pages, registered before the app starts.
///
/// **Empty in this repository, and that is the whole point.** These are real
/// Flutter pages with real code, and code cannot be encrypted the way the
/// vault's text is — it has to run. What it can do is not be here.
///
/// The registration happens in a second entrypoint that is not committed:
///
/// ```dart
/// // lib/main_private.dart — gitignored
/// import 'package:canarslan_website/main.dart' as app;
/// import 'package:canarslan_website/pages/passcode/private_pages.dart';
/// import 'private/some_page.dart';
///
/// void main() {
///   PrivatePages.register([
///     PrivatePage(title: 'Some page', build: (_) => const SomePage()),
///   ]);
///   app.main();
/// }
/// ```
///
/// ```bash
/// flutter build web --release -t lib/main_private.dart
/// ```
///
/// The public entrypoint still builds and still passes its tests; it just
/// registers nothing, so the door opens onto an empty room. Nobody has to
/// keep a stub in sync and no tracked file carries local edits.
///
/// **What this is worth.** A page built this way ships as compiled code in
/// `main.dart.js`, so the passcode is a curtain in front of it rather than a
/// lock on it — someone reading the bundle can find what it draws. It keeps
/// the source out of a public repository, which is what was asked for. For
/// anything that must not be readable at all, put text in the vault instead:
/// that is ciphertext until the code opens it.
abstract class PrivatePages {
  static List<PrivatePage> _pages = const [];

  static List<PrivatePage> get all => _pages;

  static void register(List<PrivatePage> pages) =>
      _pages = List.unmodifiable(pages);
}
