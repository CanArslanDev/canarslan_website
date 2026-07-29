import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

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

/// Decrypts the vault with a passcode, using the browser's own crypto.
///
/// Web Crypto rather than a package: PBKDF2 and AES-GCM are both native here,
/// the derivation runs at native speed — which matters, because the whole
/// point of a high iteration count is to be slow for an attacker and bearable
/// for the one person who knows the code — and the site keeps its three
/// dependencies.
///
/// Returns null on any failure. A wrong passcode is indistinguishable from a
/// corrupt file on purpose: GCM's tag check fails either way, and the gate has
/// nothing useful to say about which.
Future<String?> decryptVaultImpl({
  required String passcode,
  required Uint8List salt,
  required Uint8List iv,
  required Uint8List payload,
  required int iterations,
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

    final plain = await subtle
        .decrypt(
          _AesGcmParams(name: 'AES-GCM', iv: iv.toJS),
          key! as web.CryptoKey,
          payload.toJS,
        )
        .toDart;

    final bytes = (plain! as JSArrayBuffer).toDart.asUint8List();
    return utf8.decode(bytes);
  } catch (_) {
    return null;
  }
}
