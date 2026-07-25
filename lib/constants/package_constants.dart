abstract class PackageConstants {
  /// Packages published under the canarslan.me publisher, in the order they
  /// should appear.
  ///
  /// The list is written down rather than discovered. pub.dev's search endpoint
  /// — the only one that can answer "what has this publisher shipped?" — sends
  /// no CORS header, so a browser cannot call it; the per-package endpoints do.
  /// The alternative was scraping the publisher page through a public proxy,
  /// which is how this used to work and which broke.
  ///
  /// Publishing a new package means adding one line here.
  static const List<String> published = [
    'flutter_liquid_glass',
    'offline_sync_kit',
    'contributions_chart',
    'simple_painter',
    'simple_animation_progress_bar',
    'flutter_blend_mask',
    'rune',
  ];
}
