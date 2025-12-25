import Foundation
import SwiftData

@Model
public final class TaxonCommonName {
    public var id: String = ""  // Format: "{taxonId}_{locale}" - CloudKit requires default value
    public var taxonId: Int = 0  // CloudKit requires default value
    public var locale: String = "en"  // "en", "fr", "es" - CloudKit requires default value
    public var commonName: String?
    public var wikipediaUrl: String?  // Wikipedia URL from iNaturalist API
    public var cachedAt: Date = Date()  // CloudKit requires default value - for 1-week cache expiry

    public init(taxonId: Int, locale: String, commonName: String?, wikipediaUrl: String? = nil) {
        self.id = "\(taxonId)_\(locale)"
        self.taxonId = taxonId
        self.locale = locale
        self.commonName = commonName
        self.wikipediaUrl = wikipediaUrl
        self.cachedAt = Date()
    }

    // Cache remains valid indefinitely until manually cleared or ML model changes
    // No time-based expiration since common names and species rarely change
    public var isCacheValid: Bool {
        return true
    }
}
