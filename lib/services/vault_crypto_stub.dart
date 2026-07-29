import 'dart:typed_data';

/// Non-web fallback. The vault only exists in a browser, and the widget tests
/// run on the Dart VM — where there is no Web Crypto and no vault to open.
Future<String?> decryptVaultImpl({
  required String passcode,
  required Uint8List salt,
  required Uint8List iv,
  required Uint8List payload,
  required int iterations,
}) async =>
    null;
