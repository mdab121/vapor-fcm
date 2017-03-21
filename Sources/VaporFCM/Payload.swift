// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

import Foundation

public struct Payload {

	/// iOS Only
	/// The value of the badge on the home screen app icon.
	///	If not specified, the badge is not changed.
	///	If set to 0, the badge is removed.
	public var badge: Int?

	/// The message's title.
	///	This field is not visible on iOS phones and tablets.
	public var title: String?

	/// iOS and Android
	/// The message's body text
	public var body: String?

	/// Android Only
	/// The notification's icon.
	///	Sets the notification icon to myicon for drawable resource myicon.
	/// If you don't send this key in the request, FCM displays the launcher icon specified in your app manifest.
	public var icon: String?

	/// Android Only
	/// Identifier used to replace existing notifications in the notification drawer.
	public var tag: String?

	/// Android Only
	/// The notification's icon color, expressed in #rrggbb format.
	public var color: String?

	/// The sound to play when the device receives the notification.
	/// Sound files can be in the main bundle of the client app or
	/// in the Library/Sounds folder of the app's data container.
	/// See the iOS Developer Library for more information.
	public var sound: String?

	public init() {}
}

extension Payload {

	private enum PayloadKey: String {
		case badge = "badge"
		case title = "title"
		case body = "body"
		case icon = "icon"
		case tag = "tag"
		case color = "color"
		case sound = "sound"
	}

	internal func makeJson() -> [String: AnyHashable] {
		var json: [String: AnyHashable] = [:]

		if let badge = badge { json[PayloadKey.badge.rawValue] = badge }
		if let title = title { json[PayloadKey.title.rawValue] = title }
		if let body = body { json[PayloadKey.body.rawValue] = body }
		if let icon = icon { json[PayloadKey.icon.rawValue] = icon }
		if let tag = tag { json[PayloadKey.tag.rawValue] = tag }
		if let color = color { json[PayloadKey.color.rawValue] = color }
		if let sound = sound { json[PayloadKey.sound.rawValue] = sound }

		return json
	}
}

extension Payload {
	public init(message: String) {
		self.body = message
	}

	public init(title: String, body: String) {
		self.title = title
		self.body = body
	}

	public init(title: String, body: String, badge: Int) {
		self.title = title
		self.body = body
		self.badge = badge
	}
}

extension Payload: Equatable {
	public static func ==(lhs: Payload, rhs: Payload) -> Bool {
		return lhs.badge == rhs.badge
			&& lhs.title == rhs.title
			&& lhs.body == rhs.body
			&& lhs.icon == rhs.icon
			&& lhs.tag == rhs.tag
			&& lhs.color == rhs.color
			&& lhs.sound == rhs.sound
	}
}
