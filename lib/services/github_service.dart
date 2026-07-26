import 'dart:convert';

import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/services/response_cache.dart';
import 'package:http/http.dart' as http;

/// Reads public repositories from GitHub's JSON API.
///
/// Unauthenticated, which is rate-limited per IP (60 requests an hour) — hence
/// the cache. A fresh entry is served without a request at all; a stale or
/// missing one falls through to the network, and a failure there falls back to
/// whatever is stored however old it is, because a list from this morning beats
/// an empty section.
abstract class GitHubService {
  static const _timeout = Duration(seconds: 8);

  /// Colours GitHub uses for the languages that actually appear here. Anything
  /// else renders in the palette rather than in an invented colour.
  static const _languageColors = {
    'JavaScript': '#f1e05a',
    'TypeScript': '#3178c6',
    'Python': '#3572A5',
    'Java': '#b07219',
    'Dart': '#00B4AB',
    'Swift': '#ffac45',
    'Kotlin': '#F18E33',
    'C++': '#f34b7d',
    'C': '#555555',
    'Shell': '#89e051',
    'HTML': '#e34c26',
    'CSS': '#563d7c',
    'Go': '#00ADD8',
    'Ruby': '#701516',
    'Rust': '#dea584',
  };

  static String _key(String username) => 'github_repos_$username';

  static Future<List<RepoInfo>> repositories(String username) async {
    final fresh = _decode(ResponseCache.read(_key(username)));
    if (fresh != null) return fresh;

    try {
      final response = await http
          .get(
            Uri.parse('https://api.github.com/users/$username/repos?per_page=100'),
            headers: const {'Accept': 'application/vnd.github+json'},
          )
          .timeout(_timeout);

      if (response.statusCode != 200) return _stale(username);

      final data = jsonDecode(response.body) as List;
      final repos = <Map<String, dynamic>>[
        for (final entry in data)
          if (entry is Map<String, dynamic> && entry['fork'] != true)
            {
              'name': entry['name'] ?? 'unknown',
              'description': entry['description'] ?? '',
              'language': entry['language'] ?? 'Unknown',
              'color': _languageColors[entry['language']] ?? '',
              'stars': (entry['stargazers_count'] ?? 0).toString(),
            },
      ]..sort(
          (a, b) => int.parse(b['stars'] as String)
              .compareTo(int.parse(a['stars'] as String)),
        );

      ResponseCache.write(_key(username), repos);
      return repos.map(RepoInfo.fromMap).toList();
    } catch (_) {
      return _stale(username);
    }
  }

  /// The cached list at any age. Only reached once the network has already
  /// failed, where the alternative is showing nothing.
  static List<RepoInfo> _stale(String username) {
    final payload = ResponseCache.read(
      _key(username),
      maxAge: const Duration(days: 3650),
    );
    return _decode(payload) ?? const [];
  }

  static List<RepoInfo>? _decode(Object? payload) {
    if (payload is! List) return null;
    try {
      return [
        for (final entry in payload)
          RepoInfo.fromMap(Map<String, dynamic>.from(entry as Map)),
      ];
    } catch (_) {
      return null;
    }
  }
}
