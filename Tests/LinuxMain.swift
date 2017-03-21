import XCTest
@testable import FCMTests

XCTMain([
     testCase(MessageSerializerTests.allTests),
     testCase(FirebaseTests.allTests)
])
