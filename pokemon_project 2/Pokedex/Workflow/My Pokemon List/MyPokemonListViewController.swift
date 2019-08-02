import UIKit

final class MyPokemonListViewController: UIViewController {
    
    private var model: MyPokemonListModel!
    private var pokemonPersistence: PokemonPersistence?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Work in progress
        let baseServiceClient = BaseServiceClient()
        let apiUrlProvider = UrlProvider()
        let pokemonServiceClient = PokemonServiceClient(baseServiceClient: baseServiceClient, urlProvider: apiUrlProvider)
        
        //Reference: hackingwithswift.com/example-code/system/how-to-find-the-users-documents-directory
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        pokemonPersistence = PokemonPersistence(atUrl: path, withDirectoryName: "AppPersistedData")
        
        //model = MyPokemonListModel(delegate: self, pokemonServiceClient: pokemonServiceClient, pokemonPersistence: pokemonPersistence!)
    }
}




