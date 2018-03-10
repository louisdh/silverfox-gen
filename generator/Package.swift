import PackageDescription

let package = Package(
	name: "SilverFox-gen",
	dependencies: [
		.Package(url: "https://github.com/vapor-community/markdown.git", majorVersion: 0, minor: 4),
		.Package(url: "https://github.com/JohnSundell/Files.git", majorVersion: 2),
		.Package(url: "https://github.com/alexaubry/HTMLString", majorVersion: 4, minor: 0)
		]
)
