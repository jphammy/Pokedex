import Foundation

struct Type: Decodable, DetailDataType {
    let slot: Int
    let type: NameUrlPair
    
    var detail: Detail {
        return Detail(
            titleText: type.name,
            detailText: "Slot #: \(slot)",
            additionalDetails: []
        )
    }
}
