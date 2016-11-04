import PackageDescription

let package = Package(
    name: "Sorbetto",
    dependencies: [
        .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/behrang/YamlSwift.git", majorVersion: 3, minor: 1),
    ]
)
