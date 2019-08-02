import Foundation

#warning("Story 1")

struct VersionGameIndex: Decodable, DetailDataType {
    let gameIndex: Int
    let version: NameUrlPair
    
    private enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }
    
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

struct VersionGroupDetail: Decodable, DetailDataType {
    let levelLearnedAt: Int
    let moveLearnMethod: NameUrlPair
    let versionGroup: NameUrlPair
    
    private enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
    
    var detail: Detail {
        return Detail(
            titleText: versionGroup.name,
            detailText: "Learned at Level: \(levelLearnedAt), Method: \(moveLearnMethod.name)",
            additionalDetails: []
        )
    }
}
