// swift-tools-version: 5.9

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
	targets: [
		.target(name: "Ligature"),
		.testTarget(name: "LigatureTests", dependencies: ["Ligature"]),
	]
)

let swiftSettings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency"),
	.enableUpcomingFeature("DisableOutwardActorInference"),
	.enableUpcomingFeature("IsolatedDefaultValues"),
]

for target in package.targets {
	var settings = target.swiftSettings ?? []
	settings.append(contentsOf: swiftSettings)
	target.swiftSettings = settings
}
