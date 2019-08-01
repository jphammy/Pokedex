import Foundation

typealias PokemonResult = Result<Pokemon, ServiceCallError>
typealias SpritesDataResult = Result<[NameDataPair], ServiceCallError>
typealias SpriteDataResult = Result<NameDataPair, ServiceCallError>

final class PokemonServiceClient {
    private let baseServiceClient: BaseServiceClient
    private let urlProvider: UrlProvider
    
    private let pokemonUrl = URL(string: "https://pokeapi.co")!
    private let defaultPokemonPathComponents = ["api", "v2", "pokemon"]
    
    init(baseServiceClient: BaseServiceClient, urlProvider: UrlProvider) {
        self.baseServiceClient = baseServiceClient
        self.urlProvider = urlProvider
    }
    
    func getPokemon(fromUrl url: URL, completion: @escaping (PokemonResult) -> ()) {
        baseServiceClient.get(from: url) { result in
            switch result {
            case .success(let data):
                guard let pokemon = try? JSONDecoder().decode(Pokemon.self, from: data) else {
                    completion(.failure(ServiceCallError(message: "Failed to parse json", code: nil)))
                    return
                }
                
                completion(.success(pokemon))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func getPokemon(byId id: Int) -> PokemonResult {
        let lock = DispatchSemaphore(value: 0)
        
        var result: PokemonResult = .failure(ServiceCallError(message: "Internal Error", code: 0))

        let pathComponents = defaultPokemonPathComponents + ["\(id)"]
        let url = urlProvider.url(forBaseUrl: pokemonUrl, pathComponents: pathComponents, parameters: [:])
        getPokemon(fromUrl: url) { pokemonResult in
            defer { lock.signal() }

            switch pokemonResult {
            case .success(let pokemon): result = .success(pokemon)
            case .failure( let error):
                Log.error(error)
                result = .failure(error)
            }
        }
        
        lock.wait()
        
        return result
    }
    
    func getSpriteData(sprites: [NameUrlPair]) -> [NameDataPair] {
        var spritesData: [NameDataPair] = []
        
        sprites.forEach {
            switch getSprite(from: $0) {
            case .success(let nameDataPair): spritesData.append(nameDataPair)
            case .failure(let error): Log.error(error)
            }
        }
        
        Log.info("Successfully retrieved \(spritesData.count) sprites")
        
        return spritesData
    }
}

extension PokemonServiceClient {
    private func getSprite(from nameUrlPair: NameUrlPair) -> SpriteDataResult {
        let lock = DispatchSemaphore(value: 0)
        
        var result: SpriteDataResult = .failure(ServiceCallError(message: "Internal Error", code: 0))
        
        baseServiceClient.get(from: nameUrlPair.url) { serviceResult in
            defer { lock.signal() }
            
            switch serviceResult {
            case .success(let data): result = .success(NameDataPair(name: nameUrlPair.name, data: data))
            case .failure( let error): result = .failure(error)
            }
        }
        
        lock.wait()
        
        return result
    }
}
