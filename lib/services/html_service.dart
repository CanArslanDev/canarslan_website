import 'dart:convert';

import 'package:canarslan_website/services/storage_service.dart';
import 'package:canarslan_website/services/time_service.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class HtmlService {
  static Future<List<Map<String, String>>> fetchPackages(
    String publisherUrl,
  ) async {
    // Try to load from cache first
    final storagePackages = StorageService.loadPublisherPackages;
    if (storagePackages != null) {
      final decodedPackages = jsonDecode(storagePackages);
      if (decodedPackages is List) {
        return List<Map<String, String>>.from(
          decodedPackages.map((item) => Map<String, String>.from(item as Map)),
        );
      }
    }
    final response = await http.get(
      Uri.parse('https://api.codetabs.com/v1/proxy?quest=$publisherUrl'),
    );

    if (response.statusCode == 200) {
      final document = parse(response.body);

      // Publisher sayfasındaki paketleri bul
      final packageElements = document.querySelectorAll('.packages-item');
      final packages = <Map<String, String>>[];

      for (final element in packageElements) {
        final linkElement = element.querySelector('.packages-title a');
        final url = linkElement?.attributes['href'] ?? '';

        if (url.isNotEmpty) {
          final packageUrl = 'https://pub.dev$url';
          // Her paket için bilgileri çek
          final packageDetails = await fetchPackageDetails(packageUrl);
          packages.add(packageDetails);
        }
      }

      // Save to cache
      StorageService.savePublisherPackages(jsonEncode(packages));
      return packages;
    } else {
      throw Exception('Failed to fetch packages: ${response.statusCode}');
    }
  }

  static Future<Map<String, String>> fetchPackageDetails(
    String packageUrl,
  ) async {
    // Try to load from cache first
    final storagePackageDetails = StorageService.loadPackageDetails(packageUrl);
    if (storagePackageDetails != null) {
      final decodedDetails = jsonDecode(storagePackageDetails);
      if (decodedDetails is Map<String, dynamic>) {
        return Map<String, String>.from(decodedDetails);
      }
    }
    final response = await http.get(
      Uri.parse('https://api.codetabs.com/v1/proxy?quest=$packageUrl'),
    );

    if (response.statusCode == 200) {
      final document = parse(response.body);

      // Extracting package details using JSON-LD data
      final jsonLdScript =
          document.querySelector('script[type="application/ld+json"]');
      var jsonLdData = <String, dynamic>{};
      if (jsonLdScript != null) {
        jsonLdData = json.decode(jsonLdScript.text) as Map<String, dynamic>;
      }

      // Package name
      final nameElement = document.querySelector('.title');
      final name = nameElement?.text.trim().split(' ').first ?? 'Unknown';

      // Description
      final description =
          document.querySelector('.pkg-infobox-metadata + p')?.text.trim() ??
              jsonLdData['description']?.toString() ??
              'No description';

      // Publisher
      var publisher = 'Unknown';
      final publisherLink = document.querySelector('a[href^="/publishers/"]');
      if (publisherLink != null) {
        publisher = publisherLink.text.trim();
      }

      // Metrics
      final likes = document
              .querySelector(
                '.packages-score-like .packages-score-value-number',
              )
              ?.text
              .trim() ??
          '0';
      final points = document
              .querySelector(
                '.packages-score-health .packages-score-value-number',
              )
              ?.text
              .trim() ??
          '0';
      final downloads = document
              .querySelector(
                '.packages-score-downloads .packages-score-value-number',
              )
              ?.text
              .trim() ??
          '0';

      // Published time from JSON-LD
      final publishedTime = jsonLdData['dateModified']?.toString() ??
          jsonLdData['dateCreated']?.toString() ??
          'Unknown';

      // Convert published time to relative time
      final relativePublishedTime = publishedTime != 'Unknown'
          ? TimeService.getRelativeTime(DateTime.parse(publishedTime))
          : 'Unknown';

      // Platforms - Looking for specific platform icons or text
      final platformsList = <String>[];
      final platformElements = document.querySelectorAll('.tag-badge-sub');
      for (final element in platformElements) {
        final platformText = element.text.trim().toLowerCase();
        if (platformText.contains('android')) platformsList.add('Android');
        if (platformText.contains('ios')) platformsList.add('iOS');
        if (platformText.contains('web')) platformsList.add('Web');
        if (platformText.contains('linux')) platformsList.add('Linux');
        if (platformText.contains('windows')) platformsList.add('Windows');
        if (platformText.contains('macos')) platformsList.add('macOS');
      }
      final platforms =
          platformsList.isEmpty ? 'Unknown' : platformsList.join(', ');

      // Try to get GitHub repository link
      var readmeContent = '';
      final repoLink =
          document.querySelector('a[href*="github.com"]')?.attributes['href'];

      if (repoLink != null) {
        // Convert HTML URL to API URL
        // Example: https://github.com/username/repo -> https://api.github.com/repos/username/repo
        final apiUrl = repoLink
            .replaceFirst('github.com', 'api.github.com/repos')
            .replaceAll(
              'https://api.github.com/repos/https://api.github.com/repos/',
              'https://api.github.com/repos/',
            )
            .replaceAll(RegExp('/tree/.*'), '');
        try {
          final readmeResponse = await http.get(
            Uri.parse('$apiUrl/readme'),
            headers: {'Accept': 'application/vnd.github.raw'},
          );

          if (readmeResponse.statusCode == 200) {
            readmeContent = readmeResponse.body;

            // Remove <img> tags, links, headers, lines starting with !,
            //and backticks
            readmeContent = readmeContent.replaceAll(RegExp('<img[^>]*>'), '');
            readmeContent =
                readmeContent.replaceAll(RegExp(r'\[.*?\]\(.*?\)'), '');
            readmeContent =
                readmeContent.replaceAll(RegExp('^#.*', multiLine: true), '');
            readmeContent =
                readmeContent.replaceAll(RegExp(r'^\s*$', multiLine: true), '');
            readmeContent =
                readmeContent.replaceAll(RegExp('^!.*', multiLine: true), '');
            readmeContent = readmeContent.replaceAll('`', '');
            readmeContent = readmeContent.replaceAll('*', '');

            // Replace multiple consecutive empty lines with a single empty line
            readmeContent =
                readmeContent.replaceAll(RegExp(r'\n\s*\n'), '\n\n');
          }
        } catch (e) {
          // If GitHub API fails, try to get README from the webpage directly
          final markdownContent =
              document.querySelector('.markdown')?.text ?? '';
          if (markdownContent.isNotEmpty) {
            readmeContent = markdownContent;

            // Remove <img> tags, links, and headers
            readmeContent = readmeContent.replaceAll(RegExp('<img[^>]*>'), '');
            readmeContent =
                readmeContent.replaceAll(RegExp(r'\[.*?\]\(.*?\)'), '');
            readmeContent =
                readmeContent.replaceAll(RegExp('^#.*', multiLine: true), '');
          }
        }
      }

      // Extract all the package details as before...
      final details = {
        'name': name,
        'url': packageUrl,
        'published_time': relativePublishedTime,
        'publisher': publisher,
        'platforms': platforms,
        'likes': likes,
        'points': points,
        'downloads': downloads,
        'description': description,
        'readme_content': readmeContent,
      };

      // Save to cache
      StorageService.savePackageDetails(packageUrl, jsonEncode(details));
      return Map<String, String>.from(details);
    } else {
      throw Exception(
        'Failed to fetch package details: ${response.statusCode}',
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchGitHubRepositories(
    String username,
  ) async {
    // Try to load from cache first
    final storageRepos = StorageService.loadGithubRepositories(username);
    if (storageRepos != null) {
      final decodedRepos = jsonDecode(storageRepos);
      if (decodedRepos is List) {
        return List<Map<String, dynamic>>.from(decodedRepos);
      }
    }
    try {
      final url = 'https://api.github.com/users/$username/repos';
      // Debugging URL

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          // Eğer authentication kullanmak isterseniz:
          // 'Authorization': 'Bearer YOUR_GITHUB_TOKEN',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load data ${response.statusCode} ${response.body}',
        );
      }

      final data = jsonDecode(response.body) as List;

      // Repository bilgilerini al ve yıldız sayısına göre sırala
      final repositories = await Future.wait(
        data.map((repo) async {
          // Dil rengi için languages endpoint'ini kullanıyoruz

          final primaryLanguage =
              (repo as Map<String, dynamic>)['language'] ?? 'Unknown';

          // GitHub'ın yaygın diller için kullandığı renkler
          final languageColors = {
            'JavaScript': '#f1e05a',
            'Python': '#3572A5',
            'Java': '#b07219',
            'Dart': '#00B4AB',
            'Swift': '#ffac45',
            'Kotlin': '#F18E33',
            // Diğer diller için renkleri buraya ekleyebilirsiniz
          };

          return {
            'name': repo['name'] ?? 'Unknown',
            'description': repo['description'] ?? 'Unknown',
            'updated_at':
                '''Updated ${TimeService.getRelativeTime(DateTime.parse(repo['updated_at'] as String))}''',
            'language': primaryLanguage,
            'color': languageColors[primaryLanguage] ??
                '#FFFFFF', // #FFFFFF rengi ekledik
            'stars': repo['stargazers_count']
                .toString(), // Yıldız sayısını ekliyoruz
          };
        }).toList(),
      );

      // Yıldız sayısına göre azalan sırayla sıralama yapıyoruz
      repositories.sort((a, b) {
        final starsA = int.tryParse(a['stars'] as String) ?? 0;
        final starsB = int.tryParse(b['stars'] as String) ?? 0;
        return starsB.compareTo(starsA); // Azalan sıralama
      });

      StorageService.saveGithubRepositories(username, jsonEncode(repositories));
      return repositories;
    } catch (e) {
      return [];
    }
  }
}
