import Foundation

struct NameUrlPair: Codable, DetailDataType, SelectionDataType {
    let name: String
    let url: URL
    
    var detail: Detail {
        return Detail(
            titleText: name,
            detailText: "--",
            additionalDetails: []
        )
    }
    
    var asSelection: Selection {
        return Selection(title: name)
    }
}
