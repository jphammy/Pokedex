import UIKit

final class SpeciesSelectionViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var viewSelectionButton: UIBarButtonItem!
    
    private var model: SpeciesSelectionModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSelectionButton.isEnabled = model.currentSelectedIndex != nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let speciesViewController = segue.destination as? SpeciesViewController, let pokemon = sender as? Pokemon else { return }
        
        let model = SpeciesViewModel(pokemon: pokemon)
        speciesViewController.setup(model: model)
    }
}

extension SpeciesSelectionViewController {
    func setup(pokemonServiceClient: PokemonServiceClient, delegate: SpeciesSelectionModelDelegate, currentSelectedName: String?) {
        let model = SpeciesSelectionModel(pokemonServiceClient: pokemonServiceClient, delegate: delegate, displayDelegate: self, currentSelectedName: currentSelectedName)
        self.model = model
    }
}

extension SpeciesSelectionViewController {
    @IBAction private func viewSelectionButtonTapped(_ sender: UIBarButtonItem) {
        model.viewCurrentSelection()
    }
}

extension SpeciesSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.species.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let species = model.species[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpeciesCell")!
        cell.textLabel?.text = species.name
        cell.accessoryType = indexPath.row == model.currentSelectedIndex ? .checkmark : .none
        
        return cell
    }
}

extension SpeciesSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.selected(index: indexPath.row)
    }
}

extension SpeciesSelectionViewController: SpeciesSelectionModelDisplayDelegate {
    func serviceBegan() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    func serviceComplete() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func view(pokemon: Pokemon) {
        DispatchQueue.main.async { [weak self] in
            self?.performSegue(withIdentifier: "ViewSpecies", sender: pokemon)
        }
    }
}
