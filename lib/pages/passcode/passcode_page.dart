import 'package:canarslan_website/data/vault.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/pages/app_shell.dart';
import 'package:canarslan_website/pages/passcode/private_pages.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:canarslan_website/services/route_service.dart';
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

    // One page is the ordinary case — a page made for one person, whose link
    // and code you hand over together — so the gate steps out of the way and
    // goes straight there. It only asks which when there is a choice.
    if (opened) {
      final vault = Vault.pages;
      final coded = PrivatePages.all;
      if (vault.length == 1 && coded.isEmpty) {
        Vault.showing = vault.single;
        RouteService.go(Routes.private);
        return;
      }
      if (coded.length == 1 && vault.isEmpty) {
        RouteService.go(coded.single.path);
        return;
      }
    }

    setState(() {
      _working = false;
      _wrong = !opened;
      if (!opened) _code = '';
    });
  }

  /// Both ways in end here, and every one of them takes the focus back.
  ///
  /// Tapping a drawn key moves focus off the listener, and without this the
  /// keypad would quietly disable the keyboard the moment you used it — the
  /// two inputs have to survive being mixed, because on a desktop you might
  /// click three digits and type the rest.
  void _press(String digit) {
    _focus.requestFocus();
    if (_working || _code.length >= _length) return;
    setState(() {
      _wrong = false;
      _code += digit;
    });
    if (_code.length == _length) _submit();
  }

  void _backspace() {
    _focus.requestFocus();
    if (_working || _code.isEmpty) return;
    setState(() {
      _wrong = false;
      _code = _code.substring(0, _code.length - 1);
    });
  }

  void _clear() {
    _focus.requestFocus();
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // One width for the readout and the keypad, so they stack flush. The
        // keypad's key size decides it: three across, capped, and the readout
        // divides the same total by however many digits the code has.
        final available = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : _Keypad.maxKey * _Keypad.columns;
        final key = (available / _Keypad.columns).clamp(0.0, _Keypad.maxKey);
        final instrument = key * _Keypad.columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeading(
              eyebrow: PasscodeCopy.eyebrow.of(context),
              stamp: PasscodeCopy.stamp.of(context),
              lede: PasscodeCopy.lede.of(context),
              rule: true,
            ),
            _Readout(
              length: length,
              filled: code.length,
              wrong: wrong,
              width: instrument,
            ),
            const SizedBox(height: SignalSpace.x4),
            SignalMicro(
              working
                  ? PasscodeCopy.checking.of(context)
                  : wrong
                      ? PasscodeCopy.wrong.of(context)
                      : PasscodeCopy.hint.of(context),
            ),
            const SizedBox(height: SignalSpace.x6),
            _Keypad(
              size: key,
              onDigit: onDigit,
              onBackspace: onBackspace,
              onClear: onClear,
            ),
          ],
        );
      },
    );
  }
}

/// How many digits are in, drawn as cells rather than as text.
///
/// The same ruled block as the keypad below it and exactly as wide, so the two
/// stack into one instrument rather than sitting near each other. Separated
/// cells were the first attempt and looked like a different component.
///
/// The cursor is an accent bar inside the waiting cell rather than a border
/// around it: the borders here belong to the grid, and lighting one cell's
/// edge would light its neighbour's too.
class _Readout extends StatelessWidget {
  const _Readout({
    required this.length,
    required this.filled,
    required this.wrong,
    required this.width,
  });

  final int length;
  final int filled;
  final bool wrong;
  final double width;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final cell = width / length;

    return SizedBox(
      width: width,
      child: SignalTileGrid(
        columns: length,
        strokeColor: wrong ? palette.fg : palette.line,
        children: [
          for (var i = 0; i < length; i++)
            SizedBox(
              height: cell * 1.3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: i < filled ? 1 : 0,
                    duration: SignalMotion.state,
                    child: Container(width: 10, height: 10, color: palette.fg),
                  ),
                  if (i == filled && !wrong)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: SignalSpace.x2),
                        child: Container(
                          width: cell * 0.34,
                          height: 2,
                          color: palette.accent,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// The keypad, on the page rather than from the operating system.
///
/// A phone's own keyboard covers half the screen and takes a beat to appear;
/// a passcode is the one input where the page can do better by drawing the
/// keys itself.
///
/// One block of square keys sharing their hairlines, which is
/// [SignalTileGrid] — the same contact sheet the certificates and the packages
/// sit on. Separated keys with a radius were the wrong instinct: they made the
/// only circles on the site, and a scatter of loose objects says nothing,
/// where a ruled block is the architecture. Hover and press change the fill
/// rather than the border, because the borders belong to the grid and not to
/// any one key.
///
/// Three across on every screen — a keypad that reflowed to four on a wide
/// window would stop being a keypad — and as tall as it is wide, up to a size
/// that suits a thumb in portrait without becoming a wall on a desktop.
class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.size,
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
  });

  static const columns = 3;
  static const maxKey = 96.0;

  /// Side of one key, decided by [_Gate] so the readout can match it.
  final double size;

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    Widget digit(String value) =>
        _Key(label: value, size: size, onTap: () => onDigit(value));

    return SizedBox(
      width: size * columns,
      child: SignalTileGrid(
        columns: columns,
        children: [
          for (final value in ['1', '2', '3', '4', '5', '6', '7', '8', '9'])
            digit(value),
          _Key(label: 'C', size: size, quiet: true, onTap: onClear),
          digit('0'),
          // The site writes arrows in ASCII everywhere else, so the delete key
          // does too rather than reaching for a glyph the bundled mono face
          // may not carry.
          _Key(label: '<-', size: size, quiet: true, onTap: onBackspace),
        ],
      ),
    );
  }
}

class _Key extends StatefulWidget {
  const _Key({
    required this.label,
    required this.size,
    required this.onTap,
    this.quiet = false,
  });

  final String label;
  final double size;
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
            height: widget.size,
            alignment: Alignment.center,
            color: _down
                ? palette.recess
                : (lit ? palette.surface : SignalPalette.transparent),
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

/// Shown only when the vault holds more than one page: the gate has to ask
/// which, because it cannot guess. With a single page nobody reaches this.
class _VaultIndex extends StatelessWidget {
  const _VaultIndex({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final vault = Vault.pages;
    final coded = PrivatePages.all;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeading(
          eyebrow: PasscodeCopy.openEyebrow.of(context),
          stamp: PasscodeCopy.stamp.of(context),
        ),
        if (vault.isEmpty && coded.isEmpty)
          SignalMicro(PasscodeCopy.empty.of(context))
        else
          SignalDataRows(
            children: [
              for (final page in vault)
                SignalDataRow(
                  name: page.title,
                  description: '',
                  meta: const [],
                  onTap: () {
                    Vault.showing = page;
                    RouteService.go(Routes.private);
                  },
                ),
              for (final page in coded)
                SignalDataRow(
                  name: page.title,
                  description: '',
                  meta: const [],
                  onTap: () => RouteService.go(page.path),
                ),
            ],
          ),
        const SizedBox(height: SignalSpace.x12),
        SignalPillButton(
          label: PasscodeCopy.lock.of(context),
          onPressed: onClose,
        ),
      ],
    );
  }
}
