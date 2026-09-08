# QuickFi Design System — brief for AI agents

> Generated from `figma-plugin/code.js`. Do not edit by hand; run `node scripts/gen-design-md.js`.
> CI fails if this file drifts from the token source.

You are generating UI for QuickFi, an equipment-finance platform. This file contains every value you need. **Do not invent colours, sizes, or spacing.** If you need something that is not here, see *When a value is missing* at the end.

---

## The seven rules

1. **Never use a raw hex in a component.** Reference a token by name. This is what makes retheming possible.
2. **Never put white text on the brand green.** It measures 3.02:1 and fails. The brand green takes a near-black label. (`text/on-action` is mode-split — white in light, near-black in dark — because it pairs with the `action/filled/*` fills, not with the brand green.) A legal green filled button exists — `action/filled/success` + `text/on-action-success` — but it binds a status hue aligned to `feedback/success`, never `brand/green` the primitive.
3. **Never use the brand green for body text.** At 3.02:1 it clears the 3:1 bar for large text and UI boundaries by 0.02 and nothing more. Use `text/link` for green text.
4. **Never signal status with colour alone.** Success shares the brand hue, so a bare green dot is ambiguous. Always pair with an icon *and* a text label.
5. **One primary action per screen.** Two green buttons compete and neither reads as the answer.
6. **Touch targets are minimums, not fixed heights.** Use `minHeight`, never `height`, or text clips at large font scales.
7. **Navigation is native.** Tab bars, navigation bars, sheets and menus use the platform's own component. Tokens cross platforms; layouts do not. See *Platform components* below.

---

## Building a screen

Work back to front. These five are **structural only** — none of them changes colour for interaction state; that job belongs to `action/selected` (see *Action* below).

| Layer | Token | What goes here |
|---|---|---|
| 1. Background | `container/background` `#F1F1F4` / `#242424` | Every screen background. Always tinted. **Only section headers sit directly on it.** |
| 2. Surface | `container/surface` `#FFFFFF` / `#2C3036` | Cards, sheets, list rows, dialogs, nav bars, tables. Everything lives here. In light mode this is pure white — the lightness ceiling — so it is the LEAST toned of the group, not the most. |
| 3. Surface-1 | `container/surface-1` `#E3E3E8` / `#393834` | One elevation step ABOVE surface: a tab bar or nav bar sitting over a list of raised rows. |
| 4. Surface-2 | `container/surface-2` `#D6D6DB` / `#41403C` | One step past surface-1, for whatever needs to read as more prominent still. Neither surface-1 nor surface-2 is required on a screen that never nests this deep — there is no surface-3: a dialog or sheet sits on a scrim, which resets the stack, so a modal reuses `container/background` (full-bleed sheet) or `container/surface` (centred dialog). |
| 5. Subsurface | `container/subsurface` `#D8D8DB` / `#3C3C44` | Recessed areas **inside** a surface: inputs, wells, disabled fields. |

Because the background is tinted, surface reads by fill and **needs no border** (1.13 light, 1.17 dark). Surface-1 and surface-2 are each derived to clear a separation floor against every tier already placed before them, not just their immediate neighbour — same rule, same floor, in both modes.

> **Direction flips by mode.** `container/subsurface` is *darker* than its parent in light and *lighter* in dark. There is a floor at black but headroom above it — the same reason iOS uses lighter `systemFill` levels. This is correct, not a bug.
>
> **`text/tertiary` is rated ONLY on `container/background` and `container/surface`.** It lands between 3.1 and 4.2:1 on surface-1, surface-2 and `action/selected` — below the 4.5:1 floor. Use `text/primary` or `text/secondary` there instead.
>
> **This ladder is a declared inversion of Material 3's own container contract, by decision.** Material expects `surfaceContainerLowest` to sit at or above `surface`'s own tone and `surfaceBright` to exceed it — headroom that assumes `surface` isn't already the lightness ceiling. Here it is, so a Material bridge (e.g. `platforms/android/Theme.kt`) can only map those slots to `surface` itself or below, never brighter. Fixing it would mean moving `container/surface` off pure white, which every other pairing in this document already audits against — so it is documented, not changed. No token values differ because of this.


---

## Pairing table — which foreground on which fill

**This is the lookup you need most often.** If a fill is not in this table, it is not a fill.

| Fill | Use these foregrounds |
|---|---|
| `container/background` | text/primary · secondary · tertiary — SECTION HEADERS ONLY |
| `container/surface` | text/primary · secondary · tertiary — all content lives here |
| `container/surface-1` | text/primary · text/secondary — text/tertiary is NOT rated here in either mode |
| `container/surface-2` | text/primary · text/secondary — text/tertiary is NOT rated here in either mode |
| `container/subsurface` | text/primary · text/secondary — text/tertiary is NOT rated here in either mode |
| `action/selected` | text/primary — text/link measures below the text floor on it and is not permitted |
| `action/filled/* — neutral · notify · danger, any state` | text/on-action — never text/primary |
| `action/filled/success — any state` | text/on-action-success — its own identifier, on the same white-light/near-black-dark split as text/on-action. Deliberately unaudited: see the Text group |
| `action/filled/disabled` | text/on-action-disabled — never text/disabled |
| `action/outline` | no fill; paired with a text/secondary label — its value matches text/secondary exactly, by design |
| `brand/accent` | text/on-brand — never text/on-action; the fallback and the resolved value both need this exact label |
| `brand/background` | text/on-brand-background — never text/primary blindly; the brand engine checks this per credit line |
| `feedback/{status}-bg` | feedback/{status}-text — never feedback/{status} |
| `feedback/badge` | text/on-badge — never feedback/error as a badge fill |
| `feedback/info · feedback/notify as a button fill` | text/on-action — the only two statuses rated for this |

---

## Colour tokens

Format: light / dark.

### Primitives — reference only

**Never bind a component to these.** They feed the semantic layer; a component referencing `brand/green` or `green/500` directly is what makes retheming impossible. Every use you need is covered by `action/*`, `text/*`, `container/*` or `feedback/*`.

| Token | Values | Use |
|---|---|---|
| `brand/charcoal` | `#3A3A3C` / `#3A3A3C` | PRIMITIVE. The neutral anchor; the grey ramp derives from its hue. Never bind a component to this. |
| `brand/green` | `#25AB3A` / `#25AB3A` | PRIMITIVE. The brand colour, for marks, illustration and marketing artwork. Never bind a component to this directly. It doubles as QuickFi's own seed for the runtime brand engine (tokens/brand-engine.md) — the credit-line accent and container tokens derive from a seed exactly like this one, per partner. **Mode-stable** — one value works on white and on the dark surface, at 3.02:1 on white: fills, headings 24pt+ and borders only. |
| `text/link` | `#0867B1` / `#87C2FE` | Tappable text: inline links and the label of a TEXT button. Not rated on `container/subsurface` or `action/selected` — measured 2.67-3.46:1 across the registered credit lines once BOTH are brand-derived, and never above 3.59:1 across the 216-seed sweep. Use `text/primary` on either. The neutral fallback is `feedback/info-text`'s value in both modes — the blue a link reads as when no credit line has resolved, rather than the near-black/near-white it used to inherit from the text ramp. BRAND-DERIVED. This value is the neutral fallback — used before a credit line resolves, and by any brand-agnostic surface (marketing, a program-less login screen). Once a credit line is known, the runtime brand engine (tokens/brand-engine.md) overrides this same identifier with that credit line's accent tone; the swap is a cross-fade, not a reload. |

### Text — pick by emphasis, then check the pairing table

| Token | Values | Use | On surface |
|---|---|---|---|
| `text/primary` | `#0B0A0F` / `#F3F3F6` | Titles, body, values. Also the label of an OUTLINE button. | 19.73 / 11.98 |
| `text/secondary` | `#3B3B3B` / `#E6E6E6` | Supporting copy, row detail, captions. | 11.20 / 10.63 |
| `text/tertiary` | `#6D6D72` / `#9999A0` | Timestamps and hints. NOT placeholders — a placeholder sits in the `container/subsurface` well of an input, where this measures 3.62:1 light / 3.86:1 dark; use `text/secondary`. Still AA on `container/background` AND `container/surface` — and ONLY there. Everywhere else it lands 3.55-4.02:1, under the 4.5:1 floor: use `text/primary` or `text/secondary`. See the pairing table. | 5.15 / 4.69 |
| `text/disabled` | `#A7A7AD` / `#68686F` | Disabled control labels ONLY, never content. Below AA by design — WCAG 1.4.3 exempts the text of an inactive control by name, and a disabled label that clears the active floor reads as enabled. | 2.39 / 2.40 |
| `text/on-action` | `#FFFFFF` / `#090C08` | Label on every `action/filled/*` intent and on solid feedback fills. MODE-SPLIT: white in light, near-black in dark. | — |
| `text/on-action-disabled` | `#606067` / `#BABAC1` | Label on `action/filled/disabled`. Nothing else — never `text/disabled`, which is a content token. 4.6:1. | — |
| `text/on-badge` | `#FFFFFF` / `#090C08` | The numeral on the count badge. Nothing else. MODE-SPLIT: white in light, near-black in dark — same logic as `text/on-action`, kept separate so badges can retheme independently. | — |
| `text/on-action-success` | `#FFFFFF` / `#0B0A0F` | Label on `action/filled/success`. Nothing else. Mode-split, same as `text/on-action`: white in light, near-black in dark. The one label pairing in this system with no contrast audit behind it. On the light success fill white measures 3.42:1 and near-black 5.77:1, but near-black on a saturated mid-green reads as smudged — WCAG's luminance-only ratio does not model that. The pairing was dropped from the audit by decision; changing `action/filled/success` will not fail a build here. | — |
| `text/link` | `#0867B1` / `#87C2FE` | Tappable text: inline links and the label of a TEXT button. Not rated on `container/subsurface` or `action/selected` — measured 2.67-3.46:1 across the registered credit lines once BOTH are brand-derived, and never above 3.59:1 across the 216-seed sweep. Use `text/primary` on either. The neutral fallback is `feedback/info-text`'s value in both modes — the blue a link reads as when no credit line has resolved, rather than the near-black/near-white it used to inherit from the text ramp. BRAND-DERIVED. This value is the neutral fallback — used before a credit line resolves, and by any brand-agnostic surface (marketing, a program-less login screen). Once a credit line is known, the runtime brand engine (tokens/brand-engine.md) overrides this same identifier with that credit line's accent tone; the swap is a cross-fade, not a reload. | 5.86 / 7.06 |
| `text/cursor` | `#0B0A0F` / `#F3F3F6` | The caret in a text field. Nothing else. BRAND-DERIVED, to the same value as `border/focus` — a caret and a focus ring are one signal on one control, both saying THIS is where typing goes. This value is the neutral fallback shown before a credit line resolves. Left unbound, Material resolves the caret to its primary slot, which in this system is `action/filled/neutral` charcoal — a credit line's field would blink in QuickFi's grey. Rated as a graphic (3:1), not as text: a caret is a thin mark, not something anyone reads. Measured against `container/subsurface`, `container/surface` and `container/background`. | 13.87 / 9.87 |
| `text/selection-bg` | `#C9C9CE` / `#494844` | The wash behind selected text INSIDE a field. Nothing else. BRAND-DERIVED, and deliberately NOT the same token as `action/selected`. A selected row sits on `container/surface` or surface-1; selected text sits in the `container/subsurface` well of an input. Different backdrop, different separation obligation, so they cannot share one value — the two only share a starting point, because the neutral is the neutral. `text/primary` must clear 4.5:1 on it. That is the pairing Material never audits, and the reason an unbound selection wash is a risk on a recessed field. | 11.96 / 8.27 |

### Action — fills of an interactive control, by intent and state

Filled buttons come in **four intents**. Every intent except SUCCESS carries `text/on-action`; SUCCESS carries `text/on-action-success`. Hover is web-only; mobile has no hover.

There is deliberately no BRAND intent. White-labelling means a button cannot assume the partner's credit line is any particular hue, so the primary action's fill is brand-agnostic NEUTRAL — not a fallback tier, the only tier. The credit line's colour still appears, but as an accent, never a button fill; see the brand engine section below.

SUCCESS is not a BRAND intent under another name. Its hue is aligned to `feedback/success` — a status colour every credit line shares identically — never to `brand/green`, QuickFi's own per-credit-line runtime seed. A partner's Save button is the same green every other partner's is, the same way DANGER is the same red for everyone.

| Intent | Use | Default | Hover | Pressed |
|---|---|---|---|---|
| `action/filled/neutral` | **The default filled weight — every primary and secondary action binds here**: Sign now, Manage, View statement alike. | `#3A3A3C` / `#EDEDED` | `#313133` / `#F2F2F2` | `#28282A` / `#F7F7F7` |
| `action/filled/notify` | Notification and announcement actions. Same purple as `feedback/notify`. | `#8B37C3` / `#A96CD3` | `#7F31B4` / `#B27AD8` | `#7229A5` / `#BB88DE` |
| `action/filled/danger` | **Terminal and destructive actions**: Delete, Cancel contract. Never the primary path; always behind a confirmation. Same red family as `feedback/badge`. | `#C8102E` / `#FF8983` | `#B40E27` / `#FF938E` | `#A00C22` / `#FF9E99` |
| `action/filled/success` | **A positive, affirming action the product calls out**: Save, Approve, Complete. Same green family as `feedback/success`. Pair with `text/on-action-success`, never `text/on-action` — white fails 4.5:1 on this fill in both modes. | `#2E9F3C` / `#56B25C` | `#2A9237` / `#64B869` | `#288C35` / `#6ABB70` |

| Token | Values | Use |
|---|---|---|
| `action/filled/disabled` | `#DDDDE7` / `#494950` | The ONE disabled fill, shared by every intent — a dead button has no intent. Desaturated — reads inert, not brand. Pair with `text/on-action-disabled`. |
| `action/selected` | `#C9C9CE` / `#494844` | The ONLY token in the system whose job is purely interaction state, not structure. Pressed fill for an OUTLINE or TEXT button; fill for a selected row, chip or tab. Audited against both `container/surface` and `container/surface-1` — the two real layers it sits on top of — not just one. Takes `text/primary` only — `text/link` is not rated on it, same as `container/subsurface`. BRAND-DERIVED. This value is the neutral fallback used before a credit line resolves; the runtime brand engine (tokens/brand-engine.md) then washes it with that credit line's hue, one chroma step stronger than the container wash, and keeps its own separation floors — including one against `action/filled/disabled` that no static audit ever measured. |
| `border/default` | `#E0E0E0` / `#54545D` | Hairlines, dividers, input strokes, table rules — and the border of a DISABLED outline button. NOT a control boundary: at 1.22:1 it cannot carry one. |
| `border/focus` | `#0B0A0F` / `#F3F3F6` | Focus ring. 2pt, never thinner. BRAND-DERIVED, same override relationship as `text/link`: this value is the neutral fallback pre-resolution; the runtime brand engine (tokens/brand-engine.md) supplies the credit line's tone once known. |

### Feedback — three roles per status, always used together

- **`{status}`** — icon glyphs, solid fills, 2px borders. Tuned to clear 3:1 for graphics (measured ≈3.4).
- **`{status}-text`** — text on the tint. The only one of the three safe to read.
- **`{status}-bg`** — the tint.

A banner is: `-bg` behind, `{status}` on the icon, `-text` on the words. **Never** use `{status}` for text on `{status}-bg`.

| Status | Icon | Text | Tint |
|---|---|---|---|
| error | `#F55155` / `#F97774` | `#C1152B` / `#FFA19D` | `#FFE7E4` / `#562D2C` |
| warning | `#C77912` / `#D19251` | `#9B5100` / `#EDB073` | `#FFEEDD` / `#4A3623` |
| success | `#2E9F3C` / `#56B25C` | `#007700` / `#70CB74` | `#E0FAE0` / `#243C25` |
| info | `#1778C9` / `#66A3E2` | `#0867B1` / `#87C2FE` | `#E3F4FF` / `#293C50` |
| notify | `#8B37C3` / `#A96CD3` | `#8548AC` / `#D9A7FE` | `#FBEAFF` / `#433250` |

**`feedback/badge`** `#C8102E` / `#FF8983` is the **count badge** — unread counts, cart totals, alert tallies. Not a status: one solid fill, no `-text` or `-bg` role. Its numeral is `text/on-badge` (5.88:1 light / 8.58:1 dark). Never use `feedback/error` as a badge fill — it is a graphics red tuned to 3:1 and unreadable under a numeral. A badge never appears without its count.

### The green ramp is off-limits

You will find `green/50` through `green/700` in `tokens/values.json`. **Do not reference them.** They are primitives that feed the semantic layer, and binding a component to `green/500` is exactly what makes a system impossible to retheme. Every use you need is already covered by `brand/*`, `action/*`, or the neutral wash `container/subsurface`.

---

## Brand engine — dynamic colour per credit line

QuickFi is white-labelled per credit line (Partner Blue-1, Partner Red-1, Partner Blue-2, QuickFi's own, and others to come). Most tokens above this line are static and brand-agnostic — generated once, identical for every partner. A second tier is **computed at runtime** instead, one derivation per credit line, from a single seed colour. Full spec, algorithm and the seed registry: `tokens/brand-engine.md` and `tokens/credit-lines.json`. Summary:

| Token | Job | Static fallback |
|---|---|---|
| `container/background`, `-surface`, `-surface-1`, `-surface-2`, `-subsurface` | All five structural surfaces, given a faint per-credit-line wash — same lightness ladder, only the hue changes. This is what makes a credit line's app feel like its own thing, not a neutral shell with a few coloured accents. | the untinted values shown earlier |
| `action/selected` | The selection wash, derived too — one chroma step stronger than the ambient surfaces above, at the tonal-card cap, never as strong as `brand/accent`. The one derived token whose **lightness** may move, which is why `checkDerivation` asserts the dark ladder for it directly. | `#C9C9CE` / `#494844`, the neutral pre-resolution value |
| `brand/accent` | Chip fills, an emphasis/progress bar — never a button fill. | `#3A3A3C` / `#EDEDED`, identical to `action/filled/neutral` |
| `brand/accent-hover`, `-pressed` | A fixed-opacity state layer over `brand/accent` (Material 3's mechanism) — not an independently derived tone. | identical to `action/filled/neutral-hover`/`-pressed` |
| `text/on-brand` | Label on a `brand/accent` fill. | `#FFFFFF` / `#090C08`, identical to `text/on-action` |
| `brand/background` | One MORE tinted tonal surface than the ambient wash above: a credit-line hero card or program switcher. Nowhere else. Named to avoid colliding with the static `container/*` group. | `#C9C9CE` / `#494844`, identical to `action/selected` |
| `text/on-brand-background` | Label on `brand/background`. | `#0B0A0F` / `#F3F3F6`, identical to `text/primary` |
| `text/link` | Inline links, the TEXT button label, emphasized numerals. | the neutral value shown earlier in this document |
| `border/focus` | The focus ring. | the neutral value shown earlier in this document |

**Why runtime, not another hand-audited static tier.** This system's whole discipline is measuring every pairing by hand in `tokens/audit.json`. That does not scale to an open-ended list of partner colours picked for marketing reasons, not accessibility ones. Instead the derivation algorithm itself carries the contrast guarantee — muted chroma, a search over lightness until the WCAG floor is met, checked on every mode for every seed, including the surface wash itself — and `scripts/check-brand-derivation.js` proves that guarantee holds, both for today's four seeds and for a synthetic sweep standing in for whatever partner comes next.

**Before a credit line is known** (mid-login, or a brand-agnostic surface like marketing), the app renders the static, untinted values above — which is why FILLED buttons being brand-agnostic `neutral` matters beyond white-labelling: it is also what makes the loading gap invisible. Once the credit line resolves, every token in the table above is overridden or tinted in place and the change is a cross-fade, not a reload.


## Typography

**Work Sans** for display and numerics. **Work Sans** for everything else.

Token names are shared across platforms except `display` and `numericXxl`, which are web-only; **the metrics are not shared, and must not be unified**. 17pt body is correct on iOS; 16sp is correct on Android.


**Thirteen roles on mobile, fifteen on web.** Each has one job. `displayMedium`, `displaySmall`, `titleLarge` and `bodyStrong` were removed early on because each collapsed onto a neighbour in practice. `display` and the largest numeral were removed from mobile later — both were 28pt there, identical to each other, and still small next to Apple's Large Title (34) or M3's Display roles (57/45/36). Mobile's ceiling is `title` (22pt) plus a numeric amount, not a headline treatment inherited from web marketing pages; `display` and `numericXxl` stay web-only, at their original desktop-appropriate sizes.

**Five of the thirteen are the numeric ladder** — `numericXs` 10 / `numericSm` 12 / `numericMd` 14 / `numericLg` 16 / `numericXl` 20, plus web-only `numericXxl` 32. It is a t-shirt scale rather than a small/medium/large trio because the app reached for 12, 14 and 16 and found only 14 and 20 to bind to, and a size that is not in the scale gets hardcoded.

Eight of the thirteen mobile sizes are **identical** across iOS and Android (`title`, `overline`, `tabLabel`, and every rung of the numeric ladder). The numeric ladder's agreement is deliberate, not incidental: an amount is the one thing a customer reads off both apps and compares, so a figure a point larger on one platform reads as a different number's worth of emphasis. The other five roles differ by exactly 1pt: that gap is the genuine platform difference (17pt body vs 16sp body), not drift, and must not be "fixed".


### iOS — Apple Dynamic Type ladder

| Token | Family | Weight | Size / Line height | Tracking |
|---|---|---|---|---|
| `title` | Work Sans | SemiBold | 22 / 28 | -0.2 |
| `label` | Work Sans | SemiBold | 17 / 22 | 0 |
| `body` | Work Sans | Regular | 17 / 22 | 0 |
| `bodySmall` | Work Sans | Regular | 15 / 20 | 0 |
| `caption` | Work Sans | Regular | 13 / 18 | 0 |
| `overline` | Work Sans | SemiBold | 11 / 13 | 1.1 |
| `controlLabel` | Work Sans | SemiBold | 15 / 20 | 0 |
| `tabLabel` | Work Sans | SemiBold | 12 / 16 | 0 |
| `numericXl` | Work Sans | SemiBold | 20 / 25 | 0 |
| `numericLg` | Work Sans | SemiBold | 16 / 21 | 0 |
| `numericMd` | Work Sans | SemiBold | 14 / 18 | 0 |
| `numericSm` | Work Sans | SemiBold | 12 / 16 | 0 |
| `numericXs` | Work Sans | SemiBold | 10 / 13 | 0 |

Line heights are deliberately **off** a 4pt grid. That is Apple's ladder, and matching it keeps text flush with nav bars and system controls. Always pass `relativeTo:` so Dynamic Type works.

### Android — Material 3

| Token | Family | Weight | Size / Line height | Tracking |
|---|---|---|---|---|
| `title` | Work Sans | SemiBold | 22 / 28 | 0 |
| `label` | Work Sans | SemiBold | 16 / 24 | 0.15 |
| `body` | Work Sans | Regular | 16 / 24 | 0.5 |
| `bodySmall` | Work Sans | Regular | 14 / 20 | 0.25 |
| `caption` | Work Sans | Regular | 12 / 16 | 0.4 |
| `overline` | Work Sans | SemiBold | 11 / 16 | 0.5 |
| `controlLabel` | Work Sans | SemiBold | 14 / 20 | 0.1 |
| `tabLabel` | Work Sans | SemiBold | 12 / 16 | 0.5 |
| `numericXl` | Work Sans | SemiBold | 20 / 28 | 0 |
| `numericLg` | Work Sans | SemiBold | 16 / 24 | 0 |
| `numericMd` | Work Sans | SemiBold | 14 / 20 | 0 |
| `numericSm` | Work Sans | SemiBold | 12 / 16 | 0 |
| `numericXs` | Work Sans | SemiBold | 10 / 12 | 0 |

Every line height is a 4pt multiple. Sizes are `sp` and scale independently of `dp` spacing.

### Web — its own tier

| Token | Family | Weight | Size / Line height | Tracking |
|---|---|---|---|---|
| `display` | Work Sans | Bold | 40 / 48 | -0.5 |
| `title` | Work Sans | SemiBold | 28 / 36 | -0.3 |
| `label` | Work Sans | SemiBold | 16 / 24 | 0 |
| `body` | Work Sans | Regular | 16 / 26 | 0 |
| `bodySmall` | Work Sans | Regular | 14 / 22 | 0 |
| `caption` | Work Sans | Regular | 13 / 20 | 0 |
| `overline` | Work Sans | SemiBold | 12 / 16 | 1 |
| `controlLabel` | Work Sans | SemiBold | 14 / 20 | 0 |
| `tabLabel` | Work Sans | SemiBold | 12 / 16 | 0 |
| `numericXxl` | Work Sans | Bold | 32 / 40 | -0.4 |
| `numericXl` | Work Sans | SemiBold | 20 / 28 | 0 |
| `numericLg` | Work Sans | SemiBold | 16 / 24 | 0 |
| `numericMd` | Work Sans | SemiBold | 14 / 20 | 0 |
| `numericSm` | Work Sans | SemiBold | 12 / 16 | 0 |
| `numericXs` | Work Sans | SemiBold | 10 / 14 | 0 |

Wider measures need looser leading than either mobile platform, and `display`/`numericXxl` exist only here — web is the one tier with a genuine hero size (40px) and a large tabular numeral (32px). Emitted as CSS custom properties and utility classes in `platforms/web/quickfi.css` — import that rather than re-declaring values.

**Numerics use tabular figures.** Payment amounts, rates, and amortization rows stack in columns; proportional digits make them ragged.

---

## Spacing, radius, touch

| Group | Values |
|---|---|
| `spacing/*` | xxs 4 · xs 8 · sm 12 · md 16 · lg 20 · xl 24 · xxl 32 · xxxl 40 · huge 48 |
| `radius/*` | xs 2 · sm 6 · md 8 · lg 12 · xl 16 · sheet 24 |
| `icon/*` | sm 16 · md 20 · lg 24 · xl 32 |
| `touch/*` | min-target 44 · min-gap 8 · control-height 48 · list-row 56 · list-row-two-line 72 |

Spacing is on a 4pt base. `16` is the standard screen edge inset; `24` separates major sections.

### Radius — a button is fixed, a card has a floor

Two rules, and they are different KINDS of rule. Read the difference before binding anything:

**A button is `radius/lg` (12dp), fixed.** Not a minimum, not a default — the value. Every tier (FILLED, OUTLINE, TEXT), every intent, every size, every platform. A button that rounds differently from the button beside it reads as a different control, and the one thing a button must not be is ambiguous about being a button. There is deliberately no larger-button or pill-button variant in this system: a capsule is `radius/full`, which no button binds.

**A card is `radius/xl` (16dp) MINIMUM.** A floor, not a value. A card may round larger where the composition calls for it — `radius/sheet` (24dp) is the top of the authored ladder — but never smaller. Below 16dp a card stops reading as a distinct surface and starts reading as a slightly-rounded rectangle of page, which is precisely the job `container/surface`'s fill is doing and does not need help with.

The gap between them is the point. A card at 16dp and a button at 12dp are 4dp apart, so a button sitting inside a card never looks like a miniature of it. Binding both to one token — which this document did until now, at `radius/md` for buttons and `radius/lg` for cards — collapses that distinction.

`radius/md` (8dp) is not the button token any more. It stays the default for **inputs and small non-card surfaces**: a text field, a well, a table cell. `radius/xs` and `radius/sm` are for marks and hairline-scale detail, never a control.

**Android costs one line per card.** Material 3 has a single `shapes.medium` slot and stock `Button`, `Card`, `Chip` and `Menu` all read it, so it cannot deliver 12dp and 16dp at once. `QuickFiTheme` binds it to `radius/lg`, so **buttons are correct for free** and a stock `Card` rounds 4dp under its floor. Give it the shape explicitly:

```kotlin
Card(shape = RoundedCornerShape(QuickFiTheme.radius.xl)) { /* ... */ }
```

Anything reading `shapes.large` already lands on the floor — that slot binds `radius/xl`. On iOS and web there is no shared slot to fight: SwiftUI takes `QuickFiRadius` directly, and `.qf-button-*` already carries `--qf-radius-lg`.

**Every border this system DRAWS is 2px** — a button outline, a divider, a table rule, the focus ring. One width token, `border/width`. **A text field is the exception:** its resting border takes the platform's own default width, because the field is a native control and its stroke is not ours to set — Compose's `TextField` owns its indicator thickness, UIKit and SwiftUI own theirs, and a browser owns the `input` default. Set the field's border *colour* and leave its width alone.

**Touch minimums:** 44pt target (Apple floor; Material asks 48), 8pt between adjacent targets, 48pt controls, 56pt single-line rows, 72pt two-line rows. These do not apply to pointer input on web.

**Icon sizes** are a glyph scale, not a container scale: `icon/md` (20) is the default, not Material's 24. Avatars and chat thumbnails are deliberately outside it — a separate scale with its own rhythm.

### Elevation — a stacking order

Depth is an **order**, and the order is the whole point. Read it top to bottom and the rule falls out: content is flat, a picked-up card lifts above it, the bars the page scrolls under sit above that, and one floating layer sits above everything.

In-flow content separates **by fill and hairline, never by shadow** — the tinted page is what makes that work. A card that casts a shadow at rest is the bug this ladder exists to prevent.

| Level | Use | dp | iOS / Web geometry | Web |
|---|---|---|---|---|
| `flat` | cards, list rows, tiles — everything in-flow | 0 | no shadow | none |
| `lifted` | a card dragged, reordered or picked up | 2 | 0 1 3 + 0 1 2 | `--qf-shadow-lifted` |
| `raised` | nav bar, tab bar, sticky headers | 4 | 0 3 8 + 0 1 3 | `--qf-shadow-raised` |
| `floating` | dialogs, sheets, menus | 8 | 0 8 24 + 0 2 6 | `--qf-shadow-floating` |

`raised` moved 2 → 4. At 2 a nav bar tied with a lifted card and lost to anything above it, which is backwards — the bar is what the page passes beneath. The old 2dp shadow is `lifted` now, unchanged.

**Both modes carry shadows.** The tint is `shadow/tint` — near-black in light, **pure black in dark**, because a shadow there has to darken a `container/background` of #242424 rather than a near-white page. Dark alphas run four to five times the light ones for the same reason. No platform ever suppressed shadows by theme; Compose, SwiftUI and CSS all draw them in dark, so the previous light-only rule was this system's choice, not a platform default.

**The dp ladder is the cross-platform contract, and it is the only part that can be identical everywhere.** Compose derives blur and offset from elevation dp and exposes only the ambient and spot *colour* — pass `shadowTint` as both, or Compose falls back to its own default and the token does nothing. CSS and SwiftUI take explicit blur and offset, so their geometry approximates Android's render at each step rather than matching it.

Two layers per level, a broad ambient pass and a tight contact pass; one layer reads as a blur rather than as depth. Never fake dark-mode depth with a border on a raised layer — that is the double-outline failure from the self-check below.

---

## Component recipes

**Buttons — three tiers.** All share `radius/lg` (12dp — fixed, never a minimum; see *Radius* above), `touch/control-height` min height, and the `label` type role.

| Tier | Fill | Border | Label | Hover (web) | Pressed | Disabled |
|---|---|---|---|---|---|---|
| Filled | `action/filled/{intent}` — neutral · notify · danger · success | — | `text/on-action` (`text/on-action-success` for the success intent) | `action/filled/{intent}-hover` | `action/filled/{intent}-pressed` | `action/filled/disabled` + `text/on-action-disabled` |
| Outline | none (transparent) | `action/outline` | `text/secondary` | `action/selected` | `action/selected` | `action/outline-disabled` + `text/disabled` |
| Text | none | none | `text/link` | `action/selected` + `text/primary` label | `action/selected` + `text/primary` label | `text/disabled` |

**Outline has no fill at rest — it is a transparent button, not a card with a border.** `action/outline`'s value is set equal to `text/secondary`'s, so the border and the label read as one weight. They stay separate token identities: a border is audited as a graphic pairing (3:1), a label as text (4.5:1), and the two are only coincidentally the same colour today.

While a text button is hovered or pressed its label shifts to `text/primary` — `text/link` measures below the text floor on `action/selected` in every registered credit line and is not permitted there.

**No tier's fill is ever brand-coloured.** Filled binds `action/filled/neutral` by default — there is no BRAND intent. The credit line's colour shows up exactly once per screen worth of chrome, as an accent: the TEXT tier's label (`text/link`), the focus ring, a chip fill, or an emphasized numeral — never as a button's own fill, on any tier. `action/filled/success` does not change this — its hue is the fixed, cross-partner `feedback/success` status colour, not a per-credit-line one. See the brand engine section below for how the accent actually is derived per credit line.

**Never use `border/default` as a button outline**, enabled or disabled. It is a hairline at 1.22:1; an active control boundary needs 3:1, which is what `action/outline` is for, and a disabled one takes `action/outline-disabled`. That token's value is set equal to `text/disabled`'s, the same way `action/outline` is set equal to `text/secondary`'s — a control's boundary and its label are one signal, so they move together. It sits **below** 3:1 on purpose (2.39 light, 2.40 dark): WCAG 1.4.11 exempts inactive components by name, and a disabled control that clears the active threshold looks enabled.

**A disabled glyph takes `text/disabled`, same as a disabled label.** There is no icon colour group — every glyph in this system binds to a `text/*` or `feedback/*` token — and `border/default` is never a glyph colour.

Press feedback on outline and text tiers is deliberately subtle (1.11–1.21) because touch confirms it. On web, pair it with hover rather than relying on it alone.

**Card** — `container/surface` fill, `radius/xl` (16dp) or larger — a floor, not a value; see *Radius* above — `spacing/sm` to `spacing/md` padding. No border needed on a tinted background.

**Text input** — `container/subsurface` fill, `radius/md`, `touch/control-height` min height, `text/primary` value, `text/secondary` placeholder (NOT `text/tertiary` — it measures 3.62:1 light / 3.86:1 dark in this well, below the 4.5:1 floor). On focus, `border/focus` at 2px.

**A field keeps `border/default` as its border colour wherever it sits** — one field, one look. The *width* is the platform's default, never `border/width`. What changes with the backdrop is only how much work that border is doing:

| Field sits on | `subsurface` vs its backdrop | `border/default` vs its backdrop |
|---|---|---|
| `container/surface` (or `-surface-1`, `-surface-2`) | 1.42:1 / 1.21:1 — the fill draws the well | 1.32:1 / 1.77:1 — the stroke finishes it |
| `container/background` | 1.26:1 / 1.42:1 — clears the 1.10:1 floor, so the fill draws the well here too | 1.17:1 / 2.07:1 — under the 3:1 WCAG 1.4.11 asks of a control boundary, so the stroke is not what identifies the field |

**The fill identifies the field; the stroke never does.** `container/subsurface` was darkened to make that true on the page — it separated at only 1.06:1 from `container/background` before, so a field there was drawn by neither its fill nor its edge. `border/default` stays under the 3:1 a control boundary would need on either backdrop, which is a deliberate exception of the same kind `action/outline-disabled` carries at 2.12:1 — recorded so nobody reads it as a bug and "fixes" it by darkening the stroke, which would degrade every divider on a raised surface. A field still needs a **visible label**: placeholder-only fields are not sufficient.

A field is the only thing that may sit directly on the background. Cards, rows, banners and every other control still sit on a surface.

**List row** — `container/surface`, `touch/list-row` min height (`list-row-two-line` with a subtitle), `label` primary line, `bodySmall` secondary in `text/secondary`.

**Status banner** — `feedback/{status}-bg` fill, `radius/sm`, `feedback/{status}` icon, `feedback/{status}-text` words. Icon and label both required.

**Count badge** — `feedback/badge` fill, fully rounded, `text/on-badge` numeral in `caption` at `label` weight, tabular figures. Minimum 16pt diameter, hit area untouched — a badge is not a target. Never `feedback/error` as the fill.

**Selected row / chip / tab** — `action/selected` fill with `text/primary`. Never `text/link` on it — measurably fails the text floor in every registered credit line. `action/selected` **is** brand-derived, and it reverses an earlier rule that read "selection is not a brand moment": a neutral grey selection sitting on hue-washed surfaces reads as drained, which is what disabled looks like, and in dark mode the static value measured 1.005:1 against `action/filled/disabled` — indistinguishable. `tokens/audit.json` could not catch that, because the two are never rendered on top of each other, only confused with each other. It carries one chroma step more tint than the surfaces beneath it and never more than `brand/accent`. See `tokens/brand-engine.md`, "Why `action/selected` is derived now".

**Currency or rate** — pick the rung by how much of the screen the number is answering for, not by how big the number is. `numericXl` (20) is the amount a card is about and is mobile's ceiling; `numericXxl` (32) is the web-only hero. `numericLg` (16) sits level with `label` and `body`, so an amount can share a line with words without out-shouting them. `numericMd` (14) is the table cell and the list row's trailing amount. `numericSm` (12) is a secondary figure beside a larger one. `numericXs` (10) is numerals only — chart axis ticks, dense grid captions — and never words. Tabular figures on, `text/primary`.

---

## Self-check before you ship

| Pairing type | Minimum |
|---|---|
| Normal text on its background | 4.5:1 |
| Large text (18pt+) and graphical objects | 3.0:1 |
| One surface reading as distinct from another | 1.10 |

Disabled control labels are exempt from the text minimum.

Two failures that are invisible unless you look for them:

- **A dark token below the background.** Dark mode here is mid-grey elevated (`#242424`), not near-black. Anything darker than the background reads as a hole punched in the screen.
- **A bordered card on a tinted background.** Reads as a double outline. Pick fill separation *or* a border, never both.

---

## Platform components

**Feed tokens into the platform's own navigation components. Do not port one platform's container to the other.**

| | iOS | Android |
|---|---|---|
| Tab / navigation bar | `TabView` (Liquid Glass) | `NavigationBar` |
| Selected fill | system tint | `secondaryContainer` ← `action/selected` |
| Selected label and icon | `text/link` | `onSecondaryContainer` ← `text/primary` — never `text/link` on `action/selected` |
| Unselected | `text/secondary` | `onSurfaceVariant` ← `text/secondary` |
| State cue | tint **and** a non-colour cue | indicator **and** a non-colour cue |
| Non-colour cue | filled vs outlined icon, or `tabLabel` vs `caption` | filled vs outlined icon, or `tabLabel` vs `caption` |

Three reasons this is not a stylistic preference:

**The two platforms answer the same question differently.** iOS expresses hierarchy through translucency; Material 3 Expressive uses colour and weight, and has no translucent material for app surfaces. Replicating glass on Android does not read as brand consistency — it reads as an iOS app that was ported.

**Native components carry their own accessibility.** Dynamic Type, Reduce Transparency, Increase Contrast, backdrop adaptation and correctly-contrasting selection indicators all come free. A custom navigation bar opts out of every one of them, and you own the backdrop-contrast problem on a surface whose backdrop is whatever happens to scroll under it.

**Selection state must survive an arbitrary backdrop.** Always pair the colour change with a non-colour cue. Colour alone fails WCAG 1.4.1, and on a translucent surface the colour cue itself is not guaranteed — the same label can measure 4.6:1 over a white page and 2.7:1 over a dark card.

Two cues satisfy this, in order of preference:

1. **A filled versus outlined icon.** The platform-native answer on both, and what a native tab bar expects. Requires the icon set to actually ship both variants per tab.
2. **`tabLabel` selected, `caption` unselected.** The fallback when it does not — and it frequently does not, which is why this is written down rather than assumed. Both roles are 12/16, so there is no layout shift; the cue is **weight** (SemiBold vs Regular), which survives any backdrop, any credit line's surface wash, and greyscale.

**What the theme gives you, and what it does not.** Material resolves ONE type style for a nav label and applies it to both states — `NavigationBarItem` reads `NavigationBarTokens.LabelTextFont` (`labelMedium`, bound here to `tabLabel`) once, and only the *colour* animates per state. So the theme delivers the right size for free and delivers **no weight cue at all**. Cue 2 therefore costs a state-conditional style at the call site:

```kotlin
label = {
    Text(screenName, style = if (selected) QuickFiTheme.typography.tabLabel
                             else QuickFiTheme.typography.caption)
}
```

Cue 1 costs nothing at the call site by comparison: `NavigationBarItem` already takes `selectedIcon` and `icon` separately, so the state cue lands where Material expects it. **On Android, cue 1 is the cheaper path as well as the better one** — the preference order above is about correctness, and on this platform effort agrees with it. On iOS the asymmetry is sharper still: `TabView` draws no indicator and gives far less control over per-item label styling, so cue 1 is close to mandatory rather than merely preferred.

**Do not treat the indicator itself as the non-colour cue.** It is a fill, and a faint one: `action/selected` measures **1.29:1** against `container/surface-1` in light and **1.28:1** in dark as static values, and **1.17–1.53:1** across every registered credit line once the brand engine derives it. `tokens/audit.json` rates that pair `sep` — a separation obligation (1.10, "you can tell one surface from another"), not the 3:1 a graphic cue that carries information owes. A pill at 1.3:1 reads as decoration. The selected/unselected label delta is no better on its own: `text/primary` against `text/secondary` is 1.76:1 in light and **1.13:1** in dark, which is why a nav bar relying on colour alone had a selected tab indistinguishable from its neighbours.

Raising the indicator to a real 3:1 obligation would mean moving `action/selected` or `container/surface-1` apart and re-auditing every pairing that touches either — a visual change to every selected row and chip in the product. Open design question, deliberately not resolved here; the cue above is what makes the nav bar conformant today.

What *does* cross platforms: the tokens, the type roles, the iconography, the copy, and the information architecture. That is what makes it recognisably the same product. The container is not.

---

## Web

The token layer carries over unchanged. Three differences:

- **Links need a non-colour cue.** Colour alone fails WCAG 1.4.1. Add an underline.
- **The focus ring is mandatory and frequently seen** — a keyboard user's only orientation cue.
- **Surface layers become max-width containers.** Keep a consistent container rhythm or the background tint starts reading as dead space.

---

## Known gaps

- **Hover exists only on the filled tier.** `action/filled/{intent}-hover` is web-only; mobile has no hover. Outline and text tiers hover with their pressed fills. **Do not invent additional hover values.**
- **Elevation is scaffolding, not token data.** The two shadow levels live in each platform's hand-written layer (`QuickFiElevation`, `--qf-shadow-*`) rather than in `tokens/values.json` — a composite shadow does not fit the float-only token schema. The recipes are documented in *Elevation* above and must be changed in all three places together.

---

## When a value is missing

**Do not invent one.** This system exists because a value was once invented to solve a real contrast problem, and it moved the brand 12.6° off-hue while making the shipped pairing 15% worse.

Instead:

1. Check whether an existing token covers the case — the pairing table is the fastest route.
2. If nothing fits, say so explicitly in your output and name what is missing.
3. Propose a value *with its measured contrast against the surfaces it will sit on*, and flag it as a proposal requiring a token addition.

A named gap is useful. A silently invented value is how a design system dies.

