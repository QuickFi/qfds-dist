//
//  QuickFiLayout.swift
//  QuickFi Design System — hand-written. Values are checked against
//  tokens/values.json by scripts/validate.js; there is no generator yet.
//
//  Spacing keeps the website's 4pt base so web and mobile stay dimensionally
//  comparable. Touch, elevation, and motion values are mobile additions — a web
//  design system has no equivalent.
//

import SwiftUI

// MARK: - Spacing (4pt base, from the site's --spacing)

public enum QuickFiSpacing {
    public static let xxs: CGFloat = 4
    public static let xs:  CGFloat = 8
    public static let sm:  CGFloat = 12
    /// Standard screen edge inset.
    public static let md:  CGFloat = 16
    public static let lg:  CGFloat = 20
    /// Between major sections.
    public static let xl:  CGFloat = 24
    public static let xxl: CGFloat = 32
    public static let xxxl: CGFloat = 40
    public static let huge: CGFloat = 48
}

// MARK: - Radius (site base --radius is 8pt)

public enum QuickFiRadius {
    public static let xs: CGFloat = 2
    public static let sm: CGFloat = 6
    /// Default. Buttons, inputs, small cards.
    public static let md: CGFloat = 8
    /// Cards, tiles.
    public static let lg: CGFloat = 12
    /// Modals, large cards.
    public static let xl: CGFloat = 16
    /// Bottom sheet top corners only.
    public static let sheet: CGFloat = 24
    /// Pills, avatars, chips. Platform idiom, not a token — a capsule radius
    /// has no meaningful single value to audit or draw. Mirrors Android.
    public static let full: CGFloat = 9999
}

// MARK: - Touch
//
// Absent from any web system, non-negotiable here.

public enum QuickFiTouch {
    /// Apple HIG floor. Every tappable element must meet this in both axes,
    /// including icon-only buttons — expand the hit area rather than the glyph.
    public static let minTarget: CGFloat = 44
    /// Between adjacent tappable elements.
    public static let minGap: CGFloat = 8
    /// Buttons and inputs. Roomier than the web's 36pt: thumbs aren't cursors.
    public static let controlHeight: CGFloat = 48
    public static let listRowHeight: CGFloat = 56
    public static let listRowHeightTwoLine: CGFloat = 72
}

// MARK: - Icon size
//
// 20pt is this system's default glyph size, not Material's 24 — the scale
// describes what the apps already do rather than proposing a new habit.
// Avatars and chat thumbnails are deliberately NOT in here: a separate scale
// with its own rhythm and no business sharing a name with a glyph size.

public enum QuickFiIconSize {
    /// Inline affordances beside text — chevrons, small status marks.
    public static let sm: CGFloat = 16
    /// The default. List rows, buttons, field adornments.
    public static let md: CGFloat = 20
    /// Toolbar and nav-bar glyphs, anything with its own touch target.
    public static let lg: CGFloat = 24
    /// Empty states and feature marks — decorative, never tappable alone.
    public static let xl: CGFloat = 32
}

// MARK: - Elevation
//
// Depth is a stacking order, not a decoration, and the ORDER is the whole
// point. Read it top to bottom and the rule falls out: content is flat, a
// picked-up card lifts above it, the bars the page scrolls under sit above
// that, and one floating layer sits above everything.
//
// `raised` moved 2pt to 4pt. At 2 a nav bar tied with a lifted card and lost
// to anything above it, which is backwards — the bar is what the page passes
// beneath. The old 2pt shadow is `lifted` now, unchanged: nothing was
// re-invented, only re-labelled.
//
// Both modes carry shadows. Dark used to carry none on the reasoning that
// there is nothing to darken against; against a #242424 page there is,
// provided the tint is pure black rather than the near-black light mode uses.
// SwiftUI never suppressed shadows by colour scheme — that was this system's
// choice, not a platform default.
//
// The tint is shadow/tint (QuickFiColor.shadowTint); the alphas belong to the
// level. Blur and offset here are chosen to approximate Compose's render at
// the same dp — Android derives both from elevation dp and exposes only the
// ambient and spot colour, so matching numbers on all three platforms is not
// something the APIs allow. The dp ladder is the contract; this is its iOS
// rendering.

public enum QuickFiElevation {
    case flat
    case lifted
    case raised
    case floating

    /// Alphas per level, light then dark. Dark runs four to five times the
    /// light values: black on #242424 has far less to darken than the same
    /// shadow on #F1F1F4.
    func shadows(dark: Bool) -> [(color: Color, radius: CGFloat, y: CGFloat)] {
        let tint = dark ? Color(hex: 0x000000) : Color(hex: 0x0B0A0F)
        switch self {
        case .flat:
            return []
        case .lifted:
            return [
                (tint.opacity(dark ? 0.40 : 0.08), 3, 1),
                (tint.opacity(dark ? 0.28 : 0.04), 2, 1)
            ]
        case .raised:
            return [
                (tint.opacity(dark ? 0.48 : 0.10), 8, 3),
                (tint.opacity(dark ? 0.32 : 0.06), 3, 1)
            ]
        case .floating:
            return [
                (tint.opacity(dark ? 0.56 : 0.12), 24, 8),
                (tint.opacity(dark ? 0.40 : 0.08), 6, 2)
            ]
        }
    }
}

public extension View {
    /// Reads the environment's colour scheme so a caller never has to pass the
    /// mode in — a shadow that ignores dark mode is the failure this replaced.
    func quickFiElevation(_ level: QuickFiElevation) -> some View {
        modifier(QuickFiElevationModifier(level: level))
    }
}

private struct QuickFiElevationModifier: ViewModifier {
    let level: QuickFiElevation
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        level.shadows(dark: colorScheme == .dark).reduce(AnyView(content)) { view, s in
            AnyView(view.shadow(color: s.color, radius: s.radius, x: 0, y: s.y))
        }
    }
}

// MARK: - Motion

public enum QuickFiMotion {
    /// Press feedback, color, opacity. The site's only duration.
    public static let fast: Double = 0.15
    /// Sheets, expand/collapse.
    public static let base: Double = 0.25
    /// Screen transitions.
    public static let slow: Double = 0.35

    /// The credit-line brand swap. Equal to `slow` today but named separately
    /// because it is a cross-platform contract value, not a local animation
    /// choice: `tokens/brand-engine.md`'s app integration contract cites this
    /// token, and Android (`QuickFiMotion.BRAND_SWAP_MS`) and web
    /// (`--qf-brand-swap`) carry the same number. Moving it means moving all
    /// three.
    public static let brandSwap: Double = 0.35

    /// Reduced-motion collapse for `brandSwap`. Still a fade, never a hard cut
    /// — a cut reads as a rendering error rather than a transition. Same value
    /// on all three platforms.
    public static let brandSwapReduced: Double = 0.10

    public static let standard   = Animation.timingCurve(0.4, 0, 0.2, 1, duration: base)
    public static let decelerate = Animation.timingCurve(0, 0, 0.2, 1, duration: base)
    public static let accelerate = Animation.timingCurve(0.4, 0, 1, 1, duration: base)

    /// Honours Reduce Motion by collapsing to a short crossfade.
    public static func respectful(
        _ animation: Animation,
        reduceMotion: Bool
    ) -> Animation {
        reduceMotion ? .easeInOut(duration: 0.10) : animation
    }
}

// MARK: - Border width

public enum QuickFiBorder {
    /// Every border in this system is 2pt — dividers, input strokes, control
    /// boundaries and the focus ring alike. A thicker boundary also makes the
    /// 3:1 non-text contrast requirement easier to perceive, not just to pass.
    public static let width: CGFloat = 2
}
