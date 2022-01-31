import XCTest
import class Foundation.Bundle
@testable import CognitoIdentityDemo

/// Class based on `XCTestCase` that's run to perform testing of the project code.
final class CognitoIdentityDemoTests: XCTestCase {
    var identityTester: CognitoIdentityDemo? = nil
    
    /// Perform setup work needed by all tests.
    override func setUp() {
        identityTester = CognitoIdentityDemo()
    }
    
    /// **Test:** Attempt to find an identity pool that doesn't exist. If no error occurs, the test
    /// fails.
    func testFindNonexistent() {
        Task() {
            do {
                let poolID = try await identityTester?.getIdentityPoolID(name: "BogusPoolIsBogus")
                XCTAssertNil(poolID, "Found identity pool that does not exist")
            } catch {
                print("ERROR: ", dump(error, name: "Finding identity pool that doesn't exist"))
            }
        }
    }
    
    /// **Test:** Create (or locate, if it already exists) an identity pool. Then try to find it
    /// a second time.. Make sure the returned IDs match. If not, the test fails.
    func testCreateThenFind() {
        Task() {
            do {
                let firstPoolID = try await identityTester!.getIdentityPoolID(name: "testCreateThenFind")
                XCTAssertNotNil(firstPoolID, "Unable to create or obtain test pool")
                
                let secondPoolID = try await identityTester?.createIdentityPool(name: "testCreateThenFind")
                XCTAssertNotNil(secondPoolID, "Unable to find test pool")
                XCTAssertTrue(firstPoolID == secondPoolID, "Found pool ID doesn't match created pool ID")
            } catch {
                print("ERROR: ", dump(error, name: "Find/create of identity pool"))
            }
        }
    }
}
