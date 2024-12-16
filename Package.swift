// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "Ligature",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.tvOS(.v13),
		.macCatalyst(.v13),
		.visionOS(.v1)
	],
	products: [
		.library(name: "Ligature", targets: ["Ligature"]),
	],
	dependencies: [
		.package(url: "https://github.com/ChimeHQ/Glyph", revision: "dce014c6ee2564c44e38c222a3fdc6eef76892d6"),
	],
	targets: [
		.target(name: "Ligature", dependencies: ["Glyph"]),
		.testTarget(name: "LigatureTests", dependencies: ["Ligature"]),
	]
)
