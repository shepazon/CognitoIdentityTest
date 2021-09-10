//
//  CognitoIdentityTest.swift
//  
//
//  Created by Shepherd, Eric on 9/9/21.
//

import Foundation
import CognitoIdentity

class CognitoIdentityDemo {
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

