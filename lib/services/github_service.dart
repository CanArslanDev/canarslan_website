import 'dart:convert';

import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/services/storage_service.dart';
import 'package:http/http.dart' as http;

/// Reads public repositories from GitHub's JSON API.
///
/// Unauthenticated, which is rate-limited per IP (60 requests an hour) — hence
/// the cache. Results are kept for [_maxAge] so a repeat visit is instant and a
/// rate-limited one still has something to show, but the list does not go stale
/// for good the way the previous never-expiring cache did.
abstract class GitHubService {
  static const _maxAge = Duration(hours: 6);
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

  static Future<List<RepoInfo>> repositories(String username) async {
    final cached = _readCache(username);

    try {
      final response = await http
          .get(
            Uri.parse('https://api.github.com/users/$username/repos?per_page=100'),
            headers: const {'Accept': 'application/vnd.github+json'},
          )
          .timeout(_timeout);

      if (response.statusCode != 200) return cached ?? const [];

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

      _writeCache(username, repos);
      return repos.map(RepoInfo.fromMap).toList();
    } catch (_) {
      return cached ?? const [];
    }
  }

  static List<RepoInfo>? _readCache(String username) {
    final raw = StorageService.loadGithubRepositories(username);
    if (raw == null) return null;
    try {
      final envelope = jsonDecode(raw) as Map<String, dynamic>;
      final storedAt = DateTime.tryParse(envelope['storedAt'] as String? ?? '');
      if (storedAt == null ||
          DateTime.now().difference(storedAt) > _maxAge) {
        return null;
      }
      return [
        for (final entry in envelope['repos'] as List)
          RepoInfo.fromMap(Map<String, dynamic>.from(entry as Map)),
      ];
    } catch (_) {
      return null;
    }
  }

  static void _writeCache(String username, List<Map<String, dynamic>> repos) {
    StorageService.saveGithubRepositories(
      username,
      jsonEncode({
        'storedAt': DateTime.now().toIso8601String(),
        'repos': repos,
      }),
    );
  }
}
