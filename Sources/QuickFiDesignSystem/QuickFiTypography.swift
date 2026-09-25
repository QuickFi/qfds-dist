//
//  QuickFiTypography.swift
//  QuickFi Design System — hand-written. Metrics are checked against
//  tokens/values.json by scripts/validate.js; there is no generator yet.
//
//  Work Sans for both display and body — a single-family system. Carried over from
//  quickfi.ai. Every style scales with Dynamic Type via `relativeTo:`.
//
//  Setup:
//    Nothing, when this is consumed as the QuickFiDesignSystem Swift package —
//    the four faces ship inside it and register themselves the first time a
//    style resolves a font. See QuickFiFont.registerBundledFonts().
//
//    If these files were instead copied into an app target by hand, that app
//    must add the .ttf files itself and list each filename under "Fonts
//    provided by application" (UIAppFonts) in Info.plist, then verify the
//    PostScript names below with QuickFiFont.debugDumpNames() — they are what
//    the file declares internally, not the filename, and vendors are
//    inconsistent about them.
//
//  Usage, SwiftUI:
//    Text("Monthly payment").quickFiText(.label)
//    Text(amount).quickFiText(.numericLg)       // tabular figures applied
//
//  Usage, UIKit — same styles, UIFont-typed:
//    label.font = QuickFiTextStyle.label.uiFont
//    label.attributedText = NSAttributedString(string: amount,
//        attributes: QuickFiTextStyle.numericLg.attributes)   // font + kern + line spacing
//

import SwiftUI
import UIKit
import CoreText

// MARK: - Font families

public enum QuickFiFont {

    /// PostScript names. Verify against `debugDumpNames()` before shipping.
    public enum Display {
        public static let regular  = "WorkSans-Regular"
        public static let medium   = "WorkSans-Medium"
        public static let semiBold = "WorkSans-SemiBold"
        public static let bold     = "WorkSans-Bold"
    }

    public enum Body {
        public static let regular  = "WorkSans-Regular"
        public static let medium   = "WorkSans-Medium"
        public static let semiBold = "WorkSans-SemiBold"
        public static let bold     = "WorkSans-Bold"
        // Same family as Display. Kept as a separate enum so a future second
        // face is a one-line change here rather than a call-site sweep.
    }

    /// Registers the Work Sans faces bundled with the Swift package, once.
    ///
    /// Every style resolves through here before it builds a Font, so an app
    /// taking the package as a dependency sets up no fonts of its own and
    /// touches no Info.plist — the same deal the Android module already gives
    /// (its faces live in sdk/android/src/main/res/font).
    ///
    /// The Bundle.module reference is guarded by SWIFT_PACKAGE, which SwiftPM
    /// defines and a plain app target does not. That keeps this file compilable
    /// for anyone still copying it into a target by hand, where the app supplies
    /// the fonts through UIAppFonts and this is a no-op.
    public static func registerBundledFonts() {
        _ = bundledFontsRegistered
    }

    private static let bundledFontsRegistered: Bool = {
        #if SWIFT_PACKAGE
        for name in ["WorkSans-Regular", "WorkSans-Medium", "WorkSans-SemiBold", "WorkSans-Bold"] {
            guard let url = Bundle.module.url(forResource: name, withExtension: "ttf"),
                  let data = try? Data(contentsOf: url),
                  let provider = CGDataProvider(data: data as CFData),
                  let font = CGFont(provider) else { continue }
            // A duplicate registration is expected and harmless: it happens when
            // the host app ALSO bundles Work Sans through UIAppFonts. Errors are
            // dropped rather than raised, because a missing face degrades to the
            // system font and a crash here would be worse than that.
            CTFontManagerRegisterGraphicsFont(font, nil)
        }
        #endif
        return true
    }()

    /// Prints every registered family and its font names. Call once from a
    /// debug build to confirm the names above resolve.
    public static func debugDumpNames() {
        #if DEBUG
        for family in UIFont.familyNames.sorted() {
            print("Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family).sorted() {
                print("   \(name)")
            }
        }
        #endif
    }
}

// MARK: - Text style

public struct QuickFiTextStyle {
    public let fontName: String
    public let size: CGFloat
    public let lineHeight: CGFloat
    public let tracking: CGFloat
    public let relativeTo: Font.TextStyle
    public let uppercase: Bool
    public let tabularFigures: Bool

    public init(
        fontName: String,
        size: CGFloat,
        lineHeight: CGFloat,
        tracking: CGFloat = 0,
        relativeTo: Font.TextStyle,
        uppercase: Bool = false,
        tabularFigures: Bool = false
    ) {
        self.fontName = fontName
        self.size = size
        self.lineHeight = lineHeight
        self.tracking = tracking
        self.relativeTo = relativeTo
        self.uppercase = uppercase
        self.tabularFigures = tabularFigures
    }

    public var font: Font {
        QuickFiFont.registerBundledFonts()
        let base = Font.custom(fontName, size: size, relativeTo: relativeTo)
        return tabularFigures ? base.monospacedDigit() : base
    }

    /// SwiftUI treats leading as extra space *between* lines, not as total line
    /// height, so the font's own line height has to come out of the figure.
    /// Measured from real font metrics rather than a 1.2 approximation — with a
    /// 4pt grid, a guess here is exactly what knocks text off it.
    ///
    /// Caveat: this is computed at the base size. Under Dynamic Type the glyphs
    /// scale but this leading does not, so line height drifts above 100%. That
    /// is intended — clamping it would clip ascenders at large sizes.
    public var lineSpacing: CGFloat {
        max(0, lineHeight - baseUIFont.lineHeight)
    }

    // MARK: UIKit

    /// UIKit counterpart of `font`: the same face, tabular figures when the
    /// style asks for them, scaled by Dynamic Type through `UIFontMetrics`
    /// for the text style `relativeTo` names.
    public var uiFont: UIFont {
        var base = baseUIFont
        if tabularFigures {
            let descriptor = base.fontDescriptor.addingAttributes([.featureSettings: [[
                UIFontDescriptor.FeatureKey.type: kNumberSpacingType,
                UIFontDescriptor.FeatureKey.selector: kMonospacedNumbersSelector,
            ]]])
            base = UIFont(descriptor: descriptor, size: 0)
        }
        return UIFontMetrics(forTextStyle: uiTextStyle).scaledFont(for: base)
    }

    /// Attributes for an `NSAttributedString`: `uiFont`, tracking as kern, and
    /// a paragraph style carrying `lineSpacing` — the same extra-leading model
    /// the SwiftUI modifier uses, so both frameworks set the same line height
    /// and drift the same way under Dynamic Type. `uppercase` is not an
    /// attribute; apply `.uppercased()` to the string.
    public var attributes: [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = lineSpacing
        return [.font: uiFont, .kern: tracking, .paragraphStyle: paragraph]
    }

    /// The face at its base size, unscaled. Registers the bundled fonts first,
    /// so no caller has to.
    private var baseUIFont: UIFont {
        QuickFiFont.registerBundledFonts()
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    private var uiTextStyle: UIFont.TextStyle {
        switch relativeTo {
        case .largeTitle:  return .largeTitle
        case .title:       return .title1
        case .title2:      return .title2
        case .title3:      return .title3
        case .headline:    return .headline
        case .subheadline: return .subheadline
        case .body:        return .body
        case .callout:     return .callout
        case .footnote:    return .footnote
        case .caption:     return .caption1
        case .caption2:    return .caption2
        default:           return .body  // extraLargeTitle (iOS 17) and anything Apple adds later
        }
    }
}

// MARK: - Scale
//
// THIRTEEN roles on mobile. display and numericXxl are web-only — both were
// 28pt here, identical to each other, and still small next to Apple's real
// Large Title (34pt): a phone screen had two redundant names for one size and
// still no genuine hero-scale type. title (22pt) is mobile's ceiling now; a
// screen's job is done by title plus a numeric amount, not a headline
// treatment inherited from web marketing pages. Also dropped, earlier:
// displayMedium, displaySmall, titleLarge, bodyStrong — all of them collapsed
// onto a neighbour in practice.
//
// Metrics follow Apple's ladder, so line heights are deliberately off a 4pt
// grid — that is what keeps text flush with nav bars and system controls.
// `relativeTo:` is required, not decorative: drop it and Dynamic Type stops.
//
// The numeric ladder is a five-step scale of its own — xs 10 / sm 12 / md 14 /
// lg 16 / xl 20, plus the web-only xxl 32 — and its point sizes are identical
// to Android's at every rung on purpose. An amount is the one thing a customer
// reads off both apps and compares; a figure a point larger on one platform
// reads as a different number's worth of emphasis. Only the line heights
// diverge, because Android is on a 4pt grid and this ladder is not.
//
// numericXs at 10pt sits below Apple's smallest text style (Caption 2, 11).
// Tabular numerals clear that floor; prose does not. Never set words there.

public extension QuickFiTextStyle {

    /// 22/28 · Apple Title 2. Screen title below the nav bar, and section headings.
    static let title = QuickFiTextStyle(
        fontName: QuickFiFont.Display.semiBold,
        size: 22, lineHeight: 28, tracking: -0.2, relativeTo: .title2)
    /// 17/22 · Apple Headline. Emphasised short text: button labels, field labels, list row primary, nav bar title, inline emphasis.
    static let label = QuickFiTextStyle(
        fontName: QuickFiFont.Body.semiBold,
        size: 17, lineHeight: 22, relativeTo: .headline)
    /// 17/22 · Apple Body. Default reading size. Most text in the app is this.
    static let body = QuickFiTextStyle(
        fontName: QuickFiFont.Body.regular,
        size: 17, lineHeight: 22, relativeTo: .body)
    /// 15/20 · Apple Subheadline. Secondary lines, list row detail, supporting copy.
    static let bodySmall = QuickFiTextStyle(
        fontName: QuickFiFont.Body.regular,
        size: 15, lineHeight: 20, relativeTo: .subheadline)
    /// 13/18 · Apple Footnote. Metadata, helper text, timestamps.
    static let caption = QuickFiTextStyle(
        fontName: QuickFiFont.Body.regular,
        size: 13, lineHeight: 18, relativeTo: .footnote)
    /// 11/13 · Apple Caption 2. Section eyebrow above a heading. Uppercase, sparingly.
    static let overline = QuickFiTextStyle(
        fontName: QuickFiFont.Body.semiBold,
        size: 11, lineHeight: 13, tracking: 1.1,
        relativeTo: .caption2, uppercase: true)
    /// 15/20 · Apple Subheadline metrics, emphasised. The label ON a compact control: a chip, a segmented control, a toolbar action.
    static let controlLabel = QuickFiTextStyle(
        fontName: QuickFiFont.Body.semiBold,
        size: 15, lineHeight: 20, relativeTo: .subheadline)
    /// 12/16 · Apple Caption 1 metrics, emphasised. The label under a tab or nav bar item, and any label at the smallest emphasised size.
    static let tabLabel = QuickFiTextStyle(
        fontName: QuickFiFont.Body.semiBold,
        size: 12, lineHeight: 16, relativeTo: .caption)
    /// 20/25 · Apple Title 3 metrics. Amortization cells, inline currency — the assertive figure inside a card. Tabular figures.
    static let numericXl = QuickFiTextStyle(
        fontName: QuickFiFont.Display.semiBold,
        size: 20, lineHeight: 25,
        relativeTo: .title3, tabularFigures: true)
    /// 16/21 · Apple Callout metrics. Row and card primary amounts at reading size — sits level with label and body, so an amount can share a line with words without out-shouting them. Tabular figures.
    static let numericLg = QuickFiTextStyle(
        fontName: QuickFiFont.Display.semiBold,
        size: 16, lineHeight: 21,
        relativeTo: .callout, tabularFigures: true)
    /// 14/18 · Between Apple's Subheadline (15) and Footnote (13) — shared with Android and web for currency parity. Table cells, list-row trailing amounts — dense contexts where numericXl is too assertive. Tabular figures.
    static let numericMd = QuickFiTextStyle(
        fontName: QuickFiFont.Display.semiBold,
        size: 14, lineHeight: 18,
        relativeTo: .footnote, tabularFigures: true)
    /// 12/16 · Apple Caption 1 metrics. Dense tables, compact rows, and a secondary figure sitting beside a larger amount. Tabular figures.
    static let numericSm = QuickFiTextStyle(
        fontName: QuickFiFont.Display.semiBold,
        size: 12, lineHeight: 16,
        relativeTo: .caption, tabularFigures: true)
    /// 10/13 · The smallest legible figure: chart axis ticks, dense grid captions. Numerals only — never set words at this size. Tabular figures.
    static let numericXs = QuickFiTextStyle(
        fontName: QuickFiFont.Display.semiBold,
        size: 10, lineHeight: 13,
        relativeTo: .caption2, tabularFigures: true)
}

// MARK: - Modifier

private struct QuickFiTextModifier: ViewModifier {
    let style: QuickFiTextStyle

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .tracking(style.tracking)
            .lineSpacing(style.lineSpacing)
            .textCase(style.uppercase ? .uppercase : nil)
    }
}

public extension View {
    /// Applies a QuickFi text style: font, tracking, line spacing, and casing.
    func quickFiText(_ style: QuickFiTextStyle) -> some View {
        modifier(QuickFiTextModifier(style: style))
    }
}
