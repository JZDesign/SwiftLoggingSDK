# SwiftLoggingSDK

This is a logging package that will allow you to have one logger that will intelligently write to multiple sources. It comes stock with a `DeviceLogTarget` which will use `os.Log` to output your log events, and a `JsonLogTarget` which will serialize your logs into JSON so you can send it to any log destination you desire.

## LogTargets

LogTargets are the workers that will write the logs that the logger receives. They are customizeable such that they each can have their own priority threshold and their own destinations.

Below is an example of a LogTarget for Sematext:

```swift
import Foundation
import SwiftLoggingSDK
import Logsene

struct LogseneTarget: LogTarget {
    private let encoder = JSONEncoder()
    
    var priorityThreshold: LogLevel // If the incoming log is lower than this, the logger will not invoke this struct's write function
    
    init(sdkID: String = "{{Your sdk id here}}", priorityThreshold: LogLevel = .debug) {
        self.priorityThreshold = priorityThreshold
        
        #if DEBUG
        let type = "MYAPP-DEBUG"
        #else
        let type = "MYAPP"
        #endif

        encoder.dateEncodingStrategy = .iso8601
        try? LogseneInit(
            sdkID,
            type: type,
            receiverUrl: "https://logsene-receiver.sematext.com"
            )
    }
    
    func write<Event>(_ logEntry: Logging.LogEntry<Event>) where Event : Logging.LogEvent {
        // Here you proccess the log event and send it where you want.
        if let data = try? encoder.encode(logEntry), let logData = try? JSONSerialization.jsonObject(with: data) as? JsonObject {
            LLogEvent(logData)
        }
    }
}
```

## Composite Logger

```swift
#if DEBUG
let buildType = "DEBUG"
#else
let buildType = "RELEASE"
#endif

let applicationLogger: LogEmitting = Logger(
    applicationName: "MYAPP",
    targets: [
        DeviceLogTarget(),
        LogseneTarget(),
        MixpanelTarget()
    ], // These targets all receive the log events!!
    buildType: buildType
)

```

## Using the logger

```swift
applicationLogger.trace("some unique trace ID or nil", SomeLogEvent())
applicationLogger.debug("some unique trace ID or nil", SomeLogEvent())
applicationLogger.info("some unique trace ID or nil", SomeLogEvent())
applicationLogger.warn("some unique trace ID or nil", SomeLogEvent())
applicationLogger.error("some unique trace ID or nil", SomeLogEvent())
applicationLogger.critical("some unique trace ID or nil", SomeLogEvent())
```