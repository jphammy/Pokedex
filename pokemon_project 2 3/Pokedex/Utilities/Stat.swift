import Foundation

#warning("Story 1")

struct Stat: Decodable, DetailDataType {
    let baseStat: Int
    let effort: Int
    let stat: NameUrlPair
    
    private enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
    
    var detail: Detail {
        return Detail(
            titleText: stat.name,
            detailText: "Base Stat: \(baseStat), Effort: \(effort)",
            additionalDetails: []
        )
    }
}
