import Foundation

struct Ability: Decodable, DetailDataType {
    let ability: NameUrlPair
    let isHidden: Bool
    let slot: Int
    
    private enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
    
    var detail: Detail {
        return Detail(
            titleText: ability.name,
            detailText: "Slot #: \(slot), Hidden Ability: \(isHidden)",
            additionalDetails: []
        )
    }
}
