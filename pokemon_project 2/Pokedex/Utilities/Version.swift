import Foundation

#warning("Story 1")
//NEED TO IMPLEMENT CODING KEYS

struct VersionGameIndex: Decodable, DetailDataType {
    let gameIndex: Int
    let version: NameUrlPair
    
    var detail: Detail {
        return Detail(
            titleText: version.name,
            detailText: "Game Index: \(gameIndex)",
            additionalDetails: []
        )
    }
}

struct VersionRarity: Codable, DetailDataType {
    let rarity: Int
    let version: NameUrlPair
    
    var detail: Detail {
        return Detail(
            titleText: version.name,
            detailText: "Rarity: \(rarity)",
            additionalDetails: []
        )
    }
}

//NEED TO IMPLEMENT CODING KEYS
struct VersionGroupDetail: Decodable, DetailDataType {
    let levelLearnedAt: Int
    let moveLearnMethod: NameUrlPair
    let versionGroup: NameUrlPair
    
    var detail: Detail {
        return Detail(
            titleText: versionGroup.name,
            detailText: "Learned at Level: \(levelLearnedAt), Method: \(moveLearnMethod.name)",
            additionalDetails: []
        )
    }
}
