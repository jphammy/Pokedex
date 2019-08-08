import UIKit

class EditPokemonTableViewController: UITableViewController {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var currentLevelTextField: UITextField!
    @IBOutlet weak var currentExperienceTextField: UITextField!
    @IBOutlet weak var moveLabel: UILabel!
    @IBOutlet weak var spriteLabel: UILabel!
    @IBOutlet weak var heldItemLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private var model: EditPokemonModel!
    private var selectedSpecies: Pokemon?
    private var selectedMoves: [String]?
    private var selectedSprite: NameDataPair?
    private var caughtPokemon: CaughtPokemon?
    private var selectedSpeciesID: Int?
    private var uniqueID = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.caughtPokemon != nil {
            self.loadData(caughtPokemon: self.caughtPokemon!)
        }
        self.validateInputs()
    }
    
    // Segues for 'Edit' to 'Species' and 'List'
    private func openSpeciesSelection(currentSelectedSpecies: String) {
        self.performSegue(withIdentifier: "SelectSpecies", sender: currentSelectedSpecies)
    }
    
    private func openSelection(options: [Selection], selectionType: Selection.DataType, selectedTitles: [String]) {
        self.performSegue(withIdentifier: "SelectionList", sender: (options, selectionType, selectedTitles))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectSpecies", let currentSelection = sender as? String {
            let speciesSelectionViewController = segue.destination as! SpeciesSelectionViewController
            speciesSelectionViewController.setup(pokemonServiceClient: model.pokemonServiceClient, delegate: self, currentSelectedName: currentSelection)
        } else if segue.identifier == "SelectionList", let (selection, selectionType, selectedTitles) = sender as? ([Selection], Selection.DataType, [String]) {
            let selectionViewController = segue.destination as! SelectionListViewController
            let model = SelectionListModel(options: selection, selectionType: selectionType, selectedTitles: selectedTitles)
            
            selectionViewController.setup(model: model, delegate: self)
        }
    }
    
    // User Story 3 Validation: Nickname must be at least 3 characters,
    // currentlevel, current experience must not be empty (and must be an Int),
    private func validateInputs() {
        if self.speciesLabel.text! == "" {
            self.saveButton.isEnabled = false
        } else if self.nickNameTextField.text! == ""  || self.nickNameTextField.text!.count < 3 {
            self.saveButton.isEnabled = false
        } else if self.currentLevelTextField.text! == "" {
            self.saveButton.isEnabled = false
        } else if self.currentExperienceTextField.text! == "" {
            self.saveButton.isEnabled = false
        } else if self.moveLabel.text! == "Select move" {
            self.saveButton.isEnabled = false
        } else if self.spriteLabel.text! == "Select sprite" {
            self.saveButton.isEnabled = false
        } else {
            var helItem = ""
            if self.heldItemLabel.text! == "Select held item" {
                helItem = ""
            } else {
                helItem = self.heldItemLabel.text!
            }
            caughtPokemon = CaughtPokemon(collectionId: uniqueID,
                                          id: selectedSpeciesID!,
                                          species: self.speciesLabel.text!,
                                          nickName: self.nickNameTextField.text!,
                                          currentLevel: Int(self.currentLevelTextField.text!)!,
                                          currentExperience: Int(self.currentExperienceTextField.text!)!,
                                          moves: self.selectedMoves!,
                                          heldItem: helItem, sprite: self.selectedSprite!)
            self.saveButton.isEnabled = true
        }
    }
    
    private func loadData(caughtPokemon: CaughtPokemon) {
        self.speciesLabel.text = caughtPokemon.species
        self.nickNameTextField.text = caughtPokemon.nickName
        self.currentLevelTextField.text = "\(caughtPokemon.currentLevel)"
        self.currentExperienceTextField.text = "\(caughtPokemon.currentExperience)"
        self.moveLabel.text = caughtPokemon.moves.joined(separator: ",")
        self.spriteLabel.text = caughtPokemon.sprite.name
        self.imageView.image = UIImage(data: caughtPokemon.sprite.data)
        if caughtPokemon.heldItem == "" {
            resetHeldItem()
        } else {
            self.heldItemLabel.text = caughtPokemon.heldItem
        }
        
        selectedSpeciesID = caughtPokemon.id
        selectedMoves = caughtPokemon.moves
        selectedSprite = caughtPokemon.sprite
        uniqueID = caughtPokemon.collectionId
    }
    
    private func resetMove() {
        self.selectedMoves = nil
        self.moveLabel.text = "Select move"
    }
    
    private func resetSprite() {
        self.selectedSprite = nil
        self.spriteLabel.text = "Select sprite"
    }
    
    private func resetHeldItem() {
        self.heldItemLabel.text = "Select held item"
    }
}

extension EditPokemonTableViewController {
    func setup(pokemonServiceClient: PokemonServiceClient, pokemonPersistence: PokemonPersistence, delegate: MyPokemonListModelDelegate, selectedPokemon: CaughtPokemon?) {
        model = EditPokemonModel(pokemonServiceClient: pokemonServiceClient, pokemonPersistence: pokemonPersistence, delegate: delegate)
        if selectedPokemon != nil {
            self.caughtPokemon = selectedPokemon
        }
    }
}

extension EditPokemonTableViewController {
    @IBAction func doneButtonPressed() {
        self.view.endEditing(true)
        self.validateInputs()
    }
    
    @IBAction func saveButtonPressed() {
        model.savePokemon(caughtPokemon: self.caughtPokemon!)
        navigationController?.popViewController(animated: true)
        // Returns the view controller that was popped from the stack
    }
}

extension EditPokemonTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.inputAccessoryView = toolBar
        return true
    }
    
    @IBAction func textChange(sender: UITextField) {
        validateInputs()
    }
}

extension EditPokemonTableViewController {
    // Function used to interpret a cell being pressed
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // pokemon species is cell 0
            openSpeciesSelection(currentSelectedSpecies: self.speciesLabel.text!)
            break
        case 4: // move is cell 4
            if selectedSpecies != nil {
                let options = selectedSpecies!.moves.map { $0.asSelection }
                let selectedTitles = self.moveLabel.text!.split{$0 == ","}.map(String.init)
                openSelection(options: options, selectionType: .moves, selectedTitles: selectedTitles)
            }
            break
        case 5: // sprite is cell 5
            if selectedSpecies != nil {
                let options = selectedSpecies!.sprites.sprites.map { $0.asSelection }
                let selectedTitles = self.spriteLabel.text!.split{$0 == ","}.map(String.init)
                openSelection(options: options, selectionType: .sprites, selectedTitles: selectedTitles)
            }
            break
        case 6: // heldItem is cell 6
            if selectedSpecies != nil {
                let options = selectedSpecies!.heldItems.map { $0.asSelection }
                let selectedTitles = self.spriteLabel.text!.split{$0 == ","}.map(String.init)
                openSelection(options: options, selectionType: .heldItems, selectedTitles: selectedTitles)
            }
            break
        default:
            break
        }
    }
}

// Reference: hackingwithswift.com/read/9/4/back-to-the-main-thread-dispatchqueuemain
extension EditPokemonTableViewController: SpeciesSelectionModelDelegate {
    func update(withPokemonResult result: PokemonResult) {
        switch result {
        case .success(let pokemon):
            selectedSpecies = pokemon
            selectedSpeciesID = pokemon.id
            DispatchQueue.main.async { [weak self] in
                self?.resetMove()
                self?.resetSprite()
            }
            DispatchQueue.main.async { [weak self] in
                self?.speciesLabel.text = pokemon.name
            }
        case .failure(let error):
            print(error)
        }
        DispatchQueue.main.async { [weak self] in
            self?.validateInputs()
        }
    }
}

extension EditPokemonTableViewController: SelectionListViewControllerDelegate {
    func update(selections: [Selection], forType selectionType: Selection.DataType) {
        switch selectionType {
        case .moves:
            if selections.isEmpty {
                self.resetMove()
            } else {
                let moves = selections.map { $0.title }
                self.selectedMoves = moves
                self.moveLabel.text = moves.joined(separator: ",")
            }
        case .sprites:
            if selections.isEmpty {
                self.resetSprite()
            } else {
                let sprites = selections.map { $0.title }
                self.spriteLabel.text = sprites.joined(separator: ",")
                let pair = model.getSpriteNameDataPair(pokemon: selectedSpecies!, selectedSprite: sprites[0])
                self.selectedSprite = pair
                self.imageView.image = UIImage(data: pair.data)
            }
        case .heldItems:
            if selections.isEmpty {
                resetHeldItem()
            } else {
                let heldItems = selections.map { $0.title }
                self.heldItemLabel.text = heldItems.joined(separator: ",")
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.validateInputs()
        }
    }
}
