import Foundation

struct Move: Decodable, DetailDataType, SelectionDataType {
    let move: NameUrlPair
    let versionGroupDetails: [VersionGroupDetail]
    
    private enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
    
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
