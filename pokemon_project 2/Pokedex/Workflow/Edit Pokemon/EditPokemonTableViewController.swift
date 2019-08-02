import Foundation
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
    private var caughtPokenmon: CaughtPokemon?
    private var selectedSpeciesID: Int?
    private var uniqueID = UUID()
    private var placeholderTextColor = UIColor(red: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.caughtPokenmon != nil {
            self.loadData(caughtPokemon: self.caughtPokenmon!)
        }
        self.validateInputs()
    }
    
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
    
    private func validateInputs() {
        if self.speciesLabel.text! == "" {
            self.saveButton.isEnabled = false
        } else if self.nickNameTextField.text! == ""  || self.nickNameTextField.text!.count < 4 {
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
            caughtPokenmon = CaughtPokemon(collectionId: uniqueID, id: selectedSpeciesID!, species: self.speciesLabel.text!, nickName: self.nickNameTextField.text!, currentLevel: Int(self.currentLevelTextField.text!)!, currentExperience: Int(self.currentExperienceTextField.text!)!, moves: self.selectedMoves!, heldItem: helItem, sprite: self.selectedSprite!)
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
            self.heldItemLabel.textColor = .black
        }
        
        self.speciesLabel.textColor = .black
        self.moveLabel.textColor = .black
        self.spriteLabel.textColor = .black
        
        selectedSpeciesID = caughtPokemon.id
        selectedMoves = caughtPokemon.moves
        selectedSprite = caughtPokemon.sprite
        uniqueID = caughtPokemon.collectionId
    }
    
    private func resetMove() {
        self.selectedMoves = nil
        self.moveLabel.text = "Select move"
        self.moveLabel.textColor = placeholderTextColor
    }
    
    private func resetSprite() {
        self.selectedSprite = nil
        self.spriteLabel.text = "Select sprite"
        self.spriteLabel.textColor = placeholderTextColor
    }
    
    private func resetHeldItem() {
        self.heldItemLabel.text = "Select held item"
        self.heldItemLabel.textColor = placeholderTextColor
    }
}

extension EditPokemonTableViewController {
    func setup(pokemonServiceClient: PokemonServiceClient, pokemonPersistence: PokemonPersistence, delegate: MyPokemonListModelDelegate, selectedPokemon: CaughtPokemon?) {
        model = EditPokemonModel(pokemonServiceClient: pokemonServiceClient, pokemonPersistence: pokemonPersistence, delegate: delegate)
        if selectedPokemon != nil {
            self.caughtPokenmon = selectedPokemon
        }
    }
}

extension EditPokemonTableViewController {

}

extension EditPokemonTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.inputAccessoryView = toolBar
        return true
}
//someting here

//

    extension EditPokemonTableViewController {
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch indexPath.section {
            case 0:
                openSpeciesSelection(currentSelectedSpecies: self.speciesLabel.text!)
                break
            case 4:
                if selectedSpecies != nil {
                    let options = selectedSpecies!.moves.map { $0.asSelection }
                    let selectedTitles = self.moveLabel.text!.split{$0 == ","}.map(String.init)
                    openSelection(options: options, selectionType: .moves, selectedTitles: selectedTitles)
                }
                break
            case 5:
                if selectedSpecies != nil {
                    let options = selectedSpecies!.sprites.sprites.map { $0.asSelection }
                    let selectedTitles = self.spriteLabel.text!.split{$0 == ","}.map(String.init)
                    openSelection(options: options, selectionType: .sprites, selectedTitles: selectedTitles)
                }
                break
            case 6:
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
                    self?.speciesLabel.textColor = .black
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
                    self.moveLabel.textColor = .black
                }
            case .sprites:
                if selections.isEmpty {
                    self.resetSprite()
                } else {
                    let sprites = selections.map { $0.title }
                    self.spriteLabel.text = sprites.joined(separator: ",")
                    self.spriteLabel.textColor = .black
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
                    self.heldItemLabel.textColor = .black
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.validateInputs()
            }
        }
}


