# SIGNAL — canarslan.me design system

> A dark instrument canvas carrying editorial typography. Terminal phosphor,
> museum plaque, boarding pass.

## Where to look

Two references, and they answer different questions.

- **`/design`** — run the app and open the hidden storybook route. Every token
  and component below is rendered there from the real code, so it can never
  drift from the system it documents. **This is the source of truth for what the
  system currently is.**
- **[`docs/signal-prototype.html`](docs/signal-prototype.html)** — the HTML
  mockup this system was signed off from. Open it straight from the repo; it is
  self-contained, needs no server and no network. **This is the source of truth
  for what the system is supposed to look like.** When the Flutter build and the
  prototype disagree, the prototype wins unless there is a written reason here
  saying otherwise.
  ([Hosted copy](https://claude.ai/code/artifact/1b5d8000-969d-4fa0-b592-0c32b7f53c1d)
  — convenient to link, but the file in the repo is the one that counts.)

Both were compared side by side at 1440px during implementation; the hero,
column alignment, spec strip and ASCII field parameters match the prototype
exactly. Keep it that way.

The rules below are enforced by `test/design_rules_test.dart`. If you break one,
the build tells you which rule and where.

---

## The three laws

**1. Hairlines are the architecture.**
Structure comes from 1px lines. Not shadows, not gradients, not elevation, not
background fills. Remove the hairlines and the interface loses its identity, not
just its decoration.

**2. Radius has exactly two legal values.**
Structural things (cells, tables, inputs, images) are square. Interactive things
(buttons, chips, tabs) are full pills. There is no `8px`, no `12px`, no
`rounded-lg`. The absence of a middle value is what keeps the system from
sliding into generic product-UI.

**3. One accent, rationed.**
A single chromatic voice, at most three appearances per page: the primary action
fill, the active state, and one live-data marker. Never as decoration, never as
body text, never as a large background.

---

## Palette

Two palettes. `instrument` is the default world; `paper` exists for the single
inverted band and nothing else. Widgets never name a palette — they read
`context.signal` and get whichever one is in force.

| Token | Instrument | Paper | Role |
|---|---|---|---|
| `canvas` | `#050605` | `#F2F2EC` | Page ground. Not pure black — biased a hair green so it is related to the accent rather than inherited from the framework. |
| `surface` | `#0C0D0B` | `#FBFBF6` | Cells, the frosted nav. Exactly one step off the canvas. |
| `recess` | `#131511` | `#E7E7DF` | Input wells, row hover. |
| `fg` | `#ECEFE6` | `#0D0F0B` | Primary text. Bone, not white — pure white glares on this ground. |
| `muted` | `#8A8F80` | `#5B6055` | Secondary text, eyebrows, data columns. |
| `dim` | `#5C6154` | `#8C9084` | Lowest-priority text; the resting tone of the ASCII fields. |
| `line` | `#E9F0E0` @ 16% | `#0D0F0B` @ 20% | The hairline that carries all structure. |
| `lineHi` | `#E9F0E0` @ 42% | `#0D0F0B` @ 55% | Emphasised hairline — outlines that must read first. |
| `accent` | `#C6F24E` | `#C6F24E` | The single chromatic voice. Fills and active states. |
| `accentText` | `#C6F24E` | `#5A7510` | The accent where it must carry text. On paper the raw accent only reaches 1.3:1, so it darkens. |
| `accentInk` | `#0A0C06` | `#0A0C06` | Text drawn on an accent fill. |

`SignalPalette.transparent` exists so no component ever spells out `Color(0x…)`.

**Do:** read every colour from `context.signal`.
**Don't:** use `Colors.*`, a hex literal, or the accent as a text colour on paper.

---

## Type

Three faces, bundled as assets under `assets/fonts/`. Nothing is fetched at
runtime — no `google_fonts`, no CDN.

| Face | Weights | Role |
|---|---|---|
| **Clash Display** | 200, 600, 700 | Display. Geometric skeleton, flat-cut terminals. |
| **General Sans** | 400, 500 | Everything readable. |
| **JetBrains Mono** | 400 | Eyebrows, section stamps, data columns, ASCII fields. |

Clash Display lives **only at its two extremes** — 200 and 700. The tension
between a hairline and a mass at the same size is the signature; a middle weight
dissolves it. 600 is permitted for one thing only: project names in a work list.

Letter-spacing is specified in `em` and multiplied through by font size, because
Flutter's `letterSpacing` is in logical pixels.

### Scale

| Role | Size | Line height | Tracking | Face |
|---|---|---|---|---|
| `eyebrow` | 11 | 1.4 | +0.20em | Mono |
| `micro` | 10 | 1.4 | +0.14em | Mono |
| `caption` | 12 | 1.4 | +0.14em | Mono |
| `bodySmall` | 14 | 1.5 | 0 | General Sans |
| `body` | 16 | 1.55 | 0 | General Sans |
| `lede` | 17 | 1.5 | −0.01em | General Sans |
| `label` | 14 / 500 | 1.2 | +0.03em | General Sans |
| `stamp` | 19→42 | 0.95 | +0.20em | Mono |
| `rowName` | 24→38 | 1.0 | −0.03em | Clash 600 |
| `headingMass` / `headingHair` | 38→74 | 0.90 / 0.95 | −0.035 / −0.015em | Clash 700 / 200 |
| `displayMass` / `displayHair` | 58→168 | 0.86 / 0.92 | −0.035 / −0.015em | Clash 700 / 200 |

Ranges scale with the viewport via `fluid()` — the Dart equivalent of CSS
`clamp()`. Sizes are never a percentage of the viewport.

### Turkish in uppercase labels

The system sets eyebrows, stamps and buttons in uppercase, and Dart's
`String.toUpperCase()` is locale-independent: it maps `i` → `I`, so *Türkiye*
becomes *TÜRKIYE* with a dotless I. A Turkish-locale transform is not the fix
either — it would turn *MOBILE* into *MOBİLE* in the same mixed-language line.

**Author Turkish words already uppercase in the source** (`TÜRKİYE`,
`GELİŞTİRİCİ`). `toUpperCase()` leaves `İ` untouched, so the label survives the
transform intact. In `lib/i18n/site_copy.dart` this is generalised: any string
headed for an uppercase slot is written uppercase in *both* languages, so the
file reads as what the page shows and the trap cannot be re-entered.

### The stamp is the only H2

Sections are titled by a mono stamp: uppercase, +0.2em tracking. **The tracking
is the heading style.** There is no bold sans heading, no underline, no rule
above it. Reach for `SignalStamp`.

**Do:** use a `SignalType` role.
**Don't:** construct a `TextStyle` in a widget.

---

## Language

The site speaks English and Turkish. English is the default; the visitor
switches from the nav bar and the choice is remembered.

**Components take `String`s and know nothing about language.** `SignalStamp`
does not import copy, and no design-system file does. Pages resolve a `Copy`
at the point of use — `SectionCopy.about.of(context)` — and that call is also
what subscribes them to the switch, so the widgets that rebuild on a change are
exactly the ones showing words.

Every string lives in `lib/i18n/site_copy.dart` as a `Copy(en, tr)` pair on
adjacent lines. There is no key lookup and no missing-key fallback: a string
cannot be added or edited in one language without the other being right there,
and a typo is a compile error rather than a key echoed onto the page.

Prose uses ability forms and addresses the reader as *siz* —
*yazabilirsiniz*, not *yazın*. Buttons are the exception: a control names its
action.

Data is never translated. A repository's language, a package's platform tags, a
Harvard certificate's title and a team's name read the same in both.

The switch is `SignalLabelSwitch`, and it is deliberately **not a pill.** The
bar's accent is already spent twice — the filled action and the active link's
underline — and a third mark there would break the rationing rule. It speaks
the nav link's language instead: lit foreground against dim.

---

## Shape

```
Structural   SignalRadius.structural    0px      cells, tables, inputs, images
Interactive  SignalRadius.interactive   999px    buttons, chips, tabs, nav CTA
```

Stroke weights: `SignalStroke.hairline` (1px) everywhere; `SignalStroke.cell`
(2px) only for the museum grid in the paper band, where the heavier rule makes it
read as a contact sheet rather than a table.

---

## Space & layout

Base unit 4px. Ladder: `4 · 8 · 12 · 16 · 24 · 32 · 48 · 64 · 80 · 120 · 160`
(`SignalSpace.x1 … x40`).

- **Column:** 1280px, centred, gutters 48px (24px on phones). The column always
  takes its full width — content is left-aligned inside it, never shrink-wrapped
  and centred.
- **Section rhythm:** 120px vertical on desktop, 80px on phones.
- **Grid rules:** the column's vertical divisions are drawn as faint hairlines.
  They are not decoration — they expose the grid the page is actually built on,
  which is what makes the layout read as a technical drawing.
- **Breakpoints:** `compact` < 760 ≤ `medium` < 1100 ≤ `expanded`.

Sizing reads constraints (`LayoutBuilder`, `SignalBreakpoint`), never viewport
percentages.

---

## Portrait

**Every screen is checked on a phone before it is called done.** Not "it builds
without errors" — looked at, in portrait, scrolled end to end.

This is not an afterthought in the system, because the failure is silent. A box
wider than the screen raises no exception: `Wrap`, `Stack` and `Row`-in-a-clip
place it happily and it simply runs off the edge. Three fixed-width panels
shipped this way — fine at 1440px, broken at 390px — and every test was green.

### Rules

- **No fixed widths on layout containers.** A panel takes the width it is
  given. If you are writing `width: 380`, reach for `SignalTileGrid` instead: it
  derives its column count from the available width and drops to one column on a
  phone.
- **Fixed sizes are for graphics, not for layout** — a 64px demo swatch, a 96px
  data column, a 7px LED. Those are fine.
- **Every multi-column arrangement declares its collapse.** `SignalTileGrid`
  does it by construction; a hand-built `Row` must switch on
  `context.breakpoint`.
- **Rows of cells stack full-width when they collapse.** A `Wrap` leaves ragged
  half-rows and the hairlines stop lining up, which is worse than a plain
  stack — see the hero spec strip.
- **Gutters halve on compact** (48px → 24px), and section rhythm drops from
  120px to 80px. Both are handled by `SignalSection` and `SignalColumn`.
- **Watch the collapsed state, not just the narrow one.** Content pinned to the
  bottom of a tile with a `Spacer` loses its gap once rows size to content; give
  it a real `SizedBox` too.
- **Navigation has to survive the collapse.** Hiding a control at a breakpoint
  is only legitimate if something takes its job. The nav links fold away below
  `expanded` and for a while nothing replaced them, so a phone and a tablet
  could reach exactly one of the five routes and the site had no navigation at
  all. Below `expanded` the bar's action becomes the menu toggle and
  `SignalNavPanel` carries the routes. **A hidden control without a
  replacement is a missing feature, not a responsive decision.**
- **A stack of full-bleed rows must say so:** `crossAxisAlignment:
  CrossAxisAlignment.stretch`. A `Column` centres by default and hands its
  children loose constraints, so every row takes the width of its own content
  and sits in from the edge by a different amount. `SignalDataRow` hides this at
  desktop, where its internal `Row` fills the width regardless — it only appears
  in portrait, and only once one row in the list has more to say than the
  others.
- **Display type keeps its proportions.** `fluid()` already floors the hero at
  58px. Do not add phone-specific font sizes.

### Excerpts

A grid on a preview shows **whole rows, never a fixed number of tiles.**

The column count is derived from the width, so the caller does not know it. A
preview that trims its own list to four leaves one tile beside two empty cells
at 1440px and hides the rest of the content for good — which is exactly what
the home page's package preview did. Pass the full list and a `maxRows`; the
grid trims once it knows how many columns it has.

Lists are different: `RepoList` has no columns, so `take(4)` there is honest.

### Both languages, every time

Turkish is the longer language nearly everywhere — *Get in touch* becomes
*İletişime geçin* — so a phone that fits in English proves nothing. The nav
bar is where this bites first: adding the language switch put the bar 83px
over at 390px in English and a further 3px over in Turkish, and both were
invisible until the geometry test ran.

`test/pages_test.dart` walks every page at 390 × 844 in **both** languages.
Adding copy means adding both sides; the test is what stops one of them from
being the only one that was ever looked at.

### Enforcement

There is a mirror failure to watch for, and it is just as quiet: a box
**narrower** than its column. Nothing overflows, nothing is clipped, the element
simply sits in from the edge — so `test/pages_test.dart` also checks that every
`SignalDataRow` in a list shares one left edge and one width.

`test/design_system_test.dart` builds the storybook at 390 × 844 and walks the
render tree, failing on any box laid out wider than the screen. Content that is
deliberately oversized — the marquee track — is exempted by its clip or overflow
ancestor, so the check has no false positives to train you to ignore.

Passing that test means nothing is spilling off the edge. It does not mean the
page *reads* well. Screenshot it and look.

---

## Elevation

There is none. Depth is not part of this system.

Two exceptions, both accent glows and both already implemented:
a filled action on hover, and an active tab. Nothing else casts a shadow, and
nothing anywhere uses a gradient.

---

## Motion

Everything animated draws from one source: the ASCII character texture. Three
durations, one curve.

| Token | Value | Used for |
|---|---|---|
| `SignalMotion.state` | 120ms | hover, focus, colour swaps |
| `SignalMotion.enter` | 320ms | reveals, row slides |
| `SignalMotion.scene` | 900ms | drawn hairlines, counters |
| `SignalMotion.ease` | `cubic-bezier(.16, 1, .3, 1)` | the system curve |

### Inventory

| Effect | Where | Behaviour |
|---|---|---|
| Vortex field | Hero | Polar interference — arms turning around a centre |
| Wave field | My projects | A travelling wave, entirely in accent. The one place colour takes a surface. |
| Scan field | Quiet sections, footer | Sparse lines drifting upward |
| Ripple field | The paper band and `/about` | Rings breathing out from the centre. Slower and more ordered than the vortex, because the museum should not feel like the cockpit. |
| Scramble | Every section stamp | Characters settle out of noise on reveal |
| Glitch | Data row hover | The name scrambles for 240ms, then sets |
| Drawn rule | Section headings | An accent hairline draws in from the left |
| Reveal | Blocks | 14px up, 320ms, system curve |
| Page change | Nav | **None.** The new route is simply there. |

**Navigation is not animated.** The sections are siblings and the router
replaces rather than pushes, so there is no stack for a slide to describe — and
because every page builds its own nav bar and footer, a page transition drags
the entire frame sideways, chrome included. It read as a phone app pushing a
detail screen. What earns motion here is a section arriving as you scroll to it,
not the page arriving because you asked for it.

The ASCII fields run at **~11fps on purpose** — it reads as a terminal
refreshing rather than a smooth shader. Rendering goes through a glyph atlas
baked once for the whole app and one `drawRawAtlas` call per frame; laying out a
`TextPainter` for each of ~2000 cells would cost far more than the effect is
worth.

A page carries up to five fields at once, so the per-step cost is the thing
that matters, and four decisions keep it near zero. The clock is a **timer, not
a ticker** — a ticker asks the scheduler for a frame every vsync, and at 85ms a
step five of every six did nothing. It drives a `ValueNotifier` handed to the
painter as its `repaint`, so a step runs **`paint` and nothing else**: no
rebuild, no layout. The sprite buffers are **typed arrays reused between
frames** rather than three growable lists thrown away every 85ms. And the
layer's opacity is **multiplied into each glyph's alpha** instead of wrapping
the field in an `Opacity` — the cells tile exactly and the atlas rects clip each
glyph to its own cell, so nothing overlaps and the result is the same composite
without a full-screen `saveLayer` per field per frame.

If you touch the field, keep those four. They are why the effect is affordable.

Every animated component honours `MediaQuery.disableAnimationsOf`.

A field takes its colours from the palette it lands in, and the two grounds are
not symmetrical:

- **Resting tone.** `dim` on the dark canvas, which is one step lighter than the
  ground. Paper needs the mirror of that, one step *darker*, and `dim` there is
  a light grey sitting almost on top of the ground — the same token produces a
  field you cannot see. On paper the field rests at `fg`, held back by the
  mode's own strength.
- **Hot glyphs** are `accentText`, not `accent`. On the dark canvas the two are
  the same colour; on paper the raw accent reaches 1.3:1 against the ground and
  the highlights would disappear.

One page uses one field per band, and no page repeats a mode. That is the whole
reason `ripple` exists: the home page had already spent the other three.

Across pages a mode belongs to the surface, not to the route. Paper ripples
wherever it appears — as the home page's band and as the whole of `/about` —
and the accent wave runs behind a repository list on both `/projects` and its
preview.

**Strength belongs to the mode too, and a band cannot override it.** There is
no `fieldOpacity` parameter, on purpose. When there was one, thirteen call sites
had drifted to nine different values: the paper band sat at 0.55 against the
About page's 0.32, the wave at 0.42 behind four rows and 0.16 behind the full
list, and `scan` had picked a different number in each of the five places it
appeared. Every one of those was somebody compensating for section height by
eye, and the result was that the same texture read as a different texture
depending on which page you were on.

| Mode | Strength |
|---|---|
| `vortex` | 0.62 |
| `wave` | 0.22 |
| `scan` | 0.30 |
| `ripple` | 0.32 |

`vortex` and `scan` keep the values the prototype was signed off at. `ripple`
takes the About page's. `wave` is the one that had to move to a value neither
place used: 0.42 buries the descriptions on a full repository list, and 0.16
leaves nothing of the one section where colour is supposed to take a surface.
Both were checked at 1440px before the number was picked.

---

## Components

Import the barrel: `package:canarslan_website/design/signal.dart`.

| Component | Notes |
|---|---|
| `SignalSection` | Full-bleed band, closed by a hairline, optional ASCII field behind it |
| `SignalColumn` | The 1280 column with its grid rules |
| `SignalCell` | Square, hairline-bordered container. Not a card: no radius, no shadow. |
| `SignalTileGrid` | Equal-width tiles on shared rules. Column count comes from the available width, so it collapses to one on a phone. **Use this instead of a `Wrap` of fixed-width panels.** A preview passes `maxRows` and the full list; see § Excerpts. |
| `SignalInversion` | Swaps the palette for its subtree — the museum band |
| `SignalMuseumGrid` | The same grid in 2px ink, for the paper band |
| `SignalNavBar` | Frosted bar, hairline underneath, links from `expanded` up. The wordmark is the flexible child — on a very narrow screen it is what gives, never the row. Below `expanded` the action becomes the menu toggle. |
| `SignalNavPanel` | The routes, once the bar cannot hold them. Takes the body's place rather than floating over it — this system has no elevation. |
| `SignalLabelSwitch` | `EN / TR`. Mono labels, lit against dim, no pill and no accent — see § Language |
| `SignalPillButton` | `filled` + `ghost`. They are designed to appear as a pair. |
| `SignalChip`, `SignalTabs` | Pill controls; the active tab carries the accent glow |
| `SignalEyebrow`, `SignalStamp`, `SignalLede`, `SignalMicro` | The text roles |
| `SignalDisplayLine` | One display line; `mass` or `hair`, hero or section scale |
| `SignalDataRow` | A project as a wireframe row, not a card |
| `SignalSpecStrip` | The wireframe readout of facts under a hero. Splits into columns only where they fit; stacks full-width below that. |
| `SignalLiveClock` | Blinking accent LED beside the local time — one of the three permitted accent appearances |
| `SignalMarquee` | Edge-to-edge ticker with accent `//` separators |
| `SignalDrawnRule`, `SignalReveal`, `SignalOnVisible`, `SignalScrambleText` | Motion primitives |
| `SignalAsciiField` | The atmosphere; `vortex` / `wave` / `scan` |
| `SignalFooter` | Coordinate stamp with a live clock — the closing gesture |

### Adding a component

1. It reads `context.signal`; it takes no colours as parameters.
2. Its radius is one of the two legal values.
3. It has no shadow.
4. Its text uses a `SignalType` role.
5. It carries no fixed layout width, and it states how it collapses in portrait.
   If it marks state with a rule on one side — the nav link's underline — it
   reserves the same space on the other. A `Container` folds a border's width
   into its inset, so an underline costs its gap *plus* its own hairline; leave
   that unbalanced and a row centres the label-plus-rule, which rides the label
   itself high beside anything next to it.
6. It honours reduced motion if it moves.
7. Export it from `lib/design/signal.dart`.
8. Add it to `/design` — a component that is not in the storybook does not exist.
9. Look at it on a phone.

---

## Provenance

Five references were blended; each contributed specific decisions rather than a
look to copy.

| Reference | What it contributed |
|---|---|
| **gt-planar** | 1px hairline as architecture; the two-tier radius rule; dense data rows |
| **dope.security** | The mono section stamp at +0.2em; the frosted nav; the coordinate footer; colour rationing; General Sans |
| **leonardo.ai** | Display type at sculptural scale; pill controls; the active-tab glow |
| **eclipse** | A single chromatic token; hairline-weight display; the marquee; filled+ghost CTA pairing |
| **mono** | The 2px contact-sheet cell grid; zero radius; the light inversion band |
| **the previous site** | The ASCII character texture, the scramble, the drawn dashed lines, the live clock |

---

## Escape hatches

If a rule genuinely must bend, mark the line:

```dart
// design-rules: allow — atlas glyphs must be pure white so drawAtlas
// can modulate them.
color: Color(0xFFFFFFFF),
```

The guard accepts it, and the reason stays visible in review. Three exist today,
all in `lib/design`. If you find yourself writing a fourth, the rule is probably
wrong — change the system, not the exception list.
