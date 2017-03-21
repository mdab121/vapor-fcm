// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

import Foundation
import Vapor
import HTTP

/// This is the main class that you should be using to send notifications
public class Firebase {

	/// Set this to true if you want your requests to be performed in the background.
	/// Defaults to false, since I don't think it's been tested enough
	/// Please do not change this after pushing notifications
	internal var backgroundMode: Bool = false

	/// The server key
	internal let serverKey: ServerKey

	private let serializer: MessageSerializer = MessageSerializer()
	private let pushUrl: URL = URL(string: "https://fcm.googleapis.com/fcm/send")!
	private let requestAdapter: RequestAdapting
	private lazy var backgroundQueue = OperationQueue()

	private var requestQueue: OperationQueue {
		return backgroundMode ? backgroundQueue : (OperationQueue.current ?? OperationQueue.main)
	}

	/// Convenience initializer taking a path to a file where the key is stored.
	///
	/// - Parameter drop: A droplet
	/// - Parameter keyPath: Path to the Firebase Server Key
	/// - Throws: Throws an error if file doesn't exist
	public convenience init(drop: Droplet, keyPath: String) throws {
		let fileManager = FileManager()
		guard let keyData = fileManager.contents(atPath: keyPath),
			let keyString = String(data: keyData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
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
		self.requestAdapter = try RequestAdapterVapor(droplet: drop)
		self.serverKey = serverKey
	}


	/// Sends a single message to a single device. After sending it calls the completion closure on the queue that it was called from.
	///
	/// - Parameters:
	///   - message: The message that you want to send
	///   - deviceToken: Firebase Device Token that you want to send your message to
	///   - completion: completion closure
	/// - Throws: Serialization error when the message could not be serialized
	public func send(message: Message, to deviceToken: DeviceToken, completion: @escaping (FirebaseResponse) -> Void) throws {

		let requestBytes: [UInt8] = try serializer.serialize(message: message, device: deviceToken)
		let requestData = Data(requestBytes)
		let requestHeaders = generateHeaders()
		let url = pushUrl
		let completionQueue = OperationQueue.current ?? OperationQueue.main
		let requestAdapter = self.requestAdapter

		requestQueue.addOperation {
			do {
				try requestAdapter.send(data: requestData, headers: requestHeaders, url: url) { (data, statusCode, error) in
					let response = FirebaseResponse(data: data, statusCode: statusCode, error: error)
					completionQueue.addOperation { completion(response) }
				}
			} catch {
				let response = FirebaseResponse(data: nil, statusCode: nil, error: error)
				completionQueue.addOperation { completion(response) }
			}
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
