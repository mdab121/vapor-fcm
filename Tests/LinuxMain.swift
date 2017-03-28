import XCTest
@testable import VaporFCMTests

XCTMain([
     testCase(MessageSerializerTests.allTests),
     testCase(FirebaseTests.allTests)
])
