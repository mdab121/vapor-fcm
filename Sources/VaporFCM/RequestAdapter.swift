// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

import Foundation
import Vapor
import HTTP

/// This is a protocol that will wrap a url http post request. It should be done by URLSession (obviously), but
internal protocol RequestAdapting {
	func send(data: Data, headers: [HeaderKey: String], url: URL, completion: @escaping (Data?, Int?, Error?) -> Void) throws
}

internal class RequestAdapterVapor: RequestAdapting {

	let drop: Droplet

	init(droplet: Droplet) throws {
		self.drop = droplet
	}

	func send(data: Data, headers: [HeaderKey : String], url: URL, completion: @escaping (Data?, Int?, Error?) -> Void) throws {
		do {
			let response = try drop.client.post(url.absoluteString, headers: headers, body: Body.data(data.makeBytes()))
			completion(Data(response.body.bytes ?? []), response.status.statusCode, nil)
		} catch {
			completion(nil, nil, error)
		}
	}
}
