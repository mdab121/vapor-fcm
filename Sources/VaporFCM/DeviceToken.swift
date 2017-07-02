// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

/// This represents an FCM device token
public struct DeviceToken: RawRepresentable {
	public typealias RawValue = String
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	public init(_ rawValue: String) {
		self.rawValue = rawValue
	}
}

extension DeviceToken: Targetable {
	public var targetKey: String {
		return "to"
	}

	public var targetValue: String {
		return rawValue
	}
}

extension DeviceToken: Equatable {
	public static func ==(lhs: DeviceToken, rhs: DeviceToken) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
}
