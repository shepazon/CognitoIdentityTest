//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSCognitoIdentity
@testable import CognitoIdentityDemo


// Instantiate the main identity functions object

do {
    let identityDemo = try CognitoIdentityDemo()
    // Get the ID of the identity pool, creating it if necesssary

    try identityDemo.getIdentityPoolID(name: "SuperSpecialPool",
                                   createIfMissing: true) { poolID in
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


