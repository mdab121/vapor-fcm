// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

import Vapor
import HTTP

/// This is the main class that you should be using to send notifications
public class Firebase {

	/// The server key
	internal let serverKey: ServerKey

	private let serializer: MessageSerializer = MessageSerializer()
	private let pushUrl: String = "https://fcm.googleapis.com/fcm/send"
	private let requestAdapter: RequestAdapting

	/// Convenience initializer taking a path to a file where the key is stored.
	///
	/// - Parameter drop: A droplet
	/// - Parameter keyPath: Path to the Firebase Server Key
	/// - Throws: Throws an error if file doesn't exist
	public convenience init(drop: Droplet, keyPath: String) throws {
		let keyBytes = try DataFile().read(at: keyPath)

		guard let keyString = String(bytes: keyBytes, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
				throw FirebaseError.invalidServerKey
		}
		try self.init(drop: drop, serverKey: ServerKey(rawValue: keyString))
	}


	/// Initializes FCM with the key as the parameter. Please note that you should NOT store your server key in the source code and in your repository.
	/// Instead, fetch your key from some configuration files, that are not stored in your repository.
	///
	/// - Parameter drop: A droplet
	/// - Parameter serverKey: server key
	public init(drop: Droplet, serverKey: ServerKey) throws {
		self.requestAdapter = RequestAdapterVapor(droplet: drop)
		self.serverKey = serverKey
	}


	/// Sends a single message to a single device. Returns parsed status response.
	///
	/// - Parameters:
	///   - message: The message that you want to send
	///   - target: Firebase Device Token or Topic that you want to send your message to
	/// - Returns: Synchronous response
	/// - Throws: Serialization error when the message could not be serialized
	public func send(message: Message, to target: Targetable) throws -> FirebaseResponse {
		let requestBytes: Bytes = try serializer.serialize(message: message, target: target)
		do {
			let response = try requestAdapter.send(bytes: requestBytes, headers: generateHeaders(), url: pushUrl)
			return FirebaseResponse(bytes: response.body.bytes ?? [], statusCode: response.status.statusCode)
		} catch {
			return FirebaseResponse(error: error)
		}
	}

	// MARK: Private methods
	private func generateHeaders() -> [HeaderKey: String] {
		return [
			HeaderKey.contentType: "application/json",
			HeaderKey.accept: "application/json",
			HeaderKey.authorization: "key=\(serverKey.rawValue)"
		]
	}
}
