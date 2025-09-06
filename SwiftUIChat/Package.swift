// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIChat",
	platforms: [
		.iOS(.v15)
	],
	products: [
		.library(
			name: "SwiftUIChat",
			targets: ["SwiftUIChat"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/siteline/swiftui-introspect", from: "1.4.0-beta.4")
	],
	targets: [
		.target(
			name: "SwiftUIChat",
			dependencies: [
				.product(name: "SwiftUIIntrospect", package: "SwiftUI-Introspect")
			],
			path: "Sources/SwiftUIChat"
		),
		.testTarget(
			name: "SwiftUIChatTests",
			dependencies: ["SwiftUIChat"],
			path: "Tests/SwiftUIChatTests"
		)
	]
)
