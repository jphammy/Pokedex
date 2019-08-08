import Foundation

typealias PokemonDisplayProperties = (title: String, value: String, detailType: Detail.DataType?)

// Reference for Decodable stucts/coding keys:
// 1. developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types
// 2. ExtraCredit2 assignment
struct Pokemon: Decodable {
    let id: Int
    let name: String
    let baseExperience: Int
    let height: Int
    let isDefault: Bool
    let order: Int
    let weight: Int
    let abilities: [Ability]
    let forms: [NameUrlPair]
    let gameIndices: [VersionGameIndex]
    let heldItems: [HeldItem]
    let locationAreaEncounters: URL
    let moves: [Move]
    let sprites: SpritesFromService
    let species: NameUrlPair
    let stats: [Stat]
    let types: [Type]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case baseExperience = "base_experience"
        case height
        case isDefault = "is_default"
        case order
        case weight
        case abilities
        case forms
        case gameIndices = "game_indices"
        case heldItems = "held_items"
        case locationAreaEncounters = "location_area_encounters"
        case moves
        case sprites
        case species
        case stats
        case types
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        baseExperience = try container.decode(Int.self, forKey: .baseExperience)
        height = try container.decode(Int.self, forKey: .height)
        isDefault = try container.decode(Bool.self, forKey: .isDefault)
        order = try container.decode(Int.self, forKey: .order)
        weight = try container.decode(Int.self, forKey: .weight)
        abilities = try container.decode([Ability].self, forKey: .abilities)
        forms = try container.decode([NameUrlPair].self, forKey: .forms)
        gameIndices = try container.decode([VersionGameIndex].self, forKey: .gameIndices)
        heldItems = try container.decode([HeldItem].self, forKey: .heldItems)
        guard let url = try URL(string: container.decode(String.self, forKey: .locationAreaEncounters)) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.locationAreaEncounters], debugDescription: "Expecting string representation of URL"))
        }
        locationAreaEncounters = url
        moves = try container.decode([Move].self, forKey: .moves)
        
        sprites = try container.decode(SpritesFromService.self, forKey: .sprites)
        species = try container.decode(NameUrlPair.self, forKey: .species)
        stats = try container.decode([Stat].self, forKey: .stats)
        types = try container.decode([Type].self, forKey: .types)
    }
    
    var displayProperties: [PokemonDisplayProperties] {
        return [
            (title: "ID:", value: "\(id)", detailType: nil),
            (title: "Name:", value: "\(name)", detailType: nil),
            (title: "Base Experience:", value: "\(baseExperience)", detailType: nil),
            (title: "Height:", value: "\(height)", detailType: nil),
            (title: "Is Default:", value: "\(isDefault)", detailType: nil),
            (title: "Order:", value: "\(order)", detailType: nil),
            (title: "Weight:", value: "\(weight)", detailType: nil),
            (title: "Abilities:", value: "\(details(forDataType: .abilities).count)", detailType: .abilities),
            (title: "Forms:", value: "\(details(forDataType: .forms).count)", detailType: .forms),
            (title: "Game Indices:", value: "\(details(forDataType: .gameIndicies).count)", detailType: .gameIndicies),
            (title: "Held Items:", value: "\(details(forDataType: .heldItems).count)", detailType: .heldItems),
            (title: "Moves:", value: "\(details(forDataType: .moves).count)", detailType: .moves),
            (title: "Sprites:", value: "\(details(forDataType: .sprites).count)", detailType: .sprites),
            (title: "Species:", value: "\(species.name)", detailType: nil),
            (title: "Stats:", value: "\(details(forDataType: .stats).count)", detailType: .stats),
            (title: "Types:", value: "\(details(forDataType: .types).count)", detailType: .types)
        ]
    }
}

extension Pokemon: DetailViewable {
    func details(forDataType dataType: Detail.DataType) -> [Detail] {
        switch dataType {
        case .abilities: return abilities.map { $0.detail }
        case .forms: return forms.map { $0.detail }
        case .gameIndicies: return gameIndices.map { $0.detail }
        case .heldItems: return heldItems.map { $0.detail }
        case .versionDetails: return []
        case .moves: return moves.map { $0.detail }
        case .versionGroupDetails: return []
        case .sprites: return []
        case .stats: return stats.map { $0.detail }
        case .types: return types.map { $0.detail }
        }
    }
}

extension Pokemon: Selectable {
    func selections(forDataType dataType: Selection.DataType) -> [Selection] {
        switch dataType {
        case .heldItems: return heldItems.map { $0.asSelection }
        case .moves: return moves.map { $0.asSelection }
        case .sprites: return []
        }
    }
}
