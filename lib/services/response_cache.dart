import 'dart:convert';

import 'package:canarslan_website/services/storage_service.dart';

/// A timestamped envelope around a JSON response in `localStorage`.
///
/// Every one of the site's three sources is a public read-only endpoint whose
/// answer changes at most a few times a day, and all three were being asked
/// again on every single page load — pub.dev fourteen times, once per package
/// for its detail and once for its score. A visitor who came back an hour later
/// waited for all of it again.
///
/// Reads are **cache-first**: a fresh entry is returned without touching the
/// network at all. That is the difference from what GitHub's loader used to do,
/// which read the cache and then made the request anyway, using the cached copy
/// only if the request failed — the cache saved a rate-limited visitor, but
/// never saved anyone any time.
abstract class ResponseCache {
  /// Long enough that a repeat visit in the same sitting is free, short enough
  /// that a package published this morning shows up this afternoon.
  static const maxAge = Duration(hours: 6);

  /// The stored payload, or null when it is missing, stale or unreadable.
  static Object? read(String key, {Duration maxAge = maxAge}) {
    final raw = StorageService.loadResponse(key);
    if (raw == null) return null;
    try {
      final envelope = jsonDecode(raw) as Map<String, dynamic>;
      final storedAt = DateTime.tryParse(envelope['storedAt'] as String? ?? '');
      if (storedAt == null) return null;
      if (DateTime.now().difference(storedAt) > maxAge) return null;
      return envelope['payload'];
    } catch (_) {
      // A cache that cannot be parsed is a cache miss, never an error: the
      // shape may simply have changed since it was written.
      return null;
    }
  }

  static void write(String key, Object? payload) {
    try {
      StorageService.saveResponse(
        key,
        jsonEncode({
          'storedAt': DateTime.now().toIso8601String(),
          'payload': payload,
        }),
      );
    } catch (_) {
      // Storage can be full or blocked outright by a privacy setting. Failing
      // to cache is not a reason to fail to show the page.
    }
  }
}
