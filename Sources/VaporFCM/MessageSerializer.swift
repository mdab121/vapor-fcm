// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

import Jay

/// This object turns messages int json data
public class MessageSerializer {

	private enum MessageKey: String {
		case dryRun = "dry_run"
		case notification = "notification"
		case data = "data"
	}

	public func serialize<Target: Targetable>(message: Message, target: Target) throws -> [UInt8] {
		let json: [String: Any] = serialize(message: message, target: target)
		return try Jay(formatting: .minified).dataFromJson(jsonWrapper: JaySON(json))
	}

	public func serialize<Target: Targetable>(message: Message, target: Target) -> [String: Any] {
		var json: [String: Any] = [:]
		json[target.targetKey] = target.targetValue

		if message.debug {
			json[MessageKey.dryRun.rawValue] = message.debug
		}
		if let payload = message.payload {
			json[MessageKey.notification.rawValue] = payload.makeJson()
		}
		if let data = message.data {
			json[MessageKey.data.rawValue] = data.makeJson()
		}
		return json
	}
}
