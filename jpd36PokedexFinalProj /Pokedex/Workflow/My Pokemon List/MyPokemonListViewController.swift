import UIKit

final class MyPokemonListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var model: MyPokemonListModel!
    private var pokemonPersistence: PokemonPersistence?
    private var pokemonServiceClient: PokemonServiceClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Reference: hackingwithswift.com/example-code/system/how-to-find-the-users-documents-directory
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let baseServiceClient = BaseServiceClient()
        let apiUrlProvider = UrlProvider()
        pokemonServiceClient = PokemonServiceClient(baseServiceClient: baseServiceClient, urlProvider: apiUrlProvider)
        pokemonPersistence = PokemonPersistence(atUrl: path, withDirectoryName: "AppPersistedData")
        model = MyPokemonListModel(delegate: self, pokemonServiceClient: pokemonServiceClient!, pokemonPersistence: pokemonPersistence!)
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
    // Function notifies tableView how many items are in its list
    // Essentially asks "How many items do I have?"
    // Reference: developer.apple.com/documentation/uikit/uitableviewdatasource/1614931-tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.storedPokemon.count
    }
    
    // Function create/decorates UITableViewCells for a given item
    // Essentially asks "What do the cells look like?"
    // Reference: developer.apple.com/documentation/uikit/uitableviewdatasource/1614861-tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokedexItem = model.storedPokemon[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonListCell")!
        cell.textLabel?.text = pokedexItem.nickName
        return cell
    }
    
    // How many sections do I have?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // Reference: stackoverflow.com/questions/29294099/delete-a-row-in-table-view-in-swift
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
        // Reference to DispatchQueue.main.async
        // medium.com/@broebling/dispatchqueue-main-the-main-queue-is-a-serial-queue-4607417fe535
        // developer.apple.com/documentation/dispatch/dispatchqueue
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.isHidden = false
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func show(pokemon: Pokemon, imageData: Data?) {
    }
}
