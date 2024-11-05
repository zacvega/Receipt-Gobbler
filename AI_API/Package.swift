// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "experiments",
    dependencies: [
        // Add AnyCodable as a dependency
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.0"),
    ],
    targets: [
        // Define the target with explicit product dependencies
        .executableTarget(
            name: "experiments",
            dependencies: [
                // Specify AnyCodable as a dependency for the experiments target
                .product(name: "AnyCodable", package: "AnyCodable"),
            ]
        ),
    ]
)

