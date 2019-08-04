import Foundation

final class SpeciesViewModel {
    private let pokemon: Pokemon
    
    let properties: [PokemonDisplayProperties]
    
    var title: String { return pokemon.name }
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        self.properties = pokemon.displayProperties
    }
}

extension SpeciesViewModel {
    func detailType(at index: Int) -> Detail.DataType? {
        return properties[index].detailType
    }
    
    func hasDetails(forDataType dataType: Detail.DataType?) -> Bool {
        guard let dataType = dataType else { return false }
        
        return !pokemon.details(forDataType: dataType).isEmpty
    }
    
    func details(forDataType dataType: Detail.DataType) -> [Detail] {
        return pokemon.details(forDataType: dataType)
    }
}
