import 'dart:convert';

import 'package:canarslan_website/services/vault_crypto_stub.dart'
    if (dart.library.js_interop) 'package:canarslan_website/services/vault_crypto_web.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// One page behind the passcode.
@immutable
class VaultPage {
  const VaultPage({required this.title, required this.body});

  final String title;
  final List<String> body;
}

/// The private pages, and the one way in.
///
/// Everything here is deliberately content rather than code. The pages live in
/// `web/vault.json` as a single AES-GCM blob, which means the public repository
/// holds no trace of them and neither does the compiled bundle — a reader who
/// downloads either gets ciphertext. Adding a page is editing a local file and
/// re-running `tool/vault.js`; it never touches Dart, so it never touches a
/// commit.
///
/// **What this does not do.** The blob ships to the browser, so anyone can take
/// it away and try passcodes against it offline, as fast as their hardware
/// allows. A high PBKDF2 count makes each attempt expensive, but six digits is
/// a million attempts and that is a short afternoon for a GPU. This keeps the
/// pages out of the repository and away from anyone reading the bundle. It is
/// not a place for anything that would actually hurt to lose.
abstract class Vault {
  /// Where the encrypted file sits once the build has copied `web/` across.
  /// Absent on a checkout that has never run the tool, which is the normal
  /// state of the public repository.
  static const _file = 'vault.json';

  static const _timeout = Duration(seconds: 8);

  static List<VaultPage>? _open;

  /// The pages, once unlocked. Null until then.
  ///
  /// Kept in memory only. Nothing decrypted is written to storage and the
  /// passcode is never stored at all, so closing the tab locks the door again.
  static List<VaultPage>? get pages => _open;

  static bool get isOpen => _open != null;

  static void close() => _open = null;

  /// Fetches the blob and tries [passcode] against it.
  ///
  /// Returns false for a wrong code, a missing file and a corrupt one alike.
  /// The gate cannot tell them apart, and telling a visitor which one it was
  /// would only confirm the vault exists.
  static Future<bool> unlock(String passcode) async {
    try {
      final response = await http
          .get(Uri.base.resolve(_file))
          .timeout(_timeout);
      if (response.statusCode != 200) return false;

      final envelope = jsonDecode(response.body) as Map<String, dynamic>;
      final plain = await decryptVaultImpl(
        passcode: passcode,
        salt: _bytes(envelope['salt']),
        iv: _bytes(envelope['iv']),
        payload: _bytes(envelope['data']),
        iterations: (envelope['iterations'] as num).toInt(),
      );
      if (plain == null) return false;

      final decoded = jsonDecode(plain) as Map<String, dynamic>;
      _open = [
        for (final page in decoded['pages'] as List? ?? const [])
          VaultPage(
            title: (page as Map)['title']?.toString() ?? '',
            body: [
              for (final line in page['body'] as List? ?? const [])
                line.toString(),
            ],
          ),
      ];
      return true;
    } catch (_) {
      return false;
    }
  }

  static Uint8List _bytes(Object? base64Value) =>
      base64Decode(base64Value! as String);
}
