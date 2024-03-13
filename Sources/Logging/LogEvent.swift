import Foundation

public protocol LogEvent: Codable {}

public extension LogEvent {
    /// The `event` field of the log. This is autofilled by the name of the type. For example:
    ///
    /// ```swift
    ///  struct OnboardingComplete: LogEvent
    ///  ```
    /// The event for the above struct would be `OnboardingComplete`
    var eventName: String {
        String(describing: type(of: self))
    }
}

public protocol UserAnlalyticsLogEvent: LogEvent {}

public struct LogEntry<Event: LogEvent>: Codable {
    public let event: String
    public let traceIdentifier: String?
    public let level: LogLevel
    public let appName: String
    public let buildType: String
    public let eventId: UUID
    public let logData: Event
    
    public init(
        event: String,
        appName: String,
        buildType: String,
        level: LogLevel,
        logData: Event,
        traceIdentifier: String? = nil,
        eventId: UUID = .init()
    ) {
        self.event = event
        self.traceIdentifier = traceIdentifier
        self.level = level
        self.appName = appName
        self.buildType = buildType
        self.eventId = eventId
        self.logData = logData
    }
}
