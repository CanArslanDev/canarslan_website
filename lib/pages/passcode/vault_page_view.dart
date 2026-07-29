import 'dart:convert';

import 'package:canarslan_website/data/vault.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/pages/not_found/not_found_page.dart';
import 'package:flutter/material.dart';

/// Draws a page that came out of the vault.
///
/// Nothing here names anything. The widget knows how to render a heading, a
/// paragraph, a rule, a readout and a photograph, and which of those to draw
/// in what order — with what words and what pictures — arrives encrypted. A
/// reader of `main.dart.js` learns that this site can draw those five things
/// and not one word of any page that uses them.
///
/// That is the whole trade: pages are composed from a vocabulary rather than
/// written as Dart. A page that needs its own animation wants
/// `PrivatePages` instead, and pays for it by shipping its content in the
/// clear.
class VaultPageView extends StatelessWidget {
  const VaultPageView({required this.page, super.key});

  final VaultPage page;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    return Scaffold(
      backgroundColor: palette.canvas,
      body: Stack(
        children: [
          if (page.field != null)
            Positioned.fill(
              child: IgnorePointer(
                child: SignalAsciiField(mode: page.field!),
              ),
            ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: SignalSpace.x20),
              child: SignalColumn(
                ruled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final block in page.blocks) _Block(block: block),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.block});

  final Map<String, dynamic> block;

  String get _text => block['text']?.toString() ?? '';

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    final child = switch (block['type']?.toString()) {
      'eyebrow' => SignalEyebrow(_text),
      'heading' => SignalDisplayLine(
          _text,
          weight: block['weight'] == 'hair'
              ? SignalDisplayWeight.hair
              : SignalDisplayWeight.mass,
          section: block['section'] == true,
        ),
      'stamp' => SignalStamp(_text),
      'text' => ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: SignalSpace.measure),
          child: Text(_text, style: SignalType.lede(palette.muted)),
        ),
      'rule' => const SizedBox(width: 260, child: SignalDrawnRule()),
      'spec' => SignalSpecStrip(
          entries: [
            for (final entry in block['entries'] as List? ?? const [])
              SignalSpecEntry(
                label: (entry as List)[0].toString(),
                value: entry[1].toString(),
              ),
          ],
        ),
      'image' => _Photo(data: block['data']?.toString()),
      'gallery' => SignalTileGrid(
          minTileWidth: 220,
          children: [
            for (final image in block['images'] as List? ?? const [])
              _Photo(data: image.toString()),
          ],
        ),
      'gap' => SizedBox(height: (block['size'] as num?)?.toDouble() ?? 0),
      _ => const SizedBox.shrink(),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: SignalSpace.x4),
      child: child,
    );
  }
}

/// A photograph that was inside the ciphertext.
///
/// Decoded straight from the vault rather than fetched, because a file in
/// `web/` would be served to anyone who guessed its name — which is the one
/// thing this whole arrangement is trying to avoid.
class _Photo extends StatelessWidget {
  const _Photo({required this.data});

  final String? data;

  @override
  Widget build(BuildContext context) {
    final encoded = data;
    if (encoded == null || encoded.isEmpty) return const SizedBox.shrink();

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.signal.line),
        borderRadius: SignalRadius.structural,
      ),
      child: Image.memory(base64Decode(encoded), fit: BoxFit.cover),
    );
  }
}

/// The one route every private page is shown at.
///
/// Guarded like the code-backed ones: without an open vault it is the 404
/// page, so the address gives nothing away to someone who tries it.
class PrivateRoute extends StatelessWidget {
  const PrivateRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final page = Vault.isOpen ? Vault.showing : null;
    if (page == null) return const NotFoundPage();
    return VaultPageView(page: page);
  }
}
