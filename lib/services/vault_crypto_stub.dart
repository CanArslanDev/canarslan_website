import 'dart:typed_data';

import 'package:canarslan_website/services/vault_compartment.dart';

/// Non-web fallback. The vault only exists in a browser, and the widget tests
/// run on the Dart VM — where there is no Web Crypto and no vault to open.
Future<String?> decryptVaultImpl({
  required String passcode,
  required Uint8List salt,
  required int iterations,
  required List<VaultCompartment> compartments,
}) async =>
    null;
