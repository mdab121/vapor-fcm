// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

import Vapor
import HTTP

/// This is a protocol that will wrap a url http post request.
internal protocol RequestAdapting {
	func send(bytes: Bytes, headers: [HeaderKey: String], url: String) throws -> Response
}

internal class RequestAdapterVapor: RequestAdapting {

	let drop: Droplet

	init(droplet: Droplet) {
		self.drop = droplet
	}

	func send(bytes: Bytes, headers: [HeaderKey : String], url: String) throws -> Response {
		return try drop.client.post(url, headers: headers, body: Body.data(bytes))
	}
}
