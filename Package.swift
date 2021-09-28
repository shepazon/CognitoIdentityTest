// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CognitoIdentityDemo",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
 /*   products: [
        .library(
            name: "CognitoIdentityFunctions",
            targets: [
                "CognitoIdentityDemo",
                "CognitoIdentityDemoTests"
            ]
        )
    ], */
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            name: "AWSSwiftSDK",
            url: "https://github.com/awslabs/aws-sdk-swift",
            from: "0.0.9"
        ),
    ],
    targets: [
        // The target of the main executable program
        .executableTarget(
            name: "CognitoIdentityDemo",
            dependencies: [
                "CognitoIdentityFunctions",
                .product(name: "AWSCognitoIdentity", package: "AWSSwiftSDK"),
            ]
        ),
        // A library target containing the demo's classes
        .target(
            name: "CognitoIdentityFunctions",
            dependencies: [
                .product(name: "AWSCognitoIdentity", package: "AWSSwiftSDK"),
            ]
        ),
        // The target of the tests
        .testTarget(
            name: "CognitoIdentityDemoTests",
            dependencies: [
                "CognitoIdentityDemo",
                .product(name: "AWSCognitoIdentity", package: "AWSSwiftSDK"),
            ]
        ),
    ]
)
