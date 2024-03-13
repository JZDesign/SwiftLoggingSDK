import Foundation

/// An interface representing a log Target
///
/// The log Target  is used by the logger to process a given log. If using the ``Logger``, this is actually the thing responsible for the final write of the log.
public protocol LogTarget  {
    
    /// The minimum log priority that this `LogTarget ` should log out on ``write``
    var priorityThreshold: LogLevel { get }

    /// Should write a log to its final destination
    /// - Parameters:
    ///   - logEntry: The log entry to be processed
    func write<Event: LogEvent>(_ logEntry: LogEntry<Event>)
}

public extension LogTarget  {
    /// Writes a log to its final destination if the log priority is greater than or equal to the priority threshold
    /// - Parameters:
    ///   - priority: The priority of the log
    ///   - logEvent: The log entry to be processed
    func write<Event: LogEvent>(
        _ priority: LogLevel,
        _ logEntry: LogEntry<Event>
    ) {
        if priority >= priorityThreshold {
            write(logEntry)
        }
    }
}
