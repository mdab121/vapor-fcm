import PackageDescription

let package = Package(
	name: "VaporFCM",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/DanToml/Jay.git", majorVersion: 1, minor: 0),
		.Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 5),
	]
)
