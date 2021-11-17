// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cognito-identity-demo",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            name: "AWSSwiftSDK",
            url: "https://github.com/awslabs/aws-sdk-swift",
            from: "0.0.16"
        )
    ],
    targets: [
        // The target of the main executable program
        .executableTarget(
            name: "cognito-identity-demo",
            dependencies: [
                "CognitoIdentityDemo",
                .product(name: "AWSCognitoIdentity", package: "AWSSwiftSDK"),
            ]
        ),
        // A library target containing the demo's classes
        .target(
            name: "CognitoIdentityDemo",
            dependencies: [
                .product(name: "AWSCognitoIdentity", package: "AWSSwiftSDK"),
            ]
        ),
        // The target of the tests
        .testTarget(
            name: "CognitoIdentityDemoTests",
            dependencies: [
                "cognito-identity-demo",
                .product(name: "AWSCognitoIdentity", package: "AWSSwiftSDK"),
            ]
        ),
    ]
)
