import Foundation

#warning("Story 1")

typealias PokemonDisplayProperties = (title: String, value: String, detailType: Detail.DataType?)

//NEED TO IMPLEMENT CODING KEYS
//NEED TO IMPLEMENT init(from decoder: Decoder)
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
    let locationAreaEncounters: String
    let moves: [Move]
    let sprites: [NameUrlPair]
    let species: NameUrlPair
    let stats: [Stat]
    let types: [Type]
    
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
//            (title: "Location Area Encounters", value: "\(locationAreaEncounters)", detailType: nil),
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
        case .sprites: return sprites.map { $0.detail }
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
        case .sprites: return sprites.map { $0.asSelection }
        }
    }
}
