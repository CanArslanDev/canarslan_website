import 'dart:convert';

import 'package:canarslan_website/data/site_models.dart';
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

      final days = <ContributionDay>[];
      for (final entry in raw) {
        if (entry is! Map) continue;
        final date = DateTime.tryParse(entry['date']?.toString() ?? '');
        if (date == null) continue;
        days.add(
          ContributionDay(
            date: date,
            count: (entry['count'] as num?)?.toInt() ?? 0,
            level: (entry['level'] as num?)?.toInt().clamp(0, 4) ?? 0,
          ),
        );
      }

      final total = (data['total'] as Map?)?.values.fold<int>(
            0,
            (sum, value) => sum + ((value as num?)?.toInt() ?? 0),
          ) ??
          days.fold<int>(0, (sum, day) => sum + day.count);

      return ContributionYear(days: days, total: total);
    } catch (_) {
      return ContributionYear.empty;
    }
  }
}
