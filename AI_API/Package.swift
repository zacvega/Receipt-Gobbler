// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "experiments",
    targets: [
        // Define the target with explicit product dependencies
        .executableTarget(
            name: "experiments"
        ),
    ]
)

