import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// The path the browser is currently showing.
String currentBrowserPath() {
  final path = web.window.location.pathname;
  return path.isEmpty ? '/' : path;
}

/// Set by the inline script in `web/index.html`, which takes the fragment out
/// of the address before Flutter boots and would read it as a route.
@JS('siteFragment')
external JSString? _siteFragment;

/// Whatever followed the `#` the page was opened with, handed over once.
///
/// The fragment is the one part of a URL the browser never sends, so a code
/// carried there reaches neither the host's logs nor a crawler fetching the
/// link. It is already gone from the address bar by the time Dart runs; this
/// clears the copy too, so a second reader gets nothing.
String takeBrowserFragment() {
  final fragment = _siteFragment?.toDart ?? '';
  _siteFragment = null;
  return fragment;
}
