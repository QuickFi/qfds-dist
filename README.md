# QuickFi Design System

Colour, typography, spacing, elevation and the runtime brand engine, for iOS, Android and web.

**This repository is generated.** It is assembled by `scripts/build-dist.js` in QuickFi's private design-system repo and force-pushed here on every release. Pull requests and direct commits are overwritten by the next tag — raise anything you find with the design-system owner instead.

Current release: **1.0.2**

**Why this repository is public.** Package managers (Swift Package Manager, jsDelivr, Maven Central) can only resolve a dependency from an unauthenticated public URL, so the design system's consumable artifacts have to live somewhere public. This repository is written solely by CI from a tagged release and contains only generated design tokens, licensed fonts and documentation — no source tooling, no credentials, no customer data — so nothing confidential leaves the private repo. Recorded here for SOC 2 asset classification.

---

## Web

Paste the link. The version is pinned in the URL, so the stylesheet never changes under you:

```html
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/gh/QuickFi/qfds-dist@v1.0.2/web/quickfi.css">
```

Swap `v1.0.2` for a later tag to take a new release. `@v1` also resolves, and floats to the newest `1.x` — convenient, but it means a release can change your styling without you doing anything.

Every token is a custom property (`--qf-text-primary`, `--qf-space-md`, …) and every type role is a utility class (`.qf-body`, `.qf-numeric-lg`, …). Light and dark both ship; dark applies on `prefers-color-scheme` or on an explicit `data-theme="dark"`.

## iOS

Swift Package Manager, no credentials:

```swift
.package(url: "https://github.com/QuickFi/qfds-dist.git", from: "1.0.2")
```

```swift
import QuickFiDesignSystem

Text("Monthly payment")
    .quickFiText(.label)
    .foregroundStyle(QuickFiColor.textPrimary)
    .padding(QuickFiSpacing.md)
```

Work Sans ships inside the package and registers itself. Add nothing to your `Info.plist`, bundle no fonts.

Requires iOS 16.

## Android

Maven Central, no credentials:

```kotlin
// settings.gradle.kts — mavenCentral() is usually already there
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
    }
}
```

```kotlin
// app/build.gradle.kts
implementation("io.github.quickfi:design-system-android:1.0.2")
```

```kotlin
QuickFiTheme(brandSeed = creditLineSeed) {
    // MaterialTheme colours, shapes and typography are all bound to the
    // design system inside here — stock Material components come out right.
}
```

Work Sans ships inside the module. Requires minSdk 24, Compose.

---

## What is in here

| Path | What it is |
|---|---|
| `web/quickfi.css` | Every token as a custom property, plus type utilities and button recipes. |
| `Package.swift`, `Sources/` | The Swift package: colour, typography, layout, elevation, motion, and the bundled faces. |
| `design.md` | The written system — what each token means and the rules for using it. Hand this to an engineer or to an AI agent alongside the package. |
| `LICENSE` | MIT. |
| `THIRD-PARTY.txt` | Work Sans, SIL Open Font License 1.1. |

The Android artifact is not in this repository — it is published to Maven Central as `io.github.quickfi:design-system-android`. This repo is its source of record for the licence and the docs.

## Read design.md before binding anything

The rules that are not derivable from the values, and that get systems into trouble:

- Never reference a raw hex or a `green/*` ramp primitive in a component. Bind to a semantic token.
- Never white text on brand green, and never brand green as a button fill or as text.
- Never signal status by colour alone — pair an icon **and** a label.
- Touch sizes are minimums (`minHeight`), never fixed heights.

`design.md` carries the rest, and it is regenerated with every release, so it always describes the values in the same tag.
