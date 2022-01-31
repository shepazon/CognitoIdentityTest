//
//  CognitoIdentityTest.swift
//  
//
//  Created by Shepherd, Eric on 9/9/21.
//

import Foundation
import AWSCognitoIdentity
import ClientRuntime

/// A class containing all the code that interacts with the AWS SDK for Swift.
class CognitoIdentityDemo {
    let cognitoIdentityClient: CognitoIdentityClient
    
    /// Initialize and return a new ``CognitoIdentityDemo`` object, which is used to drive the AWS calls
    /// used for the example.
    /// - Returns: A new ``CognitoIdentityDemo`` object, ready to run the demo code.
    init() {
        SDKLoggingSystem.add(logHandlerFactory: CognitoIdentityClientLogHandlerFactory(logLevel: .info))
        
        do {
            cognitoIdentityClient = try CognitoIdentityClient()
        } catch {
            print("ERROR: ", dump(error, name: "Initializing CognitoIdentityClient"))
            exit(1)
        }
    }
    
    /// Returns the ID of the identity pool with the specified name.
    /// - Parameters:
    ///   - name: The name of the identity pool whose ID should be returned
    /// - Returns: A string containing the ID of the specified identity pool or `nil` on error or if not found
    func getIdentityPoolID(name: String) async throws -> String? {
        var token: String? = nil
        
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
            
            do {
                let output = try await cognitoIdentityClient.listIdentityPools(input: listPoolsInput)

                if let identityPools = output.identityPools {
                    for pool in identityPools {
                        if pool.identityPoolName == name {
                            return pool.identityPoolId!
                        }
                    }
                }
                
                token = output.nextToken
            } catch {
                print("ERROR: ", dump(error, name: "Trying to get list of identity pools"))
            }
//            switch(result) {
//            case .success(let output):
//                if let identityPools = output.identityPools {
//                    for pool in identityPools {
//                        if pool.identityPoolName == name,
//                           let poolId = pool.identityPoolId {
//                            completion(poolId)
//                            break
//                        }
//                    }
//                }
//
//                token = output.nextToken
//            case .failure(let error):
//                completion(nil)
//                print("ERROR: ", dump(error, name: "Error scanning identity pools"))
//            }
        } while token != nil
        
        return nil
    }
    
    /// Returns the ID of the identity pool with the specified name.
    /// - Parameters:
    ///   - name: The name of the identity pool whose ID should be returned
    /// - Returns: A string containing the ID of the specified identity pool or `nil` on error or if not found
    func getOrCreateIdentityPoolID(name: String) async throws -> String? {
        // See if the pool already exists
        
        do {
            let poolId = try await self.getIdentityPoolID(name: name)
            if let poolId = poolId {
                return poolId
            } else {
                let poolId = try await self.createIdentityPool(name: name)
                return poolId
            }
        } catch {
            print("ERROR: ", dump(error, name: "Trying to get the identity pool ID"))
            return nil
        }
    }
    
    /// Create a new identity pool, returning its ID.
    /// - Parameters:
    ///     - name: The name to give the new identity pool
    /// - Returns: A string containing the newly created pool's ID, or `nil` if an error occurred
    func createIdentityPool(name: String) async throws -> String? {
        
        let cognitoInputCall = CreateIdentityPoolInput(
            developerProviderName: "com.exampleco.CognitoIdentityDemo",
            identityPoolName: name
        )
        
        do {
            let result = try await cognitoIdentityClient.createIdentityPool(input: cognitoInputCall)
            if let poolId = result.identityPoolId {
                return poolId
            }
        } catch {
            print("ERROR: ", dump(error, name: "Error attempting to create the identity pool"))
        }
        
        return nil
    }
}

