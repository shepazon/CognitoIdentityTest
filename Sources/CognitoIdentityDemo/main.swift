import Foundation
import AWSCognitoIdentity
@testable import CognitoIdentityFunctions

// Output environment variables for review

extension String {
    func leftPadding(toLength: Int, withPad character: Character = " ") -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}

var env = ProcessInfo.processInfo.environment
let sortedEnv = env.sorted{$0.key < $1.key}
var awsVarCount = 0

print("Environment has \(sortedEnv.count) variables. AWS-related variables:")
for (key, value) in sortedEnv {
    if (key.contains("AWS")) {
        awsVarCount+=1
        print("    \(key.leftPadding(toLength: 36)) = \(value)")
    }
}
print("            Number of AWS variables: \(awsVarCount)")

print("Creating the identity test object...")

let identityTester: CognitoIdentityFunctions

do {
    identityTester = try CognitoIdentityFunctions()
} catch {
    dump(error, name: "Error creating identity test object")
    exit(1)
}

// Get the ID of the identity pool, creating it if necesssary

print("Now trying to create a new identity pool called \"SuperSpecialPool\"...")
var poolID = identityTester.getIdentityPoolID(name: "SuperSpecialPool", createIfMissing: true)

if (poolID == nil) {
    print("*** Unable to find or create SuperSpecialPool!")
} else {
    print("*** Found or created SuperSpecialPool with ID \(poolID!)")
}
