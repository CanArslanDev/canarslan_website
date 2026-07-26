# canarslan-website

Personal site of Can Arslan — [canarslan.me](https://canarslan.me). Flutter,
web only.

## Read this first

**All visual work follows [`DESIGN.md`](DESIGN.md).** It is not a style
suggestion; `test/design_rules_test.dart` reads the source and fails the build
when code steps outside it. Before writing any widget, know these three:

1. **Hairlines are the architecture** — no shadows, no gradients, no elevation.
2. **Radius has two legal values** — `0` for structural, full pill for
   interactive. Nothing between.
3. **One accent, rationed** — at most three appearances per page.

Colours come from `context.signal`. Type comes from a `SignalType` role. Never
from a literal.

## Commands

```bash
flutter analyze                 # must be clean
flutter test                    # design system + design rules; must be green
flutter build web --release
flutter run -d chrome
```

## The two references

`/design` is a hidden route rendering the whole system from live code. It is not
linked from the navigation and is meant to stay that way — it is how the design
gets reviewed. Keep it current: **a component that is not in the storybook does
not exist.**

`docs/signal-prototype.html` is the mockup the design was signed off from —
a self-contained HTML file, versioned with the code, openable straight from the
repo with no server. `/design` says what the system *is*; the prototype says
what it is *supposed to look like*. If they disagree, the prototype wins unless
`DESIGN.md` records a reason.

This has already mattered once: the ASCII field was "improved" away from the
prototype's parameters and had to be reverted. Match it, don't tune it.

## Verification, and one trap

Release builds strip `assert`. That hides exactly the failures this codebase is
prone to — a `Container` given both a colour and a decoration, a `Row`
overflowing, a box asked for an infinite width. A release build looking fine
proves very little.

**`flutter test` is the real check.** The widget tests build the storybook at
desktop, tablet and phone widths with assertions on, and have already caught
several bugs a release build rendered without complaint. Run them before
claiming anything works.

**Portrait is part of done.** Every screen gets looked at on a phone — not just
built at 390px, looked at. A box wider than the screen raises no exception, so
green tests are necessary and not sufficient. One test walks the render tree at
390 × 844 and fails on anything spilling off the edge; that catches the silent
class of bug, but only a screenshot tells you whether the page reads. The rules
are in `DESIGN.md` § Portrait — the short version is: no fixed widths on layout
containers, use `SignalTileGrid`.

Tests run on the Dart VM, which is why `JavascriptService` uses a conditional
import — keep web-only APIs behind that pattern so the widget tree stays
testable.

## Layout

```
lib/
  design/               ← the SIGNAL design system. Start here.
    signal.dart           barrel — import this
    tokens/               colours, type, spacing, radius, motion, breakpoints
    theme/                ThemeExtension + ThemeData
    components/           the component library
  pages/
    app_shell.dart        nav + scrolling body + footer; every page uses it
    home/ work/ packages/ about/ contact/ not_found/
    design_page/        ← the /design storybook
    widgets/              RepoList and PackageGrid, shared between pages
  data/                   typed models + the cached SiteRepository
  i18n/                 ← every string the site says, in both languages
  routes/                 route table; Routes.navigation drives the nav bar
  services/               pub.dev, GitHub, storage, navigation
assets/fonts/           Clash Display, General Sans, JetBrains Mono (bundled)
test/
  pages_test.dart           every page at three widths, plus a portrait check
  design_system_test.dart   the storybook at three widths
  design_rules_test.dart    enforces DESIGN.md against the source
```

## Routing

Each section is a real route, not an anchor: `/`, `/work`, `/packages`,
`/about`, `/contact`, plus `/design` and a 404. Tapping a nav item changes the
route; the page starts at the top with its own data and its own URL.

`Routes.navigation` is the single list the nav bar renders from — add a route
there and the bar picks it up. `RouteService.go` replaces rather than pushes,
because top-level sections are siblings; back should leave the site, not walk a
pile of visited tabs. Deep links work through `RouteService.initialRoute`, and
an unknown path lands on the 404 page rather than silently redirecting.

Route changes carry **no transition** (`Transition.noTransition`,
`Duration.zero` on the `GetMaterialApp`). Each page builds its own nav bar and
footer, so an animated swap slides the whole frame — chrome included — across
the window. See `DESIGN.md` § Motion.

## Migration status

Done. Every page runs on the design system, the pre-redesign tree is deleted,
and the `legacy` allowlist in `test/design_rules_test.dart` is empty — meaning
every rule in `DESIGN.md` applies to every file with no exemptions. Keep it
that way: the list exists to be deleted from, not added to.

## Conventions

- **Web interop:** `package:web` + `dart:js_interop`. `dart:html`, `dart:js` and
  `dart:js_util` are banned everywhere — they are removed from Flutter and block
  a Wasm build. Keep it that way; see § Wasm below for why the door is worth
  holding open even though it is currently shut.
- **Sizing:** read constraints via `LayoutBuilder` / `SignalBreakpoint` /
  `fluid()`. Viewport-percentage sizing (`.w`, `.h`, `.sp`) is legacy only — it
  does not react to resizing and breaks at the extremes.
- **Lints:** `very_good_analysis`, 80-column lines. `dart fix --apply` handles
  most of it.
- **Text is content, not chrome:** code and identifiers are English; page copy
  is whatever `lib/i18n/site_copy.dart` says in the language in force.

## Wasm

`flutter build web --release --wasm` compiles, boots, and then **traps**:
`memory access out of bounds`, one per frame, on a blank page.

It is not the app's code. Measured by elimination: disable the ASCII field's
paint and the same build renders every page perfectly with no errors at all.
The trap is skwasm's `drawAtlas` / `drawRawAtlas` — baking the atlas with
`Picture.toImage` is fine, drawing it is not.

Worth retrying after an engine upgrade. Measured over the wire in Chrome, the
wasm build fetches **3.45 MB** against the default's **4.14 MB** — a real but
modest saving, most of it skwasm being smaller than CanvasKit, offset by
`main.dart.wasm` and `main.dart.js` both shipping. The larger prize is WasmGC's
execution speed, not the bytes.

Note the download is 4.14 MB, not the 41 MB the build directory weighs.
Chrome fetches the `chromium/` CanvasKit variant (1.6 MB) and one renderer, and
`assets/NOTICES` is never requested. Do not size this site from `du`.

Until `drawAtlas` works under skwasm, ship `flutter build web --release`.

## Language

The site is bilingual. **English is the default** — the browser's
`navigator.language` is deliberately not consulted — and the visitor switches
from the nav bar, which writes the choice to `localStorage` and onto
`<html lang>`.

Every string lives in `lib/i18n/site_copy.dart` as a `Copy(en, tr)` pair, and
pages resolve it with `.of(context)`. **Adding a string means writing both
languages**; there is no fallback and no key lookup, so the compiler catches a
missing side. Design-system components never see a `Copy` — they take plain
`String`s. The full rules, including why the switch is not a pill, are in
`DESIGN.md` § Language.

Anything that comes from an API — a repository's language, a package's platform
tags — stays as it arrives. The one exception is a package's publish date,
which is stored as a `DateTime` and phrased at render time: the data is cached
for the session and the language is not, so a baked "2 months ago" would be
stuck in whichever language happened to be showing when it was fetched.

## Data

Two public JSON APIs, both read straight from the browser:

- **pub.dev** — `/api/packages/<name>` and `/api/packages/<name>/score`. Both
  send `Access-Control-Allow-Origin: *`. The publisher's *list* of packages
  cannot be fetched this way (the search endpoint sends no CORS header), so the
  names live in `PackageConstants.published`. **Publishing a new package means
  adding one line there.**
- **GitHub** — `/users/<name>/repos`, unauthenticated and therefore rate-limited
  per IP, cached in `localStorage` for six hours.
- **Contributions** — `github-contributions-api.jogruber.de/v4/<name>`, which
  returns the calendar as JSON and allows cross-origin requests. GitHub's own
  `/users/<name>/contributions` fragment does not, which is why the chart used
  to need a proxy and went blank when that proxy fell over. The calendar is
  drawn here (`ContributionCalendar`) rather than by a package, so it uses the
  accent ramp instead of GitHub green.

All three loaders swallow failure and return an empty result; a page that cannot
fetch shows a quiet line rather than an error state.

**Reads are cache-first.** `ResponseCache` keeps each reduced response in
`localStorage` under a timestamp for six hours, and a fresh entry is returned
without a request at all. This matters most for pub.dev: seven packages at two
endpoints each is fourteen round trips before the grid can draw. GitHub's loader
used to read its cache and then make the request anyway, falling back only on
failure — the cache saved a rate-limited visitor but never saved anyone any
time. Once the network has failed, a stale entry is served at any age, because
this morning's list beats an empty section.

What is stored is the handful of fields the page shows, not the raw body: it
keeps the entries small, and a change to an endpoint's payload cannot
half-parse an old one.

This replaced scraping pub.dev's HTML through a public CORS proxy, which broke:
the proxy now answers 522 after twenty seconds. If you find yourself reaching
for a proxy or an HTML parser again, check for a JSON endpoint with CORS first.
