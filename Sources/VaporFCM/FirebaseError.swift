// (c) 2017 Kajetan Michal Dabrowski
// This code is licensed under MIT license (see LICENSE for details)

public enum FirebaseError: Error {

	//TODO: There are more types of errors returned by Firebase.
	// Support them all in the future :)
	
	case invalidJson			//Firebase reported invalid payload. Please report this
	case invalidServerKey		//Pretty self explanatory
	case serverError			//Internal Firebase error

	case invalidRegistration	//Invalid Device token
	case missingRegistration	//No token
	case notRegistered

	case invalidData
	case unknown				//Unknown error
	case networkError(message: String)

	case other(error: Error)	//Some other error – for example no internet connection
	case multiple(errors: [FirebaseError])	// Multiple nested errors

	init(message: String) {
		switch message {
		case "InvalidRegistration":
			self = .invalidRegistration
		case "MissingRegistration":
			self = .missingRegistration
		case "NotRegistered":
			self = .notRegistered
		default:
			self = .unknown
		}
	}

	init?(multiple: [FirebaseError]) {
		if multiple.isEmpty { return nil }
		else if multiple.count == 1 { self = multiple.first! }
		else { self = .multiple(errors: multiple) }
	}

	init(error: Error) {
		if let error = error as? FirebaseError {
			self = error
		} else {
			self = .other(error: error)
		}
	}

	init?(statusCode: Int?) {
		guard let statusCode = statusCode else {
			self = .unknown
			return
		}
		switch statusCode {
		case 200..<300:
			return nil
		case 400:
			self = .invalidJson
		case 401:
			self = .invalidServerKey
		case 500...599:
			self = .serverError
		default:
			self = .unknown
		}
	}
}
