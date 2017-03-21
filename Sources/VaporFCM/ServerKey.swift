// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

/// This represents an FCM Server Key
public struct ServerKey: RawRepresentable {

	public typealias RawValue = String
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	public init(_ rawValue: String){
		self.rawValue = rawValue
	}
}

extension ServerKey: Equatable {
	public static func ==(lhs: ServerKey, rhs: ServerKey) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
}
