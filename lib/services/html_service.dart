import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class HtmlService {
  Future<Map<String, String>> fetchPackages(String publisherUrl) async {
    final response = await http
        .get(Uri.parse('https://cors-anywhere.herokuapp.com/$publisherUrl'));

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

      return packages;
    } else {
      throw Exception('Failed to fetch packages: ${response.statusCode}');
    }
  }
}
