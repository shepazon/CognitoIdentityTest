import Foundation
import CognitoIdentity
@testable import CognitoIdentityDemo

print("Creating the identity test object...")

let identityTester: CognitoIdentityDemo

do {
    identityTester = try CognitoIdentityDemo()
} catch {
    dump(error, name: "Error creating identity test object")
    exit(1)
}

// Test: Create the pool if missing

print("Now trying to create a new identity pool called \"SuperSpecialPool\"...")
var poolID = identityTester.getIdentityPoolID(name: "SuperSpecialPool", createIfMissing: true)

if (poolID == nil) {
    print("*** Unable to find or create SuperSpecialPool!")
} else {
    print("*** Found or created SuperSpecialPool with ID \(poolID!)")
}
