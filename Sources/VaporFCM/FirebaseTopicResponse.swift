// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

import Foundation
import Jay

public struct FirebaseTopicResponse: FirebaseResponse {
	/// Indicates if everything was successful
	public let success: Bool

	/// Error(s) that occured while sending a message
	public let error: FirebaseError?

	/// The message ids
	public let messageIds: [UInt]

	/// Message id is UInt here
	public typealias MessageIdType = UInt

	public init(success: Bool, error: FirebaseError?, messageIds: [MessageIdType]) {
		self.success = success
		self.error = error
		self.messageIds = messageIds
	}
}
