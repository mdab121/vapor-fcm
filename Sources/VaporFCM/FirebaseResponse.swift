// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

import Foundation
import Jay

/// This is a response that you will get from Firebase
public struct FirebaseResponse {

	/// Indicates if everything was successful
	public let success: Bool

	/// Error(s) that occured while sending a message
	public let error: FirebaseError?

	// MARK: Internal and private methods

	private enum ResponseKey: String {
		case result = "results"
		case messageId = "message_id"
		case error = "error"
	}

	internal init(firebaseError: FirebaseError) {
		self.success = false
		self.error = firebaseError
	}

	internal init(error: Error) {
		self.init(firebaseError: FirebaseError(error: error))
	}

	internal init(bytes: [UInt8], statusCode: Int) {
		guard statusCode == 200 else {
			self.success = false
			self.error = FirebaseError(statusCode: statusCode)
			return
		}
		guard let json = try? Jay().anyJsonFromData(bytes),
			let dict = json as? [String: Any] else {
				self.success = false
				self.error = .invalidData
				return
		}

		var messageIds: [Any] = []
		var errors: [FirebaseError] = []

		/*
         Differentiate between multicast and topic requests/responses:
         - multicast: result (array) wrapped in `result` key
         - topic: result in root object
         see: https://firebase.google.com/docs/cloud-messaging/send-message
         */
        var results = [[String: Any]]()
        if let multicastResults = dict[ResponseKey.result.rawValue] as? [[String: Any]] {

            results = multicastResults

        } else {

            results.append(dict)
        }

        for result in results {
            if let id = result[ResponseKey.messageId.rawValue] {
                messageIds.append(id)
            }
            if let errorMessage = result[ResponseKey.error.rawValue] as? String {
                errors.append(FirebaseError(message: errorMessage))
            }
        }

		self.success = errors.isEmpty && !messageIds.isEmpty
		self.error = FirebaseError(multiple: errors)
	}
}
