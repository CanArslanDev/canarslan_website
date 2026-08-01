import 'package:flutter/foundation.dart';

/// One locked compartment of the vault. A passcode opens exactly one of them.
///
/// The salt lives on the file rather than on the compartment, so the key is
/// derived **once** however many compartments there are: a code that opens
/// none still pays for one PBKDF2 run, not one per page. The salt's job is to
/// stop an attacker precomputing against this file, and one salt does that job
/// as well as ten — two different passcodes over the same salt derive two
/// unrelated keys.
///
/// Deriving per compartment instead would make the gate slower every time a
/// page is added, which is the wrong direction for something that gets a new
/// page whenever there is someone to give one to.
@immutable
class VaultCompartment {
  const VaultCompartment({required this.iv, required this.payload});

  /// Distinct per compartment. GCM only requires an IV to be unique per key
  /// and each compartment has its own key already, but a fresh one costs
  /// twelve bytes and removes the question.
  final Uint8List iv;

  /// Ciphertext with the GCM tag appended, which is the layout Web Crypto
  /// expects. `tool/vault.js` does the appending, because Node hands the tag
  /// back separately.
  final Uint8List payload;
}
