import Foundation

final class PokemonPersistence: FileStoragePersistence {
    let directoryUrl: URL
    let fileType: String = "json"
    
    init?(atUrl baseUrl: URL, withDirectoryName name: String) {
        guard let directoryUrl = FileManager.default.createDirectory(atUrl: baseUrl, appendingPath: name) else {
            return nil
        }
        self.directoryUrl = directoryUrl
    }
    
    var caughtPokemon: [CaughtPokemon] {
        return names.compactMap {
            guard let workoutData = read(fileWithId: $0) else { return nil }
            
            return try? JSONDecoder().decode(CaughtPokemon.self, from: workoutData)
        }
    }
    
    func save(pokemon: CaughtPokemon) {
        save(object: pokemon, withId: pokemon.collectionId.uuidString)
    }
}
