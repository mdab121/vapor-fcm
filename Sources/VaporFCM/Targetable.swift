// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

import Foundation

/// This represents an object that could be a message target.
/// As of this moment, this could be a DeviceToken, a Topic, and group of Topics.
public protocol Targetable {
	var targetKey: String { get }
	var targetValue: String { get }

	/// The response type for this type of target
	associatedtype ResponseType: FirebaseResponse
}
