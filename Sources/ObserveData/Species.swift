import Foundation
import SwiftData
import GridNavigation

/// Represents a single taxon in the taxonomic hierarchy
public struct TaxonInfo: Codable, Equatable {
    public let taxonId: Int
    public let name: String
    public let rank: Int

    public init(taxonId: Int, name: String, rank: Int) {
        self.taxonId = taxonId
        self.name = name
        self.rank = rank
    }
}

@Model
public final class Species: GridNavigable, Identifiable {
    public var id: UUID = UUID()
    public var name: String = ""
    public var leafIndex: LeafIndex = 0
    public var taxonId: Int = 0
    @Relationship(deleteRule: .cascade, inverse: \PhotoObservation.species)
    public var observations: [PhotoObservation]? = []

    /// Cached taxonomic hierarchy from root to leaf (e.g., Kingdom > Phylum > ... > Species)
    /// Stored as JSON data for persistence
    @Attribute(.externalStorage) public var lineageData: Data?

    /// Computed property to access lineage as structured data
    public var lineage: [TaxonInfo]? {
        get {
            guard let lineageData else { return nil }
            return try? JSONDecoder().decode([TaxonInfo].self, from: lineageData)
        }
        set {
            lineageData = try? JSONEncoder().encode(newValue)
        }
    }

    public init(leafIndex: LeafIndex = 0, name: String = "", taxonId: Int = 0, lineage: [TaxonInfo]? = nil) {
        self.id = UUID()
        self.name = name
        self.leafIndex = leafIndex
        self.taxonId = taxonId
        self.lineageData = try? JSONEncoder().encode(lineage)
    }
}
