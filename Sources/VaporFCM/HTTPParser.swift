// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

import Foundation

internal enum CavemanResponseParserError: Error {
	case networkError(message: String)
	case invalidResponse
	case invalidHeader
	case invalidStatusCode
	case invalidPayload
}

/// Ok so I know this is a caveman solution. It should be done by URLSession and URLResponse
/// However those are still not implemented on linux, so we're sticking with this parsing, until they're done
internal class CavemanHTTPResponseParser {

	func parse(response: Data) throws -> (Data, Int) {
		let responseParts = response.split { return CharacterSet.newlines.contains(UnicodeScalar($0)) }

		guard responseParts.count >= 2 else {
			let message = String(data: response, encoding: .utf8) ?? ""
			throw CavemanResponseParserError.networkError(message: message)
		}
		guard let headerData = responseParts.first else {
			throw CavemanResponseParserError.invalidHeader
		}
		let headerParts = headerData.split { return CharacterSet.whitespaces.contains(UnicodeScalar($0)) }
		guard headerParts.count >= 3,
			let responseStatusString = String(data: Data(headerParts[1]), encoding: .utf8),
			let responseStatus = Int(responseStatusString) else {
			throw CavemanResponseParserError.invalidHeader
		}

		guard let payloadData = responseParts.last else {
			throw CavemanResponseParserError.invalidPayload
		}

		return (Data(payloadData), responseStatus)
	}
}
