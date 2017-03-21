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

	internal init(error: FirebaseError) {
		self.success = false
		self.error = error
	}

	internal init(data: Data?, statusCode: Int?, error: Error?) {
		if let error = error {
			//Error – don't parse the data
			self.success = false
			self.error = FirebaseError(error: error)
			return
		}
		guard statusCode == 200 else {
			self.success = false
			self.error = FirebaseError(statusCode: statusCode)
			return
		}
		guard let data = data,
			let json = try? Jay().anyJsonFromData(Array<UInt8>(data)),
			let dict = json as? [String: Any] else {
				self.success = false
				self.error = .invalidData
				return
		}

		var messageIds: [String] = []
		var errors: [FirebaseError] = []

		let results = dict[ResponseKey.result.rawValue] as? [[String: Any]]
		for result in results ?? [] {
			if let id = result[ResponseKey.messageId.rawValue] as? String {
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
