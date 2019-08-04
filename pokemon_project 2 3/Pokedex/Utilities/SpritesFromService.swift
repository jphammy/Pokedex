import Foundation

struct SpritesFromService: Decodable {
    let sprites: [NameUrlPair]
    
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        
        var name: String {
            switch self {
            case .backDefault: return "Back Default"
            case .backFemale: return "Back Female"
            case .backShiny: return "Back Shiny"
            case .backShinyFemale: return "Back Shiny Female"
            case .frontDefault: return "Front Default"
            case .frontFemale: return "Front Female"
            case .frontShiny: return "Front Shiny"
            case .frontShinyFemale: return "Front Shiny Female"
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        sprites = try CodingKeys.allCases.compactMap {
            guard let url = try container.decodeIfPresent(URL.self, forKey: $0) else {
                return nil
            }
            
            return NameUrlPair(name: $0.name, url: url)
        }
    }
}
