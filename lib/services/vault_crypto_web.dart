import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:canarslan_website/services/vault_compartment.dart';
import 'package:web/web.dart' as web;

/// PBKDF2 parameters, as an object literal for `deriveKey`.
extension type _Pbkdf2Params._(JSObject _) implements JSObject {
  external factory _Pbkdf2Params({
    String name,
    JSUint8Array salt,
    int iterations,
    String hash,
  });
}

extension type _AesKeyGen._(JSObject _) implements JSObject {
  external factory _AesKeyGen({String name, int length});
}

extension type _AesGcmParams._(JSObject _) implements JSObject {
  external factory _AesGcmParams({String name, JSUint8Array iv});
}

/// Opens whichever compartment [passcode] belongs to, using the browser's own
/// crypto.
///
/// Web Crypto rather than a package: PBKDF2 and AES-GCM are both native here,
/// the derivation runs at native speed — which matters, because the whole
/// point of a high iteration count is to be slow for an attacker and bearable
/// for the one person who knows the code — and the site keeps its three
/// dependencies.
///
/// The expensive step runs once and the compartments are then tried against
/// the derived key, which costs almost nothing each. There is no index saying
/// which compartment a code belongs to, and there could not be one without
/// naming the codes in the file: the answer is simply whichever one's tag
/// checks out.
///
/// Returns null on any failure. A wrong passcode is indistinguishable from a
/// corrupt file on purpose: GCM's tag check fails either way, and the gate has
/// nothing useful to say about which.
Future<String?> decryptVaultImpl({
  required String passcode,
  required Uint8List salt,
  required int iterations,
  required List<VaultCompartment> compartments,
}) async {
  try {
    final subtle = web.window.crypto.subtle;

    final material = await subtle
        .importKey(
          'raw',
          Uint8List.fromList(utf8.encode(passcode)).toJS,
          'PBKDF2'.toJS,
          false,
          <JSString>['deriveKey'.toJS].toJS,
        )
        .toDart;

    final key = await subtle
        .deriveKey(
          _Pbkdf2Params(
            name: 'PBKDF2',
            salt: salt.toJS,
            iterations: iterations,
            hash: 'SHA-256',
          ),
          material,
          _AesKeyGen(name: 'AES-GCM', length: 256),
          false,
          <JSString>['decrypt'.toJS].toJS,
        )
        .toDart;

    for (final compartment in compartments) {
      try {
        final plain = await subtle
            .decrypt(
              _AesGcmParams(name: 'AES-GCM', iv: compartment.iv.toJS),
              key! as web.CryptoKey,
              compartment.payload.toJS,
            )
            .toDart;

        final bytes = (plain! as JSArrayBuffer).toDart.asUint8List();
        return utf8.decode(bytes);
      } catch (_) {
        // Not this one. A tag that does not check out is the normal answer
        // for every compartment but at most one, so it is not a failure —
        // only running out of compartments is.
        continue;
      }
    }
    return null;
  } catch (_) {
    return null;
  }
}
