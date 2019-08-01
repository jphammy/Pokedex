import Foundation

#warning("Story 1")
//NEED TO IMPLEMENT CODING KEYS

struct Move: Decodable, DetailDataType, SelectionDataType {
    let move: NameUrlPair
    let versionGroupDetails: [VersionGroupDetail]
    
    var detail: Detail {
        return Detail(
            titleText: move.name,
            detailText: "Select to see version group details",
            additionalDetails: versionGroupDetails.map { $0.detail }
        )
    }
    
    var asSelection: Selection {
        return Selection(title: move.name)
    }
}
