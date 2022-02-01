import Foundation
import CognitoIdentityHandler

// Instantiate the main identity functions object

@main
struct DemoApp {
    static func main() async {
        
        let identityDemo = CognitoIdentityHandler()
        print("Got identity client")
        // Get the ID of the identity pool, creating it if necesssary

        do {
            print("Calling getOrCreateIdentityPoolID")
            guard let poolID = try await identityDemo.getOrCreateIdentityPoolID(name: "SuperSpecialPool") else {
                print("*** Unable to find or create SuperSpecialPool!")
                exit(1)
            }

            print("*** Found or created SuperSpecialPool with ID \(poolID)")
        } catch {
            dump(error, name: "Getting identity pool ID from main program")
        }
    }
}
