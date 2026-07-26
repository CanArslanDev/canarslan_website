import 'package:canarslan_website/services/response_cache.dart';
import 'package:canarslan_website/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// The cache is what stands between a visitor and fifteen network round trips
/// on every page load, so it gets tested rather than assumed.
void main() {
  test('a fresh entry comes back', () {
    ResponseCache.write('k', {'a': 1});
    expect(ResponseCache.read('k'), {'a': 1});
  });

  test('a stale entry does not', () async {
    ResponseCache.write('stale', {'a': 1});
    await Future<void>.delayed(const Duration(milliseconds: 5));
    expect(ResponseCache.read('stale', maxAge: Duration.zero), isNull);
  });

  test('a missing entry reads as a miss', () {
    expect(ResponseCache.read('never-written'), isNull);
  });

  test('an unreadable entry reads as a miss, not an error', () {
    // A payload written by an older shape of the code, or a half-finished
    // write. Either way the page still has to load.
    StorageService.saveResponse('broken', 'not json at all');
    expect(ResponseCache.read('broken'), isNull);

    StorageService.saveResponse('undated', '{"payload": {"a": 1}}');
    expect(ResponseCache.read('undated'), isNull);
  });

  test('lists survive the round trip', () {
    ResponseCache.write('repos', [
      {'name': 'one', 'stars': '3'},
      {'name': 'two', 'stars': '1'},
    ]);
    final payload = ResponseCache.read('repos');
    expect(payload, isA<List<dynamic>>());
    expect((payload! as List).first, {'name': 'one', 'stars': '3'});
  });
}
