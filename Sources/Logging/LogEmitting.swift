import Foundation

public protocol LogEmitting {
    func write<T: LogEvent>(_ priority: LogLevel, _ traceId: String?, _ eventSupplier: @escaping () -> T)
}

public extension LogEmitting {
    /// Logs a CRITICAL level log
    /// - Parameters:
    ///   - logEventSupplier: The log event to process
    func critical(traceId: String? = nil, _ logEventSupplier: @autoclosure @escaping () -> some LogEvent) { write(.critical, traceId, logEventSupplier) }
    
    /// Logs an ERROR level log
    /// - Parameters:
    ///   - logEventSupplier: The log event to process
    func error(traceId: String? = nil, _ logEventSupplier: @autoclosure @escaping () -> some LogEvent) { write(.error, traceId, logEventSupplier) }
    
    /// Logs a WARN level log
    /// - Parameters:
    ///   - logEventSupplier: The log event to process
    func warn(traceId: String? = nil, _ logEventSupplier: @autoclosure @escaping () -> some LogEvent) { write(.warn, traceId, logEventSupplier) }
    
    /// Logs an INFO level log
    /// - Parameters:
    ///   - logEventSupplier: The log event to process
    func info(traceId: String? = nil, _ logEventSupplier: @autoclosure @escaping () -> some LogEvent) { write(.info, traceId, logEventSupplier) }
    
    /// Logs a DEBUG level log
    /// - Parameters:
    ///   - logEventSupplier: The log event to process
    func debug(traceId: String? = nil, _ logEventSupplier: @autoclosure @escaping () -> some LogEvent) { write(.debug, traceId, logEventSupplier) }
    
    /// Logs a TRACE level log
    /// - Parameters:
    ///   - logEventSupplier: The log event to process
    func trace(traceId: String? = nil, _ logEventSupplier: @autoclosure @escaping () -> some LogEvent) { write(.trace, traceId, logEventSupplier) }
}
