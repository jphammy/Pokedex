import Foundation

protocol SpeciesSelectionModelDelegate: class {
    func update(withPokemonResult result: PokemonResult)
}

protocol SpeciesSelectionModelDisplayDelegate: class {
    func serviceBegan()
    func serviceComplete()
    func view(pokemon: Pokemon)
}

final class SpeciesSelectionModel {
    let species: [NameUrlPair]
    let currentSelectedIndex: Int?
    
    private let pokemonServiceClient: PokemonServiceClient
    
    private weak var delegate: SpeciesSelectionModelDelegate?
    private weak var displayDelegate: SpeciesSelectionModelDisplayDelegate?
    
    init(pokemonServiceClient: PokemonServiceClient, delegate: SpeciesSelectionModelDelegate, displayDelegate: SpeciesSelectionModelDisplayDelegate, currentSelectedName: String? = nil) {
        self.pokemonServiceClient = pokemonServiceClient
        self.delegate = delegate
        self.displayDelegate = displayDelegate
        
        guard let path = Bundle.main.path(forResource: "PokemonList", ofType: "json") else {
            let message = "Path to PokemonList json not found"
            Log.error(message)
            fatalError()
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            species = try JSONDecoder().decode([NameUrlPair].self, from: data)
        } catch {
            Log.error(error)
            fatalError()
        }
        
        currentSelectedIndex = species.firstIndex { $0.name.lowercased() == currentSelectedName?.lowercased() }
    }
    
    func viewCurrentSelection() {
        guard let currentSelectedIndex = currentSelectedIndex else { return }

        let url = species[currentSelectedIndex].url
        
        displayDelegate?.serviceBegan()
        pokemonServiceClient.getPokemon(fromUrl: url) { [weak self] result in
            self?.displayDelegate?.serviceComplete()
            
            switch result {
            case .success(let pokemon): self?.displayDelegate?.view(pokemon: pokemon)
            case .failure(let error): Log.error(error)
            }
        }
    }
    
    func selected(index: Int) {
        let url = species[index].url
        
        displayDelegate?.serviceBegan()
        pokemonServiceClient.getPokemon(fromUrl: url) { [weak self] result in
            self?.displayDelegate?.serviceComplete()
            self?.delegate?.update(withPokemonResult: result)
        }
    }
}
