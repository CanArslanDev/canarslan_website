import 'package:canarslan_website/services/javascript_service.dart';
import 'package:canarslan_website/services/storage_service.dart';
import 'package:flutter/widgets.dart';

/// The two languages the site speaks.
///
/// English is the default and the fallback. That is a decision rather than a
/// guess: the browser's `navigator.language` is deliberately not consulted,
/// because a visitor arriving from anywhere should meet the same site, and the
/// one who wants Turkish says so once and is remembered.
enum SiteLocale {
  en('EN', 'en'),
  tr('TR', 'tr');

  const SiteLocale(this.label, this.tag);

  /// What the switch in the nav bar reads.
  final String label;

  /// BCP 47, written onto `<html lang>`.
  final String tag;

  static SiteLocale? byTag(String? tag) {
    for (final locale in values) {
      if (locale.tag == tag) return locale;
    }
    return null;
  }
}

/// Holds the chosen language and hands it down the tree.
///
/// Sits above the router, so a page swap keeps the choice. Propagation is an
/// [InheritedWidget] rather than a rebuild of the whole app: the widgets that
/// rebuild are exactly the ones that read a string, and nothing that does not.
class SiteLocaleScope extends StatefulWidget {
  const SiteLocaleScope({required this.child, super.key});

  final Widget child;

  /// The language in force, registering the caller as a dependent.
  ///
  /// Falls back to English when there is no scope above — which is what a
  /// widget test that pumps a bare page gets, and the right answer for it.
  static SiteLocale of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SiteLocaleModel>()?.locale ??
      SiteLocale.en;

  /// Throws the switch, without subscribing the caller to the result.
  static void select(BuildContext context, SiteLocale locale) =>
      context.findAncestorStateOfType<_SiteLocaleScopeState>()?.select(locale);

  @override
  State<SiteLocaleScope> createState() => _SiteLocaleScopeState();
}

class _SiteLocaleScopeState extends State<SiteLocaleScope> {
  late SiteLocale _locale =
      SiteLocale.byTag(StorageService.loadLocale) ?? SiteLocale.en;

  @override
  void initState() {
    super.initState();
    // After the first frame, not during initState: the engine writes the
    // platform locale onto `<html lang>` while it boots, and a value set
    // before that is simply overwritten.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => JavascriptService.setDocumentLanguage(_locale.tag),
    );
  }

  void select(SiteLocale locale) {
    if (locale == _locale) return;
    setState(() => _locale = locale);
    StorageService.saveLocale(locale.tag);
    JavascriptService.setDocumentLanguage(locale.tag);
  }

  @override
  Widget build(BuildContext context) =>
      _SiteLocaleModel(locale: _locale, child: widget.child);
}

class _SiteLocaleModel extends InheritedWidget {
  const _SiteLocaleModel({required this.locale, required super.child});

  final SiteLocale locale;

  @override
  bool updateShouldNotify(_SiteLocaleModel old) => old.locale != locale;
}

extension SiteLocaleContext on BuildContext {
  /// The language in force at this point in the tree — the copy equivalent of
  /// `context.signal`.
  SiteLocale get locale => SiteLocaleScope.of(this);
}
