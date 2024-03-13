import Foundation

/// A log target that takes many log targets and will invoke each of them on write.
public class CompositeLogTarget: LogTarget {
    
    public var priorityThreshold: LogLevel
    private let targets: [LogTarget]
    
    /// Create a CompositeLogTarget
    /// - Parameter targets: The log targets that should process logs when the CompositeLogTarget's ``write`` function is called
    public init(_ targets: [LogTarget]) {
        self.targets = targets
        self.priorityThreshold = targets.map(\.priorityThreshold).sorted().first ?? .info
    }
    
    public func write<Event>(_ logEntry: LogEntry<Event>) where Event : LogEvent {
        targets.forEach { $0.write(logEntry.level, logEntry) }
    }
}

public extension Logger {
    /// Create a logger with more than one ``LogTarget``
    /// - Parameters:
    ///   - applicationName: The `app_id` that should be logged. This should be the name of your app.
    ///   - targets: An array of ``LogTarget`` responsible for processing log events. These Log targets are the final processing of the log and are responsible for delivering the log to its final destination
    ///   - buildType: This is a field that is uniqe to mobile. There are different build configurations your application can have. By default, there are `Release` and `Debug` configurations, but you can create more. This should be the name of the build configuration that the app is running on when the log is emitted.
    ///   - eventIdGenerator: A random UUID generator -- This is available for testing purposes
    init(
        applicationName: String,
        targets: [LogTarget],
        buildType: String,
        eventIdGenerator: @escaping () -> UUID = UUID.init
    ) {
        self.init(
            applicationName: applicationName,
            target: CompositeLogTarget(targets),
            buildType: buildType,
            eventIdGenerator: eventIdGenerator
        )
    }
}
