import Foundation

public enum LogLevel: String, Codable, CaseIterable, Comparable {
    case trace, debug, info, warn, error, critical
    
    var index: Int { LogLevel.allCases.firstIndex(of: self) ?? 0 }
    
    /// Compare by order
    /// - Parameters:
    ///   - lhs: A log level on the left hand side of the `<`
    ///   - rhs: A log level on the right hand side of the `<`
    /// - Returns: True if the left hand side is indexed lower than the right hand side
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool { lhs.index < rhs.index }
}
