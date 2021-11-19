//
//  CognitoIdentityTest.swift
//  
//
//  Created by Shepherd, Eric on 9/9/21.
//

import Foundation
import ClientRuntime
import AWSClientRuntime
import AWSCognitoIdentity

/// A class containing all the code that interacts with the AWS SDK for Swift.
class CognitoIdentityDemo {
    let cognitoIdentityClient: CognitoIdentityClient
    
    /// Initialize and return a new ``CognitoIdentityDemo`` object, which is used to drive the AWS calls
    /// used for the example.
    /// - Returns: A new ``CognitoIdentityDemo`` object, ready to run the demo code.
    init() throws {
        SDKLoggingSystem.add(logHandlerFactory: CognitoIdentityClientLogHandlerFactory(logLevel: .info))
        cognitoIdentityClient = try CognitoIdentityClient()
    }
    
    /// Returns the ID of the identity pool with the specified name.
    /// - Parameters:
    ///   - name: The name of the identity pool whose ID should be returned
    /// - Returns: A string containing the ID of the specified identity pool or `nil` on error or if not found
    func getIdentityPoolID(name: String, completion: @escaping (String?) -> Void) {
        var token: String? = nil
        var poolID: String? = nil

        // Iterate over the identity pools until a match is found.
        repeat {

            /// `token` is a value returned by `ListIdentityPools()` if the returned list
            /// of identity pools is only a partial list. You use the `token` to tell Cognito that
            /// you want to continue where you left off previously; specifying `nil` or not providing
            /// it means "start at the beginning."
            
            let listPoolsInput = ListIdentityPoolsInput(maxResults: 25, nextToken: token)
            
            /// Read pages of identity pools from Cognito until one is found
            /// whose name matches the one specified in the `name` parameter.
            /// Return the matching pool's ID. Each time we ask for the next
            /// page of identity pools, we pass in the token given by the
            /// previous page.
            
            cognitoIdentityClient.listIdentityPools(input: listPoolsInput) { (result) in
                switch(result) {
                case .success(let output):
                    if let identityPools = output.identityPools {
                        for pool in identityPools {
                            if pool.identityPoolName == name,
                               let id = pool.identityPoolId {
                                poolID = id
                                break
                            }
                        }
                    }
                    
                    token = output.nextToken
                case .failure(let error):
                    print("ERROR: ", dump(error, name: "Error scanning identity pools"))
                    token = nil
                }
            }
        } while token != nil && poolID == nil
        
        completion(poolID)
    }
    
    /// Returns the ID of the identity pool with the specified name.
    /// - Parameters:
    ///   - name: The name of the identity pool whose ID should be returned
    /// - Returns: A string containing the ID of the specified identity pool or `nil` on error or if not found
    func getIdentityPoolID(name: String, createIfMissing: Bool = false,
                           completion: @escaping (String?) -> Void) {
        // See if the pool already exists
        
        self.getIdentityPoolID(name: name) { foundID in
            if let foundID = foundID {
                completion(foundID)
            } else if createIfMissing {
                self.createIdentityPool(name: name, completion: completion)
            } else {
                completion(nil)
            }
        }
}
    
    /// Create a new identity pool, returning its ID.
    /// - Parameters:
    ///     - name: The name to give the new identity pool
    /// - Returns: A string containing the newly created pool's ID, or `nil` if an error occurred
    func createIdentityPool(name: String, completion: @escaping (String?) -> Void) {
        let cognitoInputCall = CreateIdentityPoolInput(
            developerProviderName: "com.exampleco.CognitoIdentityDemo",
            identityPoolName: name
        )
        
        cognitoIdentityClient.createIdentityPool(input: cognitoInputCall) { result in
            switch(result) {
            case .success(let output):
                if let poolID = output.identityPoolId {
                    completion(poolID)
                }
            case .failure(let error):
                print("ERROR: ", dump(error, name: "Error attempting to create the identity pool"))
                completion(nil)
            }
        }
    }
}

