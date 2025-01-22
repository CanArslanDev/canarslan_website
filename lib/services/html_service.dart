import 'dart:convert';

import 'package:canarslan_website/services/storage_service.dart';
import 'package:canarslan_website/services/time_service.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class HtmlService {
  Future<Map<String, String>> fetchPackages(String publisherUrl) async {
    final storagePackages = StorageService.loadPubDevPackages;
    if (storagePackages != null) {
      final decodedPackages = jsonDecode(storagePackages);
      if (decodedPackages is Map<String, String>) {
        return decodedPackages;
      }
    }
    final response = await http.get(
        Uri.parse('https://api.codetabs.com/v1/proxy?quest=$publisherUrl'));

    if (response.statusCode == 200) {
      final document = parse(response.body);

      final packageElements = document.querySelectorAll('.packages-item');
      final packages = <String, String>{};

      for (final element in packageElements) {
        final linkElement = element.querySelector('.packages-title a');
        final name = linkElement?.text.trim() ?? 'Unknown';
        final url = linkElement?.attributes['href'] ?? 'Unknown';

        if (name != 'Unknown' && url != 'Unknown') {
          packages[name] = 'pub.dev$url';
        }
      }

      StorageService.savePubDevPackages(jsonEncode(packages));
      return packages;
    } else {
      throw Exception('Failed to fetch packages: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchGitHubRepositories(
      String username) async {
    final storageRepositories = StorageService.loadRepositories;
    if (storageRepositories != null) {
      final decodedRepositories = jsonDecode(storageRepositories);
      if (decodedRepositories is List<dynamic>) {
        return List<Map<String, dynamic>>.from(decodedRepositories);
      }
    }
    try {
      final url = 'https://api.github.com/users/$username/repos';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load data ${response.statusCode} ${response.body}');
      }

      final data = jsonDecode(response.body) as List;

      final repositories = await Future.wait(data.map((repository) async {
        final repo = repository as Map<String, dynamic>;
        final primaryLanguage = repo['language'] ?? 'Unknown';

        final languageColors = {
          'JavaScript': '#f1e05a',
          'Python': '#3572A5',
          'Java': '#b07219',
          'Dart': '#00B4AB',
          'Swift': '#ffac45',
          'Kotlin': '#F18E33',
        };
        final timeString = TimeService.getRelativeTime(
          DateTime.parse(repo['updated_at'] as String),
        );

        return {
          'name': repo['name'] ?? 'Unknown',
          'description': repo['description'] ?? 'Unknown',
          'updated_at': 'Updated $timeString',
          'language': primaryLanguage,
          'color': languageColors[primaryLanguage] ?? '#FFFFFF',
          'stars': repo['stargazers_count'].toString(),
        };
      }).toList());

      repositories.sort((a, b) {
        final starsA = int.tryParse(a['stars'] as String) ?? 0;
        final starsB = int.tryParse(b['stars'] as String) ?? 0;
        return starsB.compareTo(starsA);
      });
      StorageService.saveRepositories(jsonEncode(repositories));

      return repositories;
    } catch (e) {
      return [];
    }
  }
}
