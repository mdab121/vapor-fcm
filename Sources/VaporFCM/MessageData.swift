// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

/// MessageData represents extra data that you can
public struct MessageData: RawRepresentable {

	public typealias RawValue = [String: AnyHashable]
	public internal(set) var rawValue: [String: AnyHashable]

	public init(rawValue: [String: AnyHashable]) {
		self.rawValue = rawValue
	}

	public init() {
		self.rawValue = [:]
	}

	public subscript(index: String) -> AnyHashable? {
		get {
			return rawValue[index]
		}
		set(newValue) {
			rawValue[index] = newValue
		}
	}
}

extension MessageData {
	internal func makeJson() -> [String: AnyHashable] {
		return rawValue
	}
}

extension MessageData: Equatable {
	public static func ==(lhs: MessageData, rhs: MessageData) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
}
