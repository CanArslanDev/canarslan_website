import 'package:web/web.dart' as web;

/// Schemes that must be passed through untouched — prefixing these with
/// `https://` would break the link.
const _passThroughSchemes = ['http://', 'https://', 'mailto:', 'tel:'];

void openUrlImpl(String url) {
  final target = _passThroughSchemes.any(url.startsWith) ? url : 'https://$url';
  web.window.open(target, '_blank');
}
