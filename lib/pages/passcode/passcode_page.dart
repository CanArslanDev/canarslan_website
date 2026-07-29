import 'package:canarslan_website/data/vault.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/pages/app_shell.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The door in front of the private pages.
///
/// Not linked from anywhere, like `/design` — but unlike the storybook this one
/// is meant to be reached by someone who was told the address. It says nothing
/// about what is behind it, and a wrong code, a missing vault and a corrupt one
/// all produce the same answer.
class PasscodePage extends StatefulWidget {
  const PasscodePage({super.key});

  @override
  State<PasscodePage> createState() => _PasscodePageState();
}

class _PasscodePageState extends State<PasscodePage> {
  /// Raise this and re-run the tool with a longer code; the readout and the
  /// keypad both size themselves from it. Six digits is a million
  /// combinations, which is the weakest part of the whole arrangement — see
  /// [Vault].
  static const _length = 6;

  final _focus = FocusNode();

  String _code = '';
  bool _working = false;
  bool _wrong = false;

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _working = true;
      _wrong = false;
    });

    final opened = await Vault.unlock(_code);
    if (!mounted) return;

    setState(() {
      _working = false;
      _wrong = !opened;
      if (!opened) _code = '';
    });
  }

  void _press(String digit) {
    if (_working || _code.length >= _length) return;
    setState(() {
      _wrong = false;
      _code += digit;
    });
    if (_code.length == _length) _submit();
  }

  void _backspace() {
    if (_working || _code.isEmpty) return;
    setState(() {
      _wrong = false;
      _code = _code.substring(0, _code.length - 1);
    });
  }

  void _clear() {
    if (_working || _code.isEmpty) return;
    setState(() {
      _wrong = false;
      _code = '';
    });
  }

  /// A physical keyboard still works, because on a desktop it is the faster
  /// way in and there is no reason to make someone reach for the mouse.
  void _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final label = event.logicalKey.keyLabel;
    if (label.length == 1 && '0123456789'.contains(label)) {
      _press(label);
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.backspace) _backspace();
    if (event.logicalKey == LogicalKeyboardKey.escape) _clear();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: Routes.passcode,
      slivers: [
        SignalSection(
          field: SignalFieldMode.scan,
          child: Vault.isOpen
              ? _VaultIndex(onClose: () => setState(Vault.close))
              : KeyboardListener(
                  focusNode: _focus,
                  autofocus: true,
                  onKeyEvent: _onKey,
                  child: _Gate(
                    length: _length,
                    code: _code,
                    working: _working,
                    wrong: _wrong,
                    onDigit: _press,
                    onBackspace: _backspace,
                    onClear: _clear,
                  ),
                ),
        ).asSliver,
      ],
    );
  }
}

class _Gate extends StatelessWidget {
  const _Gate({
    required this.length,
    required this.code,
    required this.working,
    required this.wrong,
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
  });

  final int length;
  final String code;
  final bool working;
  final bool wrong;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeading(
          eyebrow: PasscodeCopy.eyebrow.of(context),
          stamp: PasscodeCopy.stamp.of(context),
          lede: PasscodeCopy.lede.of(context),
          rule: true,
        ),
        _Readout(length: length, filled: code.length, wrong: wrong),
        const SizedBox(height: SignalSpace.x4),
        SignalMicro(
          working
              ? PasscodeCopy.checking.of(context)
              : wrong
                  ? PasscodeCopy.wrong.of(context)
                  : PasscodeCopy.hint.of(context),
        ),
        const SizedBox(height: SignalSpace.x8),
        _Keypad(
          onDigit: onDigit,
          onBackspace: onBackspace,
          onClear: onClear,
        ),
      ],
    );
  }
}

/// How many digits are in, drawn as cells rather than as text.
///
/// Structural, so square: this is a readout, not a control. The cells size
/// themselves from the width they are given, because six at a fixed 52px plus
/// their gaps is wider than a 390px phone's column and would wrap to a second
/// row.
class _Readout extends StatelessWidget {
  const _Readout({
    required this.length,
    required this.filled,
    required this.wrong,
  });

  static const _gap = SignalSpace.x3;
  static const _maxCell = 52.0;

  final int length;
  final int filled;
  final bool wrong;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : _maxCell * length;
        final cell = ((available - _gap * (length - 1)) / length)
            .clamp(0.0, _maxCell);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < length; i++) ...[
              if (i > 0) const SizedBox(width: _gap),
              AnimatedContainer(
                duration: SignalMotion.state,
                curve: SignalMotion.linearish,
                width: cell,
                height: cell * 1.24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: palette.surface,
                  border: Border.all(
                    // The one accent on this page: the cell waiting for the
                    // next digit.
                    color: i == filled && !wrong
                        ? palette.accent
                        : (wrong ? palette.fg : palette.line),
                  ),
                  borderRadius: SignalRadius.structural,
                ),
                child: AnimatedOpacity(
                  opacity: i < filled ? 1 : 0,
                  duration: SignalMotion.state,
                  child: Container(width: 10, height: 10, color: palette.fg),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// The keypad, on the page rather than from the operating system.
///
/// A phone's own keyboard covers half the screen and takes a beat to appear;
/// a passcode is the one input where the page can do better by drawing the
/// keys itself. The keys are round because the system says interactive things
/// are pills, and a pill at equal width and height is a circle — which is also
/// what a keypad has always looked like.
///
/// Three columns, sized from the available width, so the whole thing grows to
/// meet a thumb in portrait and stops at a sensible size on a desktop.
class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
  });

  static const _columns = 3;
  static const _gap = SignalSpace.x3;
  static const _maxKey = 92.0;

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : _maxKey * _columns;
        final key = ((available - _gap * (_columns - 1)) / _columns)
            .clamp(0.0, _maxKey);

        Widget row(List<Widget> keys) => Padding(
              padding: const EdgeInsets.only(bottom: _gap),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < keys.length; i++) ...[
                    if (i > 0) const SizedBox(width: _gap),
                    SizedBox(width: key, height: key, child: keys[i]),
                  ],
                ],
              ),
            );

        Widget digit(String value) =>
            _Key(label: value, onTap: () => onDigit(value));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            row([digit('1'), digit('2'), digit('3')]),
            row([digit('4'), digit('5'), digit('6')]),
            row([digit('7'), digit('8'), digit('9')]),
            row([
              _Key(label: 'C', quiet: true, onTap: onClear),
              digit('0'),
              // The site writes arrows in ASCII everywhere else, so the
              // delete key does too rather than reaching for a glyph the
              // bundled mono face may not carry.
              _Key(label: '<-', quiet: true, onTap: onBackspace),
            ]),
          ],
        );
      },
    );
  }
}

class _Key extends StatefulWidget {
  const _Key({
    required this.label,
    required this.onTap,
    this.quiet = false,
  });

  final String label;
  final VoidCallback onTap;

  /// Clear and delete: they do something to the code rather than adding to it,
  /// so they read a step back.
  final bool quiet;

  @override
  State<_Key> createState() => _KeyState();
}

class _KeyState extends State<_Key> {
  bool _hovered = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final lit = _hovered || _down;

    return Semantics(
      button: true,
      label: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _down = true),
          onTapUp: (_) => setState(() => _down = false),
          onTapCancel: () => setState(() => _down = false),
          child: AnimatedContainer(
            duration: SignalMotion.state,
            curve: SignalMotion.linearish,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _down ? palette.recess : palette.surface,
              border: Border.all(color: lit ? palette.fg : palette.lineHi),
              borderRadius: SignalRadius.interactive,
            ),
            child: Text(
              widget.label,
              style: SignalType.stamp(
                context.screenWidth,
                widget.quiet && !lit ? palette.muted : palette.fg,
              ).copyWith(
                fontSize: widget.label.length > 1 ? 16 : 24,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// What is behind the door, once it is open.
class _VaultIndex extends StatelessWidget {
  const _VaultIndex({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final pages = Vault.pages ?? const <VaultPage>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeading(
          eyebrow: PasscodeCopy.openEyebrow.of(context),
          stamp: PasscodeCopy.stamp.of(context),
        ),
        if (pages.isEmpty)
          SignalMicro(PasscodeCopy.empty.of(context))
        else
          for (final page in pages) ...[
            SignalLabelledBlock(
              label: page.title,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final paragraph in page.body) ...[
                    SignalLede(paragraph),
                    const SizedBox(height: SignalSpace.x3),
                  ],
                ],
              ),
            ),
            const SizedBox(height: SignalSpace.x12),
          ],
        SignalPillButton(
          label: PasscodeCopy.lock.of(context),
          onPressed: onClose,
        ),
      ],
    );
  }
}
