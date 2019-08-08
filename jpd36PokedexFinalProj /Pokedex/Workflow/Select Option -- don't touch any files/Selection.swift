import Foundation

protocol Selectable {
    func selections(forDataType dataType: Selection.DataType) -> [Selection]
}

protocol SelectionDataType {
    var asSelection: Selection { get }
}

struct Selection {
    let title: String
}

extension Selection {
    enum DataType: String {
        case heldItems = "Held Items"
        case moves = "Moves"
        case sprites = "Sprites"
        
        var maximumSelectionCount: Int {
            switch self {
            case .heldItems, .sprites: return 1
            case .moves: return 4
            }
        }
    }
}

