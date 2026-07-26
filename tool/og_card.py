"""Builds the social card at `web/og.png`, from the site's own tokens.

    python3 tool/og_card.py           # writes build/og_card.html
    # then screenshot it at exactly 1200x630 and save as web/og.png

The card is not a picture of the hero, it *is* the hero: the ASCII layer runs
the same vortex function the app paints, frozen at one instant, and the type
uses the same font files the app bundles. Regenerate it whenever the hero's
copy or the palette changes — a card that no longer matches the page it links
to is worse than no card.

Screenshotting is left to whatever headless browser is at hand rather than
pinned as a dependency; the only thing that matters is 1200x630 at a device
pixel ratio of 1.
"""

import base64
import math
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
FONTS = ROOT / "assets" / "fonts"
OUT = ROOT / "build" / "og_card.html"

# lib/design/tokens/signal_colors.dart — instrument.
CANVAS = "#050605"
FG = "#ECEFE6"
MUTED = "#8A8F80"
DIM = "#5C6154"
ACCENT = "#C6F24E"
LINE = "rgba(233,240,224,.16)"

# lib/design/components/signal_ascii_field.dart.
RAMP = " .·:-=+*o#%@"
CELL_W, CELL_H = 9.0, 14.0

W, H = 1200, 630
COLS, ROWS = int(W / CELL_W) + 1, int(H / CELL_H) + 1

# The phase to freeze at. Chosen by eye: it puts an accent cluster in the open
# space beside the wordmark instead of behind it.
TIME = float(sys.argv[1]) if len(sys.argv) > 1 else 9.0


def field() -> str:
    """The vortex, one frame of it, as spans."""
    rows = []
    for y in range(ROWS):
        fade = 1 - (y / ROWS) * 0.72
        row = []
        for x in range(COLS):
            cx, cy = COLS * 0.5, ROWS * 0.62
            dx, dy = (x - cx) * 0.9, (y - cy) * 1.9
            rad = math.sqrt(dx * dx + dy * dy)
            ang = math.atan2(dy, dx)
            value = (
                math.sin(rad * 0.17 - TIME * 0.75)
                + math.sin(ang * 5 + TIME * 0.62)
                + math.sin(rad * 0.05 + ang * 3 - TIME * 0.34)
                + math.sin(x * 0.06 + y * 0.09 + TIME * 0.2)
            )
            n = (value + 4) / 8
            index = int(n * n * len(RAMP) * fade) if n > 0 else 0
            glyph = RAMP[min(index, len(RAMP) - 1)] if index > 0 else " "
            if glyph == " ":
                row.append("&nbsp;")
                continue
            hot = n > 0.9
            # Full strength rather than the section's 0.62: a still frame at
            # thumbnail size has to carry what a moving one gets for free.
            alpha = (0.6 if hot else 0.3) * fade
            row.append(
                f'<i style="color:{ACCENT if hot else DIM};'
                f'opacity:{alpha:.2f}">{glyph}</i>'
            )
        rows.append("".join(row))
    return "\n".join(rows)


def face(family: str, weight: int, filename: str) -> str:
    path = FONTS / filename
    fmt = "opentype" if path.suffix == ".otf" else "truetype"
    data = base64.b64encode(path.read_bytes()).decode()
    return (
        f"@font-face{{font-family:'{family}';font-weight:{weight};"
        f"font-display:block;src:url(data:font/{path.suffix[1:]};base64,"
        f"{data}) format('{fmt}')}}"
    )


FACES = "".join([
    face("Clash", 200, "ClashDisplay-Extralight.otf"),
    face("Clash", 700, "ClashDisplay-Bold.otf"),
    face("Sans", 400, "GeneralSans-Regular.otf"),
    face("Mono", 400, "JetBrainsMono-Regular.ttf"),
])

HTML = f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8"><title>Card</title><style>
{FACES}
*{{margin:0;padding:0;box-sizing:border-box}}
html,body{{width:{W}px;height:{H}px;background:{CANVAS};overflow:hidden}}
.card{{position:relative;width:{W}px;height:{H}px}}
.field{{position:absolute;inset:0;font-family:'Mono';font-size:12px;
  line-height:{CELL_H}px;letter-spacing:{CELL_W - 7.2:.2f}px;
  white-space:pre}}
.field i{{font-style:normal}}
.rules span{{position:absolute;top:0;bottom:0;width:1px;background:{LINE}}}
.body{{position:absolute;inset:0;padding:64px;display:flex;
  flex-direction:column;justify-content:space-between}}
.eyebrow{{font-family:'Mono';font-size:15px;letter-spacing:3px;color:{MUTED};
  text-transform:uppercase}}
.eyebrow b{{color:{ACCENT};font-weight:400}}
.name{{margin-top:6px}}
.mass{{font-family:'Clash';font-weight:700;font-size:150px;line-height:.86;
  letter-spacing:-5.25px;color:{FG};display:block}}
.hair{{font-family:'Clash';font-weight:200;font-size:150px;line-height:.92;
  letter-spacing:-2.25px;color:{FG};display:block}}
.lede{{font-family:'Sans';font-weight:400;font-size:29px;line-height:1.5;
  letter-spacing:-.29px;color:{MUTED};margin-top:26px;max-width:760px}}
.lede b{{color:{FG};font-weight:400}}
.strip{{display:flex;border:1px solid {LINE}}}
.cell{{flex:1;padding:14px 16px;font-family:'Mono';font-size:15px;
  letter-spacing:3px;color:{MUTED};text-transform:uppercase;
  border-right:1px solid {LINE};display:flex;align-items:center;gap:10px}}
.cell:last-child{{border-right:0}}
.cell b{{color:{FG};font-weight:400}}
.led{{width:9px;height:9px;background:{ACCENT};flex:none}}
</style></head><body><div class="card">
<div class="field">{field()}</div>
<div class="rules">
  <span style="left:0"></span><span style="left:200px"></span>
  <span style="left:400px"></span><span style="left:600px"></span>
  <span style="left:800px"></span><span style="left:1000px"></span>
  <span style="left:1199px"></span>
</div>
<div class="body">
  <div>
    <div class="eyebrow">Software developer <b>//</b> Flutter &amp; Dart
      <b>//</b> T&#220;RK&#304;YE</div>
    <div class="name">
      <span class="mass">CAN</span><span class="hair">ARSLAN</span>
    </div>
    <div class="lede"><b>I write software and build products.</b><br>
      I share my open source work on GitHub and pub.dev.</div>
  </div>
  <div class="strip">
    <div class="cell">canarslan.me</div>
    <div class="cell">pub.dev <b>Publisher</b></div>
    <div class="cell">Open <b>Source</b></div>
    <div class="cell"><i class="led"></i><b>Live</b></div>
  </div>
</div>
</div></body></html>
"""

OUT.parent.mkdir(parents=True, exist_ok=True)
OUT.write_text(HTML)
print(OUT)
