import Foundation

final class EditPokemonModel {
    let pokemonServiceClient: PokemonServiceClient
    let pokemonPersistence: PokemonPersistence
    private weak var delegate: MyPokemonListModelDelegate?
    
    init(pokemonServiceClient: PokemonServiceClient, pokemonPersistence: PokemonPersistence, delegate: MyPokemonListModelDelegate) {
        self.pokemonServiceClient = pokemonServiceClient
        self.pokemonPersistence = pokemonPersistence
        self.delegate = delegate
    }
    
    func savePokemon(caughtPokemon: CaughtPokemon) {
        self.pokemonPersistence.save(pokemon: caughtPokemon)
        self.delegate?.dataChanged()
    }
    
    func getSpriteNameDataPair(pokemon: Pokemon, selectedSprite: String ) -> NameDataPair {
        var nameDataPair: NameDataPair?
        let nameDataPairs = pokemonServiceClient.getSpriteData(sprites: pokemon.sprites.sprites)
        for pair in nameDataPairs {
            if pair.name == selectedSprite {
                nameDataPair = pair
                break
            }
        }
        return nameDataPair!
    }
}
