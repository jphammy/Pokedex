import Foundation

#warning("Story 1")
//NEED TO IMPLEMENT CODING KEYS

struct Stat: Decodable, DetailDataType {
    let baseStat: Int
    let effort: Int
    let stat: NameUrlPair
    
    var detail: Detail {
        return Detail(
            titleText: stat.name,
            detailText: "Base Stat: \(baseStat), Effort: \(effort)",
            additionalDetails: []
        )
    }
}
