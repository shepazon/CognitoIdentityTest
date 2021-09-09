// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CognitoIdentityTest",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "AWSSwiftSDK", url: "https://github.com/awslabs/aws-sdk-swift", from: "0.0.1"),
    ],
    targets: [
        // The target of the main executable program
        .executableTarget(
            name: "CognitoIdentityTest",
            dependencies: [
                .product(name: "CognitoIdentity", package: "AWSSwiftSDK"),
            ]
        ),
        // The target of the tests
        .testTarget(
            name: "CognitoIdentityTestTests",
            dependencies: ["CognitoIdentityTest"]),
    ]
)
