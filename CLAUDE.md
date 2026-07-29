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
    home/ projects/ packages/ about/ contact/ not_found/
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

## Composition

Four rules, each of them written down because the codebase broke them first.

**One widget per thing, even when it appears twice.** Everything on the home
page is an excerpt of a page that exists in full elsewhere, and every time the
two were built separately they drifted: the repository rows aligned differently
in portrait on one but not the other, the paper band ran at a different opacity
from `/about`, the package grid trimmed to a count on one and to rows on the
other. `RepoList`, `PackageGrid`, `AboutBio`, `CredentialGrid` and `SiteData`
all exist for this reason. **If the home page shows it, the page shows it
through the same widget.**

**A value that every caller passes differently belongs to the type.** The ASCII
field took a `fieldOpacity` and thirteen sections had drifted to nine values;
the paragraph measure was `560` in three files. Both are now a single
declaration — `SignalFieldMode.strength`, `SignalSpace.measure` — and the
parameter that allowed the drift is gone. A knob nobody sets consistently is
not a feature.

**Nullable fields that are only valid in combination want named constructors.**
`SignalSpecEntry` took a required label beside an optional child and rendered
the child *instead*, so the contact page passed "Local time" and the strip threw
it away with no error and no visible effect. It is now
`SignalSpecEntry(label:, value:)` or `SignalSpecEntry.live(widget)`, and the
dead copy string went with it. **If an argument can be silently ignored, the
type is wrong.**

**A literal that repeats a constant is a bug waiting for one of them to
change.** `github.com/CanArslanDev` was hard-coded in three places next to
`StringConstants.github`, and `canarslan.me` in four with no constant at all.
Grep for a value before typing it.

Extraction is not free, so the bar is real duplication or a real trap, not
symmetry. `_HeroSpec` keeps its own `FutureBuilder` because it renders a
placeholder value rather than a placeholder widget, and forcing it into
`SiteData` would have meant a flag that exists for one caller.

## Routing

Each section is a real route, not an anchor: `/`, `/projects`, `/packages`,
`/about`, `/contact`, plus `/design` and a 404. Tapping a nav item changes the
route; the page starts at the top with its own data and its own URL.

`Routes.navigation` is the single list the nav bar renders from — add a route
there and the bar picks it up. `RouteService.go` replaces rather than pushes,
because top-level sections are siblings; back should leave the site, not walk a
pile of visited tabs. Deep links work through `RouteService.initialRoute`, and
an unknown path lands on the 404 page rather than silently redirecting — with
one exception, `Routes.moved`: `/work` was the projects section before it was
renamed, and a link someone already shared should not break for a rename of
ours.

The bar shows the links only from `expanded` (≥1100) up. Below that its action
becomes a menu toggle and `SignalNavPanel` takes the body's place with all five
routes — so every route is reachable at every width. `test/pages_test.dart`
asserts that at phone and tablet size rather than trusting it.

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

## Shipping

`flutter build web --release` copies everything in `web/` into `build/web/`
verbatim, so that folder is where anything the browser or a crawler needs to
see lives. **Never edit `build/web/index.html`** — it is overwritten every
build.

Four files there exist only for the deploy:

| File | Why |
|---|---|
| `CNAME` | The custom domain. GitHub writes one when you set the domain, and a deploy that replaces the branch wipes it; keeping it in `web/` means every build puts it back. |
| `.nojekyll` | Skips GitHub Pages' Jekyll pass. Nothing Flutter emits starts with `_` today, so it is insurance rather than a fix — and it makes the deploy quicker. |
| `og.png` | The link preview, 1200 × 630. |
| `404.html` | The SPA fallback for deep links, which GitHub Pages needs because it only serves real files. |

### The link preview

Every crawler that builds a preview — X, LinkedIn, WhatsApp, Slack, Discord —
reads the served markup and **none of them run Flutter**. Anything the app sets
at runtime is invisible to them, so the tags have to be static in
`web/index.html`. The consequence is one card for the whole site: every route
is served the same file. Per-route cards would mean generating a folder with
its own `index.html` per route.

`web/og.png` is generated by `tool/og_card.py`, which builds the card from the
palette in `signal_colors.dart`, the fonts in `assets/fonts/` and the same
vortex function `SignalAsciiField` paints — frozen at one instant. It is the
hero, not a picture of one. Run it and screenshot the result at exactly
1200 × 630, device pixel ratio 1:

```bash
python3 tool/og_card.py          # writes build/og_card.html
# screenshot it headless at 1200x630 → web/og.png
```

Regenerate it when the hero's copy or the palette changes. Crawlers cache
previews hard, so **change the filename too** (`og-2.png`) — re-scraping
through their debuggers works but is slower to take.

## The passcode gate

`/passcode` is a door. Like `/design` it is absent from `Routes.navigation`;
unlike `/design` it is meant to be reached by someone who was told the address.
Entering the code goes **straight to the private page** — hand someone a link
and a code and that is all they do.

**Nothing private is in this repository.** The pages are real Flutter routes
whose source lives in `lib/private/`, and they are registered by a second
entrypoint, `lib/main_private.dart`. Both are gitignored, and so is
`private/`, where the vault's plaintext sits.

```dart
// lib/main_private.dart — not committed
import 'package:canarslan_website/main.dart' as app;
import 'package:canarslan_website/pages/passcode/private_pages.dart';
import 'package:canarslan_website/private/some_page.dart';

void main() {
  PrivatePages.register([
    PrivatePage(path: '/somewhere', title: 'Somewhere',
        build: (_) => const SomePage()),
  ]);
  app.main();
}
```

```bash
node tool/vault.js private/vault.json <passcode>   # writes web/vault.json
flutter build web --release -t lib/main_private.dart
```

A second entrypoint rather than a committed stub someone keeps in sync, or a
tracked file carrying local edits that git eventually picks up. `lib/main.dart`
is untouched, still builds and still passes its tests; it registers nothing, so
a fresh clone opens the door onto an empty room and nothing is broken.

Private routes are appended to the router from the registry, so no private path
appears in `Routes` either. Each one is guarded: without an open vault it
renders the 404 page, so typing the address gets you nothing that confirms it
exists.

### The lock

`web/vault.json` is one AES-256-GCM blob under a PBKDF2-SHA256 key at 600,000
iterations. Unlocking *is* decryption succeeding — there is no passcode in the
bundle to compare against, because there is nothing to compare. Whatever JSON
you encrypt comes back as `Vault.data`, which is where a private page should
read anything that must not ship in the clear: a name, a date, a list of URLs.

The browser side is Web Crypto through `dart:js_interop`, so there is no new
dependency and the derivation runs native; the tool side is Node's own
`crypto`, so there is nothing to install. Node keeps the GCM tag separate and
Web Crypto expects it appended — `tool/vault.js` concatenates it, which is the
one place the two APIs disagree.

**What this is worth.** Two different things, and they are not equally
protected. `Vault.data` is ciphertext until the code opens it. A private
*page* is compiled into `main.dart.js`, so the passcode is a curtain in front
of it rather than a lock on it — someone reading the bundle can work out what
it draws. Both are absent from this repository, which is the part that was
asked for; only the first is genuinely unreadable.

And the blob is served to anyone who asks, so they can take it away and try
codes against it offline. Six digits is a million attempts and a short
afternoon for a GPU; the iteration count buys time and nothing more. A longer
code is worth more than any tuning here — the length is one constant in
`passcode_page.dart`, and the readout and keypad size themselves from it.

Nothing decrypted is written to storage and the passcode is never stored, so
closing the tab locks the door again.

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
