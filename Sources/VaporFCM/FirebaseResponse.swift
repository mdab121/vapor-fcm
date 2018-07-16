// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

import Foundation
import Jay

/// This is a response that you will get from Firebase
public protocol FirebaseResponse {

	/// Indicates if everything was successful
	var success: Bool { get }

	/// Error(s) that occured while sending a message
	var error: FirebaseError? { get }

	/// The type of a message ID (can be String or UInt)
	associatedtype MessageIdType

	/// The message ids
	var messageIds: [MessageIdType] { get }

	init(success: Bool, error: FirebaseError?, messageIds: [MessageIdType])
}

fileprivate enum FirebaseResponseKey: String {
	case result = "results"
	case messageId = "message_id"
	case error = "error"
}

internal extension FirebaseResponse {

	init(firebaseError: FirebaseError) {
		self.init(success: false, error: firebaseError, messageIds: [])
	}

	init(error: Error) {
		self.init(firebaseError: FirebaseError(error: error))
	}

	init(bytes: [UInt8], statusCode: Int) {
		guard statusCode == 200 else {
			self.init(success: false, error: FirebaseError(statusCode: statusCode), messageIds: [])
			return
		}
		guard let json = try? Jay().anyJsonFromData(bytes),
			let dict = json as? [String: Any] else {
				self.init(success: false, error: .invalidData, messageIds: [])
				return
		}

		var messageIds: [MessageIdType] = []
		var errors: [FirebaseError] = []

		let results = (dict[FirebaseResponseKey.result.rawValue] as? [[String: Any]]) ?? [dict]
		for result in results {
			if let id = result[FirebaseResponseKey.messageId.rawValue] as? MessageIdType {
				messageIds.append(id)
			}
			if let errorMessage = result[FirebaseResponseKey.error.rawValue] as? String {
				errors.append(FirebaseError(message: errorMessage))
			}
		}

		self.init(success: errors.isEmpty && !messageIds.isEmpty, error: FirebaseError(multiple: errors), messageIds: messageIds)
	}
}
