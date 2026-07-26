import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// A package published on pub.dev.
@immutable
class PackageInfo {
  const PackageInfo({
    required this.name,
    required this.url,
    required this.description,
    required this.publisher,
    required this.publishedAgo,
    required this.platforms,
    required this.likes,
    required this.points,
    required this.downloads,
  });

  final String name;
  final String url;
  final String description;
  final String publisher;
  final String publishedAgo;
  final List<String> platforms;
  final String likes;
  final String points;
  final String downloads;

  /// `offline_sync_kit` reads as a package; `Offline Sync Kit` reads as a
  /// product. The list wants the former.
  String get title => name;
}

/// A public repository on GitHub.
@immutable
class RepoInfo {
  const RepoInfo({
    required this.name,
    required this.description,
    required this.language,
    required this.languageColor,
    required this.stars,
  });

  factory RepoInfo.fromMap(Map<String, dynamic> map) {
    final raw = map['color']?.toString() ?? '';
    final hasHex = raw.startsWith('#') && raw.length >= 7;

    return RepoInfo(
      name: map['name']?.toString() ?? 'unknown',
      description: map['description']?.toString() ?? '',
      language: map['language']?.toString() ?? 'Unknown',
      languageColor:
          hasHex ? Color(int.parse('0xFF${raw.substring(1, 7)}')) : null,
      stars: int.tryParse(map['stars']?.toString() ?? '') ?? 0,
    );
  }

  final String name;
  final String description;
  final String language;

  /// GitHub's language colour, when the API gave one. Null means "use the
  /// palette" — the design does not invent a colour to fill the gap.
  final Color? languageColor;

  final int stars;

  bool get hasDescription =>
      description.isNotEmpty && description != 'Unknown';
}

/// One day in the contributions calendar.
@immutable
class ContributionDay {
  const ContributionDay({
    required this.date,
    required this.count,
    required this.level,
  });

  final DateTime date;
  final int count;

  /// 0–4, as GitHub buckets them.
  final int level;
}

/// A year of contributions.
@immutable
class ContributionYear {
  const ContributionYear({required this.days, required this.total});

  static const empty = ContributionYear(days: [], total: 0);

  final List<ContributionDay> days;
  final int total;

  bool get isEmpty => days.isEmpty;
}
