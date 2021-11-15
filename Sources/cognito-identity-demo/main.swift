import Foundation
import AWSCognitoIdentity
@testable import CognitoIdentityDemo


let identityDemo: CognitoIdentityDemo

// Instantiate the main identity functions object

do {
    identityDemo = try CognitoIdentityDemo()
} catch {
    dump(error, name: "Error creating identity test object")
    exit(1)
}

// Get the ID of the identity pool, creating it if necesssary

let poolID = identityDemo.getIdentityPoolID(name: "SuperSpecialPool", createIfMissing: true)

if (poolID == nil) {
    print("*** Unable to find or create SuperSpecialPool!")
} else {
    print("*** Found or created SuperSpecialPool with ID \(poolID!)")
}
