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
		.package(url: "https://github.com/ChimeHQ/Glyph", from: "0.1.0"),
		.package(url: "https://github.com/ChimeHQ/Rearrange", from: "2.1.0"),
	],
	targets: [
		.target(name: "Ligature", dependencies: ["Glyph", "Rearrange"]),
		.testTarget(name: "LigatureTests", dependencies: ["Ligature"]),
	]
)
