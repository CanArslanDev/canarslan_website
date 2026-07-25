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

The [approved prototype](https://claude.ai/code/artifact/1b5d8000-969d-4fa0-b592-0c32b7f53c1d)
is the HTML mockup the design was signed off from. `/design` says what the system
*is*; the prototype says what it is *supposed to look like*. If they disagree,
the prototype wins unless `DESIGN.md` records a reason.

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
    design_page/        ← the /design storybook
    home_page/  projects_page/  contact_page/  main_page/  not_found_page/
                        ← legacy, pre-redesign, not yet migrated
  controllers/  bindings/  routes/  services/  ui/   ← legacy
assets/fonts/           Clash Display, General Sans, JetBrains Mono (bundled)
test/
  design_system_test.dart   builds the storybook at three widths
  design_rules_test.dart    enforces DESIGN.md against the source
```

## Migration status

The site is mid-redesign. The design system and `/design` are done; the
visitor-facing pages have not been rebuilt on it yet.

Until they are, the old pages keep their old theme, `responsive_sizer` and
`google_fonts`. They are listed in the `legacy` allowlist in
`test/design_rules_test.dart`, which exempts them from the rules.

**That list only ever shrinks.** When you rebuild a page on SIGNAL, delete its
entry — do not add to it. New code is covered by default.

Planned order: `AppShell` and routes → home → work → packages → about → contact
→ 404. Then `responsive_sizer` and `google_fonts` come out of `pubspec.yaml`.

## Conventions

- **Web interop:** `package:web` + `dart:js_interop`. `dart:html`, `dart:js` and
  `dart:js_util` are banned everywhere, including legacy — they are removed from
  Flutter and block a Wasm build. The Wasm dry run currently passes; keep it
  that way.
- **Sizing:** read constraints via `LayoutBuilder` / `SignalBreakpoint` /
  `fluid()`. Viewport-percentage sizing (`.w`, `.h`, `.sp`) is legacy only — it
  does not react to resizing and breaks at the extremes.
- **Lints:** `very_good_analysis`, 80-column lines. `dart fix --apply` handles
  most of it.
- **Text is content, not chrome:** page copy is Turkish, code and identifiers
  are English.

## Data

Package and repository data is scraped from pub.dev's HTML through a public CORS
proxy and pulled from the GitHub API unauthenticated, then cached in
`localStorage` with no expiry. This is fragile — it breaks whenever pub.dev
changes a class name — and is scheduled to be replaced by a build-time fetch
committed as JSON. Don't build new features on the scraper.

## Assets

`assets/web/video/video_original.mp4` (12 MB) is shipped but unused; the ASCII
player only reads `video.mp4`. Both are candidates for removal or re-encoding
when the projects page is rebuilt.
