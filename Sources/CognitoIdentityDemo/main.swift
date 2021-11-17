import Foundation
import AWSCognitoIdentity
@testable import CognitoIdentityFunctions


// Instantiate the main identity functions object
do {
    let identityTester = try CognitoIdentityFunctions()
    // Get the ID of the identity pool, creating it if necesssary

    identityTester.getIdentityPoolID(name: "SuperSpecialPool") { poolID in
        guard let poolID = poolID else {
            print("*** Unable to find or create SuperSpecialPool!")
            return
        }
        print("*** Found or created SuperSpecialPool with ID \(poolID)")
    }
} catch {
    dump(error, name: "Error creating identity test object")
    exit(1)
}


