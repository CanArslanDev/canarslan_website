import 'dart:convert';

import 'package:canarslan_website/services/vault_crypto_stub.dart'
    if (dart.library.js_interop) 'package:canarslan_website/services/vault_crypto_web.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// The lock on the private pages, and whatever they need that cannot ship in
/// the open.
///
/// `web/vault.json` is one AES-GCM blob built by `tool/vault.js` from a file
/// you keep locally. Both are gitignored, so neither the data nor the code
/// that reads it leaves a trace in a public repository. Unlocking is simply
/// decryption succeeding: there is no passcode anywhere in the bundle to
/// compare against, because there is nothing to compare — the code either
/// opens the blob or it does not.
///
/// [data] is whatever JSON you put in. A private page can read a name, a date,
/// a list of photographs to fetch, without any of it being in the bundle in
/// the clear.
///
/// **What this does not do.** The blob is served to anyone who asks, so they
/// can take it away and try passcodes against it offline, as fast as their
/// hardware allows. A high PBKDF2 count makes each attempt cost real time, but
/// six digits is a million attempts and that is a short afternoon for a GPU.
/// It keeps things out of the repository and away from anyone reading the
/// bundle. It is not a place for anything that would actually hurt to lose.
abstract class Vault {
  /// Where the encrypted file sits once the build has copied `web/` across.
  /// Absent on a checkout that has never run the tool, which is the normal
  /// state of the public repository.
  static const _file = 'vault.json';

  static const _timeout = Duration(seconds: 8);

  static Map<String, dynamic>? _data;

  /// Whatever was inside, once unlocked. Null until then.
  ///
  /// Kept in memory only. Nothing decrypted is written to storage and the
  /// passcode is never stored at all, so closing the tab locks the door again.
  static Map<String, dynamic>? get data => _data;

  static bool get isOpen => _data != null;

  static void close() => _data = null;

  /// Fetches the blob and tries [passcode] against it.
  ///
  /// Returns false for a wrong code, a missing file and a corrupt one alike.
  /// The gate cannot tell them apart, and telling a visitor which one it was
  /// would only confirm the vault exists.
  static Future<bool> unlock(String passcode) async {
    try {
      final response =
          await http.get(Uri.base.resolve(_file)).timeout(_timeout);
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

      _data = jsonDecode(plain) as Map<String, dynamic>;
      return true;
    } catch (_) {
      return false;
    }
  }

  static Uint8List _bytes(Object? base64Value) =>
      base64Decode(base64Value! as String);
}
