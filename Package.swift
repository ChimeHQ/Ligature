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
		.package(url: "https://github.com/ChimeHQ/Glyph", branch: "main"),
		.package(url: "https://github.com/ChimeHQ/Rearrange", branch: "main"),
	],
	targets: [
		.target(name: "Ligature", dependencies: ["Glyph", "Rearrange"]),
		.testTarget(name: "LigatureTests", dependencies: ["Ligature"]),
	]
)
