import PackageDescription

let package = Package(
	name: "SilverFox-gen",
	dependencies: [
		.Package(url: "https://github.com/vapor-community/markdown.git", majorVersion: 0, minor: 3),
		.Package(url: "https://github.com/JohnSundell/Files.git", majorVersion: 1, minor: 8)
		]
)
