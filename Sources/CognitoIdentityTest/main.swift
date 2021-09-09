import Foundation
import CognitoIdentity

let cognitoIdentityClient = try CognitoIdentityClient()

/// Returns the ID of the identity pool with the specified name.
/// - Parameters:
///   - name: The name of the identity pool whose ID should be returned
///   - createIfMissing: If `true`, the identity pool will be created if not found
/// - Returns: A string containing the ID of the specified identity pool or `nil` on error or if not found
func getIdentityPoolID(name: String, createIfMissing: Bool = false) -> String? {
    var token: String? = nil
    var listPoolsInput: ListIdentityPoolsInput;
    var poolID: String? = nil
    
    // See if the pool already exists
    
    repeat {
        if (token == nil) {
            listPoolsInput = ListIdentityPoolsInput(maxResults: 25)
        } else {
            listPoolsInput = ListIdentityPoolsInput(maxResults: 25, nextToken: token)
        }
        
        cognitoIdentityClient.listIdentityPools(input: listPoolsInput) { (result) in
            switch(result) {
            case .success(let output):
                for pool in output.identityPools! {
                    if (pool.identityPoolName == name) {
                        poolID = pool.identityPoolId!;
                        break
                    }
                }
                token = output.nextToken
            case .failure(let error):
                print("ERROR: ", dump(error, name: "ERROR DETAILS"))
            }
        }
    } while(token != nil)

    // If needed, create the pool
    
    if (poolID == nil && createIfMissing) {
        let cognitoInputCall = CreateIdentityPoolInput(allowClassicFlow: nil, allowUnauthenticatedIdentities: true, cognitoIdentityProviders: nil, developerProviderName: "com.amazon.CognitoIdentityTest", identityPoolName: name, identityPoolTags: nil, openIdConnectProviderARNs: nil, samlProviderARNs: nil, supportedLoginProviders: nil)

        cognitoIdentityClient.createIdentityPool(input: cognitoInputCall) { (result) in
            switch(result) {
            case .success(let output):
                poolID = output.identityPoolId;
            case .failure(let error):
                print("ERROR: ", dump(error, name: "ERROR DETAILS"))
            }
        }
    }
    return poolID
}

// Test: Does this correctly sense when a pool doesn't exist?

var poolID = getIdentityPoolID(name: "ThisPoolDoesntExist")

if (poolID == nil) {
    print("*** Confirmed that the fake pool name doesn't match a pool")
} else {
    print("*** Uh-oh, the fake pool exists with ID \(poolID!)")
}

// Test: Create the pool if missing

print("Now trying to create a new identity pool called \"SuperSpecialPool\"...")
poolID = getIdentityPoolID(name: "SuperSpecialPool", createIfMissing: true)

if (poolID == nil) {
    print("*** Unable to find or create SuperSpecialPool!")
} else {
    print("*** Found or created SuperSpecialPool with ID \(poolID!)")
}
