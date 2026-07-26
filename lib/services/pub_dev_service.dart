import 'dart:convert';

import 'package:canarslan_website/data/site_models.dart';
import 'package:http/http.dart' as http;

/// Reads package data from pub.dev's public JSON API.
///
/// Two endpoints, both of which send `Access-Control-Allow-Origin: *`, so the
/// browser can call them directly:
///
/// * `/api/packages/<name>` — description, version, publish date
/// * `/api/packages/<name>/score` — likes, pub points, downloads, platforms
///
/// This replaces scraping the publisher's HTML through a public CORS proxy.
/// That approach depended on pub.dev's CSS class names and on a third party
/// staying up; at the time of writing the proxy answers 522 after twenty
/// seconds, which is exactly the failure it was always going to have.
abstract class PubDevService {
  static const _base = 'https://pub.dev/api/packages';
  static const _timeout = Duration(seconds: 8);

  /// Fetches one package. Returns null if it cannot be read, so a single dead
  /// package does not take the whole list down with it.
  static Future<PackageInfo?> fetch(String name) async {
    try {
      final results = await Future.wait([
        http.get(Uri.parse('$_base/$name')).timeout(_timeout),
        http.get(Uri.parse('$_base/$name/score')).timeout(_timeout),
      ]);

      final detail = results[0];
      final score = results[1];
      if (detail.statusCode != 200) return null;

      final data = jsonDecode(detail.body) as Map<String, dynamic>;
      final latest = data['latest'] as Map<String, dynamic>? ?? {};
      final pubspec = latest['pubspec'] as Map<String, dynamic>? ?? {};

      final metrics = score.statusCode == 200
          ? jsonDecode(score.body) as Map<String, dynamic>
          : const <String, dynamic>{};

      return PackageInfo(
        name: name,
        url: 'https://pub.dev/packages/$name',
        description: (pubspec['description'] as String? ?? '').trim(),
        publisher: 'canarslan.me',
        published: DateTime.tryParse(latest['published'] as String? ?? ''),
        platforms: _platforms(metrics['tags']),
        likes: (metrics['likeCount'] ?? 0).toString(),
        points: (metrics['grantedPoints'] ?? 0).toString(),
        downloads: (metrics['downloadCount30Days'] ?? 0).toString(),
      );
    } catch (_) {
      return null;
    }
  }

  /// pub.dev reports platforms as `platform:ios` tags.
  static List<String> _platforms(Object? tags) {
    if (tags is! List) return const [];
    const labels = {
      'android': 'Android',
      'ios': 'iOS',
      'web': 'Web',
      'macos': 'macOS',
      'windows': 'Windows',
      'linux': 'Linux',
    };
    return [
      for (final tag in tags)
        if (tag is String && tag.startsWith('platform:'))
          labels[tag.substring(9)] ?? tag.substring(9),
    ];
  }

}
