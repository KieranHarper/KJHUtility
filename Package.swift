import PackageDescription

let package = Package(
    name: "KJHUtility",
    dependencies: [
        .Package(url: "https://github.com/Quick/Quick.git", majorVersion: 1),
	    .Package(url: "https://github.com/Quick/Nimble.git", majorVersion: 6)
    ]
)