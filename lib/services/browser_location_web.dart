import 'package:web/web.dart' as web;

/// The path the browser is currently showing.
String currentBrowserPath() {
  final path = web.window.location.pathname;
  return path.isEmpty ? '/' : path;
}
