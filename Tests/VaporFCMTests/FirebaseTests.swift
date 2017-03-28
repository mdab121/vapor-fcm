// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

import XCTest
import Foundation
import Vapor

@testable import VaporFCM

class FirebaseTests: XCTestCase {

	let exampleServerKey = ServerKey("this-is-an-invalid-server-key")
	let exampleToken = DeviceToken("this-is-an-invalid-token")
	let message = Message(payload: Payload(text: "What's up!"))

	var sut: Firebase!
	var drop: Droplet!

	override func setUp() {
		super.setUp()
		drop = try! makeTestDroplet()
		sut = try! Firebase(drop: drop, serverKey: exampleServerKey)
	}

	override func tearDown() {
		sut = nil
		drop = nil
		super.tearDown()
	}

	/// This is not exactly a unit test, since it accesses the internet, or at least tries to use curl.
	/// I'm not checking any results (it'll still pass if there is no internet connection). It's mostly useful to see if all the api including curl are present on the system

	func testSimpleSending() throws {
		let capturedResponse: FirebaseResponse? = try? sut.send(message: message, to: exampleToken)

		XCTAssertNotNil(capturedResponse)
		XCTAssertNotNil(capturedResponse?.error)
		XCTAssertEqual(capturedResponse?.success, false)
	}

	static var allTests : [(String, (FirebaseTests) -> () throws -> Void)] {
		return [
			("testSimpleSending", testSimpleSending)
		]
	}
}
