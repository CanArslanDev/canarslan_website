import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/pages/app_shell.dart';
import 'package:flutter/widgets.dart';

/// A block that waits for one of the site's three remote sources.
///
/// Every section that shows fetched data was writing the same twelve lines:
/// a `FutureBuilder`, a null check for "still loading", an empty check for
/// "could not be reached", and only then the content. Four copies, and each
/// one an opportunity to forget the empty case and render an empty grid with
/// no explanation.
///
/// Both waiting states resolve to the same quiet line, because the difference
/// does not matter to a visitor — only whether there is anything to read yet.
class SiteData<T> extends StatelessWidget {
  const SiteData({
    required this.future,
    required this.loading,
    required this.unavailable,
    required this.builder,
    super.key,
    this.isEmpty,
  });

  final Future<T> future;

  /// Shown while the request is in flight.
  final Copy loading;

  /// Shown when it arrived with nothing in it.
  final Copy unavailable;

  /// What counts as nothing. Lists know their own emptiness; anything else
  /// says so here.
  final bool Function(T value)? isEmpty;

  final Widget Function(BuildContext context, T value) builder;

  bool _empty(T value) {
    final test = isEmpty;
    if (test != null) return test(value);
    return value is Iterable && value.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        final value = snapshot.data;
        if (value == null) {
          return PagePlaceholder(message: loading.of(context));
        }
        if (_empty(value)) {
          return PagePlaceholder(message: unavailable.of(context));
        }
        return builder(context, value);
      },
    );
  }
}
