import XCTest
import class Foundation.Bundle
@testable import CognitoIdentityFunctions

/// Class based on `XCTestCase` that's run to perform testing of the project code.
final class CognitoIdentityDemoTests: XCTestCase {
    var identityTester: CognitoIdentityFunctions? = nil
    
    /// Perform setup work needed by all tests.
    override func setUp() {
        do {
            identityTester = try CognitoIdentityFunctions()
        } catch {
            dump(error, name: "Error during test setup")
            exit(1)
        }
    }
    
    /// **Test:** Attempt to find an identity pool that doesn't exist. If no error occurs, the test
    /// fails.
    func testFindNonexistent() {
        let poolID = identityTester?.getIdentityPoolID(name: "BogusPoolIsBogus", createIfMissing: false)
        XCTAssertNil(poolID, "Found identity pool that does not exist")
    }
    
    /// **Test:** Create (or locate, if it already exists) an identity pool. Then try to find it
    /// a second time.. Make sure the returned IDs match. If not, the test fails.
    func testCreateThenFind() {
        let firstPoolID = identityTester!.getIdentityPoolID(name: "testCreateThenFind", createIfMissing: true)
        XCTAssertNotNil(firstPoolID, "Unable to create or obtain test pool")
        
        let secondPoolID = identityTester?.getIdentityPoolID(name: "testCreateThenFind", createIfMissing: false)
        XCTAssertNotNil(secondPoolID, "Unable to find test pool")
        XCTAssertTrue(firstPoolID == secondPoolID, "Found pool ID doesn't match created pool ID")
    }
}
