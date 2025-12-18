import CoreML

public typealias TaxonId = Int
public typealias LeafIndex = Int

final class Taxon: Decodable, @unchecked Sendable {
    let taxonId: TaxonId
    let name: String
    let rank: Int
    let leafIdx: LeafIndex?
    let parentTaxonId: TaxonId?
    let english: String?
    let french: String?
    private(set) var score = 0.0

    weak var parent: Taxon?
    var children: [Taxon] = []

    init(taxonId: TaxonId, name: String, rank: Int, leafIdx: LeafIndex? = nil, parentTaxonId: TaxonId? = nil, parent: Taxon? = nil, children: [Taxon] = [], english: String? = nil, french: String? = nil) {
        self.taxonId = taxonId
        self.name = name
        self.rank = rank
        self.leafIdx = leafIdx
        self.parentTaxonId = parentTaxonId
        self.parent = parent
        self.children = children
        self.english = english
        self.french = french
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        taxonId = try values.decode(TaxonId.self, forKey: CodingKeys.taxonId)
        name = try values.decode(String.self, forKey: CodingKeys.name)
        rank = try values.decode(Int.self, forKey: CodingKeys.rank)
        leafIdx = try? values.decode(LeafIndex.self, forKey: CodingKeys.leafIdx)
        parentTaxonId = try? values.decode(TaxonId.self, forKey: CodingKeys.parentTaxonId)
        english = try? values.decode(String.self, forKey: CodingKeys.english)
        french = try? values.decode(String.self, forKey: CodingKeys.french)
    }

    func add(child: Taxon) {
        child.parent = self
        children.append(child)
    }
}

extension Taxon {
    private enum CodingKeys: String, CodingKey {
        case taxonId, name, rank, leafIdx, parentTaxonId, english, french
    }

    /// Attach a score to each node that is the sum of the scores of its children
    func calcScores(classification: MLMultiArray) -> Double {
        if children.isEmpty {
            // get classification[leafIdx], the score for a terminal node
            let ptr = UnsafeMutablePointer<Double>(OpaquePointer(classification.dataPointer))
            score = ptr[Int(leafIdx!)]
        } else {
            score = children.map { $0.calcScores(classification: classification) }.reduce(0, +)
        }
        return score
    }
}
