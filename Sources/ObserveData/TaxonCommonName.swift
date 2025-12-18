import Foundation
import SwiftData

@Model
public final class TaxonCommonName {
    public var id: String = ""  // Format: "{taxonId}_{locale}" - CloudKit requires default value
    public var taxonId: Int = 0  // CloudKit requires default value
    public var locale: String = "en"  // "en", "fr", "es" - CloudKit requires default value
    public var commonName: String?
    public var cachedAt: Date = Date()  // CloudKit requires default value - for 1-week cache expiry

    public init(taxonId: Int, locale: String, commonName: String?) {
        self.id = "\(taxonId)_\(locale)"
        self.taxonId = taxonId
        self.locale = locale
        self.commonName = commonName
        self.cachedAt = Date()
    }

    // Check if cache is still valid (< 1 week old)
    public var isCacheValid: Bool {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return cachedAt > oneWeekAgo
    }
}
