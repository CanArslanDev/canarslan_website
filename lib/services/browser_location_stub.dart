/// Non-web fallback so the widget tree can be built on the Dart VM.
String currentBrowserPath() => '/';

/// Non-web fallback: there is no address bar on the Dart VM.
String takeBrowserFragment() => '';
