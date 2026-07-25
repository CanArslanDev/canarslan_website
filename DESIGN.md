# SIGNAL — canarslan.me design system

> A dark instrument canvas carrying editorial typography. Terminal phosphor,
> museum plaque, boarding pass.

## Where to look

Two references, and they answer different questions.

- **`/design`** — run the app and open the hidden storybook route. Every token
  and component below is rendered there from the real code, so it can never
  drift from the system it documents. **This is the source of truth for what the
  system currently is.**
- **[The approved prototype](https://claude.ai/code/artifact/1b5d8000-969d-4fa0-b592-0c32b7f53c1d)**
  — the HTML mockup this system was signed off from. **This is the source of
  truth for what it is supposed to look like.** When the Flutter build and the
  prototype disagree, the prototype wins unless there is a written reason here
  saying otherwise.

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

### The stamp is the only H2

Sections are titled by a mono stamp: uppercase, +0.2em tracking. **The tracking
is the heading style.** There is no bold sans heading, no underline, no rule
above it. Reach for `SignalStamp`.

**Do:** use a `SignalType` role.
**Don't:** construct a `TextStyle` in a widget.

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
| Wave field | Selected work | A travelling wave, entirely in accent. The one place colour takes a surface. |
| Scan field | Quiet sections, footer | Sparse lines drifting upward |
| Scramble | Every section stamp | Characters settle out of noise on reveal |
| Glitch | Data row hover | The name scrambles for 240ms, then sets |
| Drawn rule | Section headings | An accent hairline draws in from the left |
| Reveal | Blocks | 14px up, 320ms, system curve |

The ASCII fields run at **~11fps on purpose** — it reads as a terminal
refreshing rather than a smooth shader, and costs almost nothing. Rendering goes
through a pre-baked glyph atlas and one `drawAtlas` call per frame; laying out a
`TextPainter` for each of ~2000 cells would cost far more than the effect is
worth.

Every animated component honours `MediaQuery.disableAnimationsOf`.

---

## Components

Import the barrel: `package:canarslan_website/design/signal.dart`.

| Component | Notes |
|---|---|
| `SignalSection` | Full-bleed band, closed by a hairline, optional ASCII field behind it |
| `SignalColumn` | The 1280 column with its grid rules |
| `SignalCell` | Square, hairline-bordered container. Not a card: no radius, no shadow. |
| `SignalInversion` | Swaps the palette for its subtree — the museum band |
| `SignalMuseumGrid` | 2px contact-sheet grid; rows size to their tallest tile |
| `SignalNavBar` | Frosted bar, hairline underneath, links from `expanded` up |
| `SignalPillButton` | `filled` + `ghost`. They are designed to appear as a pair. |
| `SignalChip`, `SignalTabs` | Pill controls; the active tab carries the accent glow |
| `SignalEyebrow`, `SignalStamp`, `SignalLede`, `SignalMicro` | The text roles |
| `SignalDisplayLine` | One display line; `mass` or `hair`, hero or section scale |
| `SignalDataRow` | A project as a wireframe row, not a card |
| `SignalMarquee` | Edge-to-edge ticker with accent `//` separators |
| `SignalDrawnRule`, `SignalReveal`, `SignalOnVisible`, `SignalScrambleText` | Motion primitives |
| `SignalAsciiField` | The atmosphere; `vortex` / `wave` / `scan` |
| `SignalFooter` | Coordinate stamp with a live clock — the closing gesture |

### Adding a component

1. It reads `context.signal`; it takes no colours as parameters.
2. Its radius is one of the two legal values.
3. It has no shadow.
4. Its text uses a `SignalType` role.
5. It honours reduced motion if it moves.
6. Export it from `lib/design/signal.dart`.
7. Add it to `/design` — a component that is not in the storybook does not exist.

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
