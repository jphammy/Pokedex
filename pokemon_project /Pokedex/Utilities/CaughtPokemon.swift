import Foundation

struct CaughtPokemon: Codable {
    let collectionId: UUID
    let id: Int
    let species: String
    let nickName: String
    let currentLevel: Int
    let currentExperience: Int
    let moves: [String]
    let heldItem: String?
    let sprite: NameDataPair
}

extension CaughtPokemon {
    enum DisplayProperty: String, CaseIterable {
        case species = "Species:"
        case nickName = "Nickname:"
        case currentLevel = "Current Level:"
        case currentExperience = "Current Experience:"
        case moves = "Moves (Count Displayed)"
        case heldItem = "Held Item:"
        case sprite = "Sprite:"
        
        var inputType: InputType {
            switch self {
            case .species: return .select
            case .nickName: return .text
            case .currentLevel: return .number
            case .currentExperience: return .number
            case .moves: return .select
            case .heldItem: return .select
            case .sprite: return .select
            }
        }
        
        var selectionType: Selection.DataType? {
            switch self {
            case .species, .nickName, .currentLevel, .currentExperience: return nil
            case .moves: return .moves
            case .heldItem: return .heldItems
            case .sprite: return .sprites
            }
        }
    }
}
