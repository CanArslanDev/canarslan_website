import 'dart:convert';

import 'package:canarslan_website/services/storage_service.dart';
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
}
