import XCTest
import class Foundation.Bundle
@testable import CognitoIdentityDemo

/// Class based on `XCTestCase` that's run to perform testing of the project code.
final class CognitoIdentityDemoTests: XCTestCase {
    var identityTester: CognitoIdentityDemo? = nil
    
    /// Perform setup work needed by all tests.
    override func setUp() {
        do {
            identityTester = try CognitoIdentityDemo()
        } catch {
            dump(error, name: "Error during test setup")
            exit(1)
        }
    }
    
    /// **Test:** Attempt to find an identity pool that doesn't exist. If no error occurs, the test
    /// fails.
    func testFindNonexistent() throws {
        try identityTester?.getIdentityPoolID(name: "BogusPoolIsBogus", createIfMissing: false) { poolID in
            XCTAssertNil(poolID, "Found identity pool that does not exist")
        }
    }
    
    /// **Test:** Create (or locate, if it already exists) an identity pool. Then try to find it
    /// a second time.. Make sure the returned IDs match. If not, the test fails.
    func testCreateThenFind() throws  {
        var firstPoolID: String?
        var secondPoolID: String?
        
        try identityTester?.getIdentityPoolID(name: "testCreateThenFind", createIfMissing: true) { poolID in
            firstPoolID = poolID
            XCTAssertNotNil(firstPoolID, "Unable to create or obtain test pool")
        }
        
        try identityTester?.getIdentityPoolID(name: "testCreateThenFind", createIfMissing: false) { poolID in
            secondPoolID = poolID
            XCTAssertNotNil(secondPoolID, "Unable to find test pool")
            XCTAssertTrue(firstPoolID == secondPoolID, "Found pool ID doesn't match created pool ID")
        }
    }
}
