import Foundation
import OSLog

/// Centralized logging configuration for App
enum AppLogger {
    /// General app operations and lifecycle
    static let general = Logger(subsystem: "ObserveData", category: "general")

    /// Core Data and database operations
    static let database = Logger(subsystem: "ObserveData", category: "database")

    /// Import functionality
    static let importData = Logger(subsystem: "ObserveData", category: "import")

    /// Thumbnail generation
    static let thumbnail = Logger(subsystem: "ObserveData", category: "thumbnail-generation")
}
