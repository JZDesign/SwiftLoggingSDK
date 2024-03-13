import Foundation

/// A log appender that outputs the log in JSON format
open class JsonLogTarget: LogTarget {
    public var priorityThreshold: LogLevel
    
    let encoder: JSONEncoder
    private let write: (_ stringLog: String) -> Void
    
    /// Create a JsonLogTarget
    /// - Parameters:
    ///   - loggerSettings: The settings to configure this logger
    ///   - write: A callback to process the log after it was converted into JSON
    public init(
        _ loggerSettings: JsonLogTarget.Settings,
        _ write: @escaping (String) -> Void
    ) {
        priorityThreshold = loggerSettings.minimumLogPriority
        
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = loggerSettings.prettyPrint ? [.sortedKeys, .prettyPrinted] : .sortedKeys
        
        self.write = write
    }
    
    public func write<Event>(_ logEntry: LogEntry<Event>) where Event : LogEvent {
        let stringLog = serializeLogEntry(logEntry)
        write(stringLog)
    }
    
    func serializeLogEntry(_ logEntry: LogEntry<some LogEvent>) -> String {
        do {
            let rawData = try encoder.encode(logEntry)
            guard let log = String(data: rawData, encoding: String.Encoding.utf8) else {
                throw LogError.runtime("Failed to serialize log event payload")
            }
            return log
        } catch {
            fatalError("Logging the event with eventName: \(logEntry.event) failed to be logged: \(error)")
        }
    }
    
    /// Settings that configure the JsonLogTarget class
    public struct Settings {
        let prettyPrint: Bool
        let minimumLogPriority: LogLevel
        
        /// Create a JsonLogTarget.Settings instance
        /// - Parameters:
        ///   - prettyPrint: If `true` the JSON will be in pretty print format
        ///   - minimumLogPriority: The minimum log priority that will get logged out.
        public init(prettyPrint: Bool, minimumLogPriority: LogLevel = .trace) {
            self.prettyPrint = prettyPrint
            self.minimumLogPriority = minimumLogPriority
        }
    }
}

enum LogError: Error {
    case runtime(String)
}
