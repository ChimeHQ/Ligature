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
		.package(url: "https://github.com/ChimeHQ/Glyph", revision: "63cc672cd1bcc408b3a5158816985c82308e5f83"),
	],
	targets: [
		.target(name: "Ligature", dependencies: ["Glyph"]),
		.testTarget(name: "LigatureTests", dependencies: ["Ligature"]),
	]
)
