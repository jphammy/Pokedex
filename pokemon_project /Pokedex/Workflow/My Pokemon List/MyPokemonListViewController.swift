import UIKit

final class MyPokemonListViewController: UIViewController {
    
    private var model: MyPokemonListModel!
    private var pokemonPersistence: PokemonPersistence?
    private var pokemonServiceClient: PokemonServiceClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Reference: hackingwithswift.com/example-code/system/how-to-find-the-users-documents-directory
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //Work in progress
        let baseServiceClient = BaseServiceClient()
        let apiUrlProvider = UrlProvider()
        let pokemonServiceClient = PokemonServiceClient(baseServiceClient: baseServiceClient, urlProvider: apiUrlProvider)
        

        
        pokemonPersistence = PokemonPersistence(atUrl: path, withDirectoryName: "AppPersistedData")
        
        model = MyPokemonListModel(delegate: self, pokemonServiceClient: pokemonServiceClient, pokemonPersistence: pokemonPersistence!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListToDetail", let caughtPokemon = sender as? CaughtPokemon {
            let editPokemonTableViewController = segue.destination as! EditPokemonTableViewController
            editPokemonTableViewController.setup(pokemonServiceClient: pokemonServiceClient!, pokemonPersistence: pokemonPersistence!, delegate: self, selectedPokemon: caughtPokemon)
        } else if segue.identifier == "ListToDetail" {
            let editPokemonTableViewController = segue.destination as! EditPokemonTableViewController
            editPokemonTableViewController.setup(pokemonServiceClient: pokemonServiceClient!, pokemonPersistence: pokemonPersistence!, delegate: self, selectedPokemon: nil)
        }
    }
}

extension MyPokemonListViewController {
    @IBAction func addButtonPressed() {
        self.performSegue(withIdentifier: "ListToDetail", sender: self)
    }
}

extension MyPokemonListViewController: UITableViewDataSource, UITableViewDelegate {
    // This function asks 'How many items do I have (in a given section, for now we will stick with 1)?'
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.storedPokemon.count
    }
    
    // This function asks 'What do the cells look like?'
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokedexItem = model.storedPokemon[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonListCell")!
        cell.textLabel?.text = pokedexItem.nickName
        return cell
    }
    
    // This function asks 'How many sections do I have?'
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            model.deletePokemon(fileName: model.storedPokemon[indexPath.row].collectionId)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "ListToDetail", sender: model.storedPokemon[indexPath.row])
    }
}


extension MyPokemonListViewController: MyPokemonListModelDelegate {
    func dataChanged() {
        model.reloadData()
        DispatchQueue.main.async { [weak self] in
            // getting compiler errors still
//            self?.tableView.reloadData()
//            self?.tableView.isHidden = false
//            self?.activityIndicator.stopAnimating()
        }
    }
    
    func show(pokemon: Pokemon, imageData: Data?) {
        
    }
}






