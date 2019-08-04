import Foundation

protocol MyPokemonListModelDelegate: class {
    func dataChanged()
    func show(pokemon: Pokemon, imageData: Data?)
}

final class MyPokemonListModel {
    private let pokemonServiceClient: PokemonServiceClient
    private let pokemonPersistence: PokemonPersistence
    private(set) var storedPokemon: [CaughtPokemon] = []
    private weak var delegate: MyPokemonListModelDelegate?
    
    init(delegate: MyPokemonListModelDelegate, pokemonServiceClient: PokemonServiceClient, pokemonPersistence: PokemonPersistence) {
        self.delegate = delegate
        self.pokemonServiceClient = pokemonServiceClient
        self.pokemonPersistence = pokemonPersistence
        
        storedPokemon = pokemonPersistence.caughtPokemon
    }
    
    func deletePokemon(fileName: UUID) {
        if pokemonPersistence.removeFile(withName: fileName.uuidString) {
            storedPokemon = pokemonPersistence.caughtPokemon
            delegate?.dataChanged()
        }
    }
    
    func reloadData() {
        storedPokemon = pokemonPersistence.caughtPokemon
    }
}

