import Foundation

#warning("Story 1")

struct HeldItem: Codable, DetailDataType, SelectionDataType {
    let item: NameUrlPair
    let versionDetails: [VersionRarity]
    
    private enum CodingKeys: String, CodingKey {
        case item
        case versionDetails = "version_details"
    }
    
    var detail: Detail {
        return Detail(
            titleText: item.name,
            detailText: "Select to see version details",
            additionalDetails: versionDetails.map { $0.detail }
        )
    }
    
    var asSelection: Selection {
        return Selection(title: item.name)
    }
}
