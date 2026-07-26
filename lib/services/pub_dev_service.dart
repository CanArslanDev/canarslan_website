import 'dart:convert';

import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/services/response_cache.dart';
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
///
/// Two requests per package and seven packages is fourteen round trips before
/// the grid can draw anything, so the reduced result is cached: a repeat visit
/// inside [ResponseCache.maxAge] makes no requests at all. The cache holds the
/// fields the page shows rather than the raw responses, which keeps it small
/// and means a change to pub.dev's payload cannot half-parse an old entry.
abstract class PubDevService {
  static const _base = 'https://pub.dev/api/packages';
  static const _timeout = Duration(seconds: 8);

  /// Fetches one package. Returns null if it cannot be read, so a single dead
  /// package does not take the whole list down with it.
  static Future<PackageInfo?> fetch(String name) async {
    final cached = _decode(name, ResponseCache.read('pub_$name'));
    if (cached != null) return cached;

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

      final fields = <String, dynamic>{
        'description': (pubspec['description'] as String? ?? '').trim(),
        'published': latest['published'],
        'platforms': _platforms(metrics['tags']),
        'likes': (metrics['likeCount'] ?? 0).toString(),
        'points': (metrics['grantedPoints'] ?? 0).toString(),
        'downloads': (metrics['downloadCount30Days'] ?? 0).toString(),
      };
      ResponseCache.write('pub_$name', fields);
      return _build(name, fields);
    } catch (_) {
      return null;
    }
  }

  static PackageInfo? _decode(String name, Object? payload) {
    if (payload is! Map) return null;
    try {
      return _build(name, Map<String, dynamic>.from(payload));
    } catch (_) {
      return null;
    }
  }

  static PackageInfo _build(String name, Map<String, dynamic> fields) {
    return PackageInfo(
      name: name,
      url: 'https://pub.dev/packages/$name',
      description: fields['description'] as String? ?? '',
      publisher: StringConstants.publisher,
      published: DateTime.tryParse(fields['published'] as String? ?? ''),
      platforms: [
        for (final platform in fields['platforms'] as List? ?? const [])
          platform.toString(),
      ],
      likes: fields['likes'] as String? ?? '0',
      points: fields['points'] as String? ?? '0',
      downloads: fields['downloads'] as String? ?? '0',
    );
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
