import Foundation
import os

// swiftlint:disable multiline_parameters

/// A default implementation of ``LogEmitting`` that will output logs in the apophenia format.
public struct Logger: LogEmitting {
    /// The apophenia log format the logger conforms to
    
    let applicationName: String
    let target: LogTarget
    let buildType: String
    let eventIdGenerator: () -> UUID
    
    // TODO: Remove selected env?
    /// Create an instance of Logger
    /// - Parameters:
    ///   - applicationName: The `app_id` that should be logged. This should be the name of your app.
    ///   - target: A ``LogTarget`` responsible for processing log events. These Log targets are the final processing of the log and are responsible for delivering the log to its final destination
    ///   - buildType: This is a field that is uniqe to mobile. There are different build configurations your application can have. By default, there are `Release` and `Debug` configurations, but you can create more. This should be the name of the build configuration that the app is running on when the log is emitted.
    ///   - eventIdGenerator: A random UUID generator -- This is available for testing purposes
    public init(
        applicationName: String,
        target: LogTarget,
        buildType: String,
        eventIdGenerator: @escaping () -> UUID = UUID.init
    ) {
        self.applicationName = applicationName
        self.target = target
        self.buildType = buildType
        self.eventIdGenerator = eventIdGenerator
    }
    
    /// Writes a log to the log target provided
    /// - Parameters:
    ///   - priority: The ``LogLevel``
    ///   - eventSupplier: A function that returns a ``LogEvent`` that will be written to the log target
    public func write(
        _ priority: LogLevel,
        _ traceId: String?,
        _ eventSupplier: @escaping () -> some LogEvent
    ) {
        target.write(priority, buildEntrySupplier(priority: priority, traceId: traceId, eventSupplier: eventSupplier))
    }
    
    func buildEntrySupplier<T: LogEvent>(
        priority: LogLevel,
        traceId: String?,
        eventSupplier: @escaping () -> T
    ) -> LogEntry<T> {
        buildEntry(priority: priority, traceId: traceId, event: eventSupplier())
    }
    
    func buildEntry<T>(
        priority: LogLevel,
        traceId: String?,
        event: T
    ) -> LogEntry<T> where T: LogEvent {
        buildEntry(priority: priority, traceId: traceId, data: event)
    }
    
    func buildEntry<T: LogEvent>(priority: LogLevel, traceId: String?, data: T) -> LogEntry<T> {
        LogEntry(
            event: data.eventName,
            appName: applicationName,
            buildType: buildType,
            level: priority,
            logData: data,
            traceIdentifier: traceId,
            eventId: eventIdGenerator()
        )
    }
}

public extension Logger {
    /// A sample logger that writes the same message to the console every time it's invoked.
    static let sample = Logger(
        applicationName: "sample-app-id",
        target: SampleLogTarget(),
        buildType: "Debug"
    )
}

struct SampleLogTarget: LogTarget {
    var priorityThreshold: LogLevel = .debug
    func write<Event>(_ logEntry: LogEntry<Event>) where Event : LogEvent {
        os.Logger().debug("Sample Log Event")
    }
    
}
