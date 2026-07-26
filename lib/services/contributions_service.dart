import 'dart:convert';

import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/services/response_cache.dart';
import 'package:http/http.dart' as http;

/// Reads a year of GitHub contributions as JSON.
///
/// GitHub's own `/users/<name>/contributions` fragment sends no CORS header, so
/// a browser cannot read it; the site used to pull it through a public proxy,
/// which is why the calendar is empty whenever that proxy is down — as it is
/// now, answering 522 after twenty seconds.
///
/// This endpoint returns the same data as JSON and does send
/// `Access-Control-Allow-Origin: *`, so there is no third party in the path.
abstract class ContributionsService {
  static const _timeout = Duration(seconds: 8);

  static Future<ContributionYear> lastYear(String username) async {
    final key = 'contributions_$username';
    final cached = _decode(ResponseCache.read(key));
    if (cached != null) return cached;

    try {
      final response = await http
          .get(
            Uri.parse(
              'https://github-contributions-api.jogruber.de/v4/$username'
              '?y=last',
            ),
          )
          .timeout(_timeout);

      if (response.statusCode != 200) return ContributionYear.empty;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final raw = data['contributions'] as List? ?? const [];

      // Reduced to three fields a day before it is stored: the endpoint sends
      // roughly 365 objects and the calendar reads a date, a count and a level
      // out of each. Keeping the raw body would triple the entry for nothing.
      final days = <Map<String, dynamic>>[];
      for (final entry in raw) {
        if (entry is! Map) continue;
        if (DateTime.tryParse(entry['date']?.toString() ?? '') == null) {
          continue;
        }
        days.add({
          'date': entry['date'].toString(),
          'count': (entry['count'] as num?)?.toInt() ?? 0,
          'level': (entry['level'] as num?)?.toInt().clamp(0, 4) ?? 0,
        });
      }

      final total = (data['total'] as Map?)?.values.fold<int>(
            0,
            (sum, value) => sum + ((value as num?)?.toInt() ?? 0),
          ) ??
          days.fold<int>(0, (sum, day) => sum + (day['count']! as int));

      final payload = {'days': days, 'total': total};
      ResponseCache.write(key, payload);
      return _decode(payload) ?? ContributionYear.empty;
    } catch (_) {
      return ContributionYear.empty;
    }
  }

  static ContributionYear? _decode(Object? payload) {
    if (payload is! Map) return null;
    try {
      return ContributionYear(
        days: [
          for (final day in payload['days'] as List? ?? const [])
            ContributionDay(
              date: DateTime.parse((day as Map)['date'].toString()),
              count: (day['count'] as num?)?.toInt() ?? 0,
              level: (day['level'] as num?)?.toInt().clamp(0, 4) ?? 0,
            ),
        ],
        total: (payload['total'] as num?)?.toInt() ?? 0,
      );
    } catch (_) {
      return null;
    }
  }
}
