import Foundation
import os

/// A Log Target that will log JSON to the console for debugging purposes
public final class DeviceLogTarget: JsonLogTarget {
    private let osLogger = os.Logger()
    
    /// Create a DeviceLogTarget
    /// - Parameter loggerSettings: The settings to configure the Device Log Target
    public convenience init(
        _ loggerSettings: JsonLogTarget.Settings = .init(prettyPrint: true, minimumLogPriority: .debug)
    ) {
        self.init(loggerSettings) { _ in /* This won't get invoked due to the override below. */ }
    }

    public override func write(_ logEntry: LogEntry<some LogEvent>) {
        let stringLog = serializeLogEntry(logEntry)
        
        switch logEntry.level {
        case .trace:
            osLogger.trace("\(stringLog)")
        case .debug:
            osLogger.debug("\(stringLog)")
        case .info:
            osLogger.info("\(stringLog)")
        case .warn:
            osLogger.warning("\(stringLog)")
        case .error:
            osLogger.error("\(stringLog)")
        case .critical:
            osLogger.critical("\(stringLog)")
        }
    }
}
