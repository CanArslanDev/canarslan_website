import 'dart:convert';

import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/services/vault_crypto_stub.dart'
    if (dart.library.js_interop) 'package:canarslan_website/services/vault_crypto_web.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// A page that arrived encrypted: a list of blocks and how to dress them.
///
/// Blocks are left as maps rather than parsed into a type per kind. The
/// vocabulary is the renderer's business and a page that names a block this
/// build does not know simply draws nothing, which is the right failure for a
/// file you can re-encrypt in a second.
@immutable
class VaultPage {
  const VaultPage({required this.blocks, this.title = '', this.field});

  final String title;
  final SignalFieldMode? field;
  final List<Map<String, dynamic>> blocks;
}

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
  static List<VaultPage> _pages = const [];

  /// The page the gate sent us to. All private pages share one neutral route,
  /// so which one is showing is held here rather than in the address.
  static VaultPage? showing;

  /// Whatever was inside, once unlocked. Null until then.
  ///
  /// Kept in memory only. Nothing decrypted is written to storage and the
  /// passcode is never stored at all, so closing the tab locks the door again.
  static Map<String, dynamic>? get data => _data;

  static List<VaultPage> get pages => _pages;

  static bool get isOpen => _data != null;

  static void close() {
    _data = null;
    _pages = const [];
    showing = null;
  }

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

      final decoded = jsonDecode(plain) as Map<String, dynamic>;
      _data = decoded;
      _pages = [
        for (final page in decoded['pages'] as List? ?? const [])
          VaultPage(
            title: (page as Map)['title']?.toString() ?? '',
            field: _field(page['field']?.toString()),
            blocks: [
              for (final block in page['blocks'] as List? ?? const [])
                Map<String, dynamic>.from(block as Map),
            ],
          ),
      ];
      return true;
    } catch (_) {
      return false;
    }
  }

  static SignalFieldMode? _field(String? name) => switch (name) {
        'vortex' => SignalFieldMode.vortex,
        'wave' => SignalFieldMode.wave,
        'scan' => SignalFieldMode.scan,
        'ripple' => SignalFieldMode.ripple,
        _ => null,
      };

  static Uint8List _bytes(Object? base64Value) =>
      base64Decode(base64Value! as String);
}
