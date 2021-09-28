//
//  CognitoIdentityTest.swift
//  
//
//  Created by Shepherd, Eric on 9/9/21.
//

import Foundation
import AWSCognitoIdentity

class CognitoIdentityFunctions {
    var cognitoIdentityClient: CognitoIdentityClient
    
    init() throws {
        cognitoIdentityClient = try CognitoIdentityClient()
    }
        
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
            /// `token` is a value returned by `ListIdentityPools()` if the returned list
            /// of identity pools is only a partial list. You use the `token` to tell Cognito that
            /// you want to continue where you left off previously; specifying `nil` or not providing
            /// it means "start at the beginning."
            
            listPoolsInput = ListIdentityPoolsInput(maxResults: 25, nextToken: token)
            
            // Read pages of identity pools from Cognito until one is found
            // whose name matches the one specified in the `name` parameter.
            // Return the matching pool's ID. Each time we ask for the next
            // page of identity pools, we pass in the token given by the
            // previous page.
            
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
            let cognitoInputCall = CreateIdentityPoolInput(allowClassicFlow: nil, allowUnauthenticatedIdentities: true, cognitoIdentityProviders: nil, developerProviderName: "com.amazon.CognitoIdentityDemo", identityPoolName: name, identityPoolTags: nil, openIdConnectProviderARNs: nil, samlProviderARNs: nil, supportedLoginProviders: nil)

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

}

