// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cognito-identity-demo",
    platforms: [
        .macOS(.v12), //this needs to change to v11 once async is merged FYI
        .iOS(.v13)
    ],
    products: [
      .library(name: "CognitoIdentityHandler", targets: ["CognitoIdentityHandler"]),
      .executable(name: "CognitoIdentityDemo", targets: ["cognito-identity-demo"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            name: "AWSSwiftSDK",
            url: "https://github.com/awslabs/aws-sdk-swift",
            from: "0.1.1"
        )
    ],
    targets: [
        // A library target containing the demo's classes
        .target(
            name: "CognitoIdentityHandler",
            dependencies: [
                .product(name: "AWSCognitoIdentity", package: "AWSSwiftSDK"),
            ],
            path: "./Sources/CognitoIdentityHandler"
        ),
        // The target of the tests
        .testTarget(
            name: "CognitoIdentityHandlerTests",
            dependencies: [
                "cognito-identity-demo",
                .product(name: "AWSCognitoIdentity", package: "AWSSwiftSDK"),
            ],
            path: "./Tests/CognitoIdentityHandlerTests"
        ),
        // The target of the main executable program
        .executableTarget(
            name: "cognito-identity-demo",
            dependencies: [
                "CognitoIdentityHandler"
            ],
            path: "./Sources/cognito-identity-demo"
        ),
    ]
)
