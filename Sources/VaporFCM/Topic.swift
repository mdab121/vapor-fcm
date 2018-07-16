// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

public struct Topic {

	fileprivate var rawTopics: [String]

    public init(_ topic: String){
        self.rawTopics = [topic]
    }

	public init(_ topics: String...) {
		self.rawTopics = topics
	}
}

extension Topic: Targetable {
	public var targetValue: String {
		switch rawTopics.count {
		case 0:
			return ""
		case 1:
			return "/topics/\(rawTopics[0])"
		default:
			return rawTopics.map({ t in return "'\(t)' in topics" }).joined(separator: " || ")
		}
	}

	public var targetKey: String {
		switch rawTopics.count {
		case 0:
			return ""
		case 1:
			return "to"
		default:
			return "condition"
		}
	}

	public typealias ResponseType = FirebaseTopicResponse
}

extension Topic: Equatable {
    public static func ==(lhs: Topic, rhs: Topic) -> Bool {
        return lhs.rawTopics == rhs.rawTopics
    }
}
