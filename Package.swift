import PackageDescription

let package = Package(
    name: "Sorbetto",
    dependencies: [
        .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 7),
    ]
)
