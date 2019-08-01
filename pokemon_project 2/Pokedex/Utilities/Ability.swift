import Foundation

#warning("Story 1")
//NEED TO IMPLEMENT CODING KEYS

struct Ability: Decodable, DetailDataType {
    let ability: NameUrlPair
    let isHidden: Bool
    let slot: Int
    
    var detail: Detail {
        return Detail(
            titleText: ability.name,
            detailText: "Slot #: \(slot), Hidden Ability: \(isHidden)",
            additionalDetails: []
        )
    }
}
