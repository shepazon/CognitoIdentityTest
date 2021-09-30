import Foundation
import AWSCognitoIdentity
@testable import CognitoIdentityFunctions

let identityTester: CognitoIdentityFunctions

// Instantiate the main identity functions object
do {
    identityTester = try CognitoIdentityFunctions()
} catch {
    dump(error, name: "Error creating identity test object")
    exit(1)
}

// Get the ID of the identity pool, creating it if necesssary

var poolID = identityTester.getIdentityPoolID(name: "SuperSpecialPool", createIfMissing: true)

if (poolID == nil) {
    print("*** Unable to find or create SuperSpecialPool!")
} else {
    print("*** Found or created SuperSpecialPool with ID \(poolID!)")
}
