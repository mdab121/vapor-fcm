// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

import XCTest
@testable import VaporFCM

class MessageSerializerTests: XCTestCase {

	var sut: MessageSerializer!
	let exampleToken = DeviceToken(rawValue: "example_token")
	let exampleToken2 = DeviceToken(rawValue: "example_token_sdafegrfiefhaslifuharilfugdfisl")
	let simplePayload = Payload(message: "Hello world")
	let bigPayload = Payload(title: "This is a title", body: "this is a body", badge: 14)

	var json: [String: Any]!

	override func setUp() {
		super.setUp()
		sut = MessageSerializer()
	}

	override func tearDown() {
		sut = nil
		json = nil
		super.tearDown()
	}

	func testSimplePayload() {
		let message = Message(payload: simplePayload)
		json = sut.serialize(message: message, device: exampleToken)
		XCTAssertEqual(json["to"] as? String, exampleToken.rawValue)
		XCTAssertEqual((json["notification"] as? [String: Any])?["body"] as? String, "Hello world")
		XCTAssertEqual(json["dry_run"] as? Bool, nil)
		XCTAssertEqual(json.count, 2)
	}

	func testPayloadWithSoundAndBadge() {
		var payload = bigPayload
		payload.sound = "default"
		var message = Message(payload: payload)
		message.debug = true
		json = sut.serialize(message: message, device: exampleToken2)
		XCTAssertEqual(json["to"] as? String, exampleToken2.rawValue)
		XCTAssertEqual((json["notification"] as? [String: Any])?["body"] as? String, "this is a body")
		XCTAssertEqual((json["notification"] as? [String: Any])?["title"] as? String, "This is a title")
		XCTAssertEqual((json["notification"] as? [String: Any])?["badge"] as? Int, 14)
		XCTAssertEqual((json["notification"] as? [String: Any])?["sound"] as? String, "default")
		XCTAssertEqual(json["dry_run"] as? Bool, true)
		XCTAssertEqual(json.count, 3)
	}

	func testWithCustomData() {
		let customData = MessageData(rawValue: ["data": true, "howMuch": 15])
		let message = Message(payload: simplePayload, data: customData)
		json = sut.serialize(message: message, device: exampleToken2)
		XCTAssertEqual(json["to"] as? String, exampleToken2.rawValue)
		XCTAssertEqual((json["notification"] as? [String: Any])?["body"] as? String, "Hello world")
		XCTAssertEqual((json["notification"] as? [String: Any])?.count, 1)
		XCTAssertEqual((json["data"] as? [String: Any])?["data"] as? Bool, true)
		XCTAssertEqual((json["data"] as? [String: Any])?["howMuch"] as? Int, 15)
		XCTAssertEqual((json["data"] as? [String: Any])?.count, 2)
		XCTAssertEqual(json.count, 3)
	}

	static var allTests : [(String, (MessageSerializerTests) -> () throws -> Void)] {
        return [
            ("testSimplePayload", testSimplePayload),
            ("testPayloadWithSoundAndBadge", testPayloadWithSoundAndBadge),
            ("testWithCustomData", testWithCustomData)
        ]
    }
}
