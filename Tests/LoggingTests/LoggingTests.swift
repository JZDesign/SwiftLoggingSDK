import XCTest

@testable import Logging

// swiftlint:disable force_unwrapping
final class LoggerTests: XCTestCase {
    func testLogPriority() throws {
        let logAsserter: (String) -> Void = {
            XCTAssertEqual($0, """
            {
              "appName" : "sample-mobile-ios",
              "buildType" : "Debug",
              "event" : "SomeTestEvent",
              "eventId" : "5A2E2E12-1776-470D-9E36-3754C764E799",
              "level" : "info",
              "logData" : {
                "message" : "this is a test log",
                "statusCode" : 12
              },
              "traceIdentifier" : "TXID+FEDB341A0E7ADF4D39F0"
            }
            """.trimTrailingWhitespace())
        }
        
        let shouldNotGetCalledToWriteLog: (String) -> Void = { XCTFail("Log event should not have gotten here:\n\($0)") }
        
        let subject = Logger(
            applicationName: "sample-mobile-ios",
            targets: [
                TestLogTarget(.init(prettyPrint: true, minimumLogPriority: .critical), shouldNotGetCalledToWriteLog),
                TestLogTarget(.init(prettyPrint: true, minimumLogPriority: .error), shouldNotGetCalledToWriteLog),
                TestLogTarget(.init(prettyPrint: true, minimumLogPriority: .warn), shouldNotGetCalledToWriteLog),
                TestLogTarget(.init(prettyPrint: true, minimumLogPriority: .info), logAsserter),
                TestLogTarget(.init(prettyPrint: true, minimumLogPriority: .debug), logAsserter),
                TestLogTarget(.init(prettyPrint: true, minimumLogPriority: .trace), logAsserter),
            ],
            buildType: "Debug",
            eventIdGenerator: { UUID(uuidString: "5A2E2E12-1776-470D-9E36-3754C764E799")! }
        )
        
        subject.info(traceId: "TXID+FEDB341A0E7ADF4D39F0", SomeTestEvent(message: "this is a test log", statusCode: 12))
    }
}

public struct SomeTestEvent: LogEvent {
    let message: String
    let statusCode: Int
}

public class TestLogTarget: JsonLogTarget {}


extension String {
    
    func trimTrailingWhitespace() -> String {
        if let last, last.isWhitespace || last.isNewline {
            return String(dropLast()).trimTrailingWhitespace()
        }
        
        return self
    }

}
