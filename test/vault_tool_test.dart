import 'dart:io';

import 'package:canarslan_website/pages/passcode/passcode_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the vault tool seals codes of the length the gate takes', () {
    // Two languages, one number. If they drift, the tool writes a vault the
    // keypad can never open — and nothing else would notice until someone
    // stood at the door.
    final source = File('tool/vault.js').readAsStringSync();
    final match = RegExp(r'const LENGTH = (\d+);').firstMatch(source);

    expect(match, isNotNull, reason: 'tool/vault.js declares LENGTH');
    expect(int.parse(match!.group(1)!), PasscodePage.length);
  });
}
