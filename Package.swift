// swift-tools-version:5.9
//
//  QuickFi Design System — iOS distribution.
//
//  This manifest is copied verbatim to the root of the public mirror repo by
//  scripts/build-dist.js, which is also what puts platforms/ios/*.swift under
//  Sources/QuickFiDesignSystem/ beside it. It does not sit at the root of this
//  repo on purpose: the private repo is not resolvable by SwiftPM, and the
//  files it names live in platforms/ios/, which stays the single source the
//  generators write and scripts/validate.js audits.
//
//  Minimum is iOS 16, not 15: QuickFiTextStyle's modifier calls View.tracking,
//  which Apple introduced in iOS 16. Lowering it fails to compile rather than
//  degrading.
//
import PackageDescription

let package = Package(
    name: "QuickFiDesignSystem",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "QuickFiDesignSystem",
            targets: ["QuickFiDesignSystem"]
        )
    ],
    targets: [
        .target(
            name: "QuickFiDesignSystem",
            // Work Sans, four weights. Bundling them is what lets a consuming
            // app take the dependency and set up no fonts of its own — see
            // QuickFiFont.registerBundledFonts().
            resources: [.process("Resources")]
        )
    ]
)
