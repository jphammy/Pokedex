import Foundation

protocol DetailViewable {
    func details(forDataType dataType: Detail.DataType) -> [Detail]
}

protocol DetailDataType {
    var detail: Detail { get }
}

struct Detail {
    let titleText: String
    let detailText: String
    let additionalDetails: [Detail]
    
    var isSelectable: Bool { return !additionalDetails.isEmpty }
}

extension Detail {
    enum DataType {
        case abilities
        case forms
        case gameIndicies
        case heldItems
        case versionDetails
        case moves
        case versionGroupDetails
        case sprites
        case stats
        case types
    }
}
