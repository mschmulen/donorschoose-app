// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

/*
fastlane [lane] key:value key2:value2

fastlane deploy submit:false build_number:24


func deployLane(withOptions options:[String: String]?) {
 ...

*/
import Foundation

class Fastfile: LaneFile {

	func testLane() {
    	buildIosApp(scheme: "donorsChoose")
	}

	func helper() {
    	// This is not a lane but can be called from a lane
	}
	
	func screenshotsLane() {
		desc("Generate new localized screenshots")
		captureScreenshots(workspace: "donorsChoose.xcworkspace", scheme: "donorsChoose")
	}
	
	/*
	func betaLane() {
	    desc("Submit a new Beta Build to Apple TestFlight. This will also make sure the profile is up to date")

	    syncCodeSigning(gitUrl: "URL/for/your/git/repo", appIdentifier: [appIdentifier], username: appleID)
	    // Build your app - more options available
	    buildIosApp(scheme: "SchemeName")
	    uploadToTestflight(username: appleID)
	    // You can also use other beta testing services here (run `fastlane actions`)
	}
	*/
	
	/*
	func deployLane(withOptions options:[String: String]?) {
        // ...
        if let submit = options?["submit"], submit == "true" {
            // Only when submit is true
        }
        // ...
        incrementBuildNumber(buildNumber: options?["build_number"])
        // ...
    }
	*/
	
	
	
}
