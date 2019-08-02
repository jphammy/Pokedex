import Foundation
import UIKit

class EditPokemonTableViewController: UITableViewController {
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var currentLevelTextField: UITextField!
    @IBOutlet weak var currentExperienceTextField: UITextField!
    //Still need to add a bunch more IBOutlets
    

    private var model: EditPokemonModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let baseServiceClient = BaseServiceClient()
        let apiUrlProvider = UrlProvider()
        let pokemonServiceClient = PokemonServiceClient(baseServiceClient: baseServiceClient, urlProvider: apiUrlProvider)
        
                //Reference: hackingwithswift.com/example-code/system/how-to-find-the-users-documents-directory
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pokemonPersistence = PokemonPersistence(atUrl: path, withDirectoryName: "AppPersistedData")
        
        model = EditPokemonModel(pokemonServiceClient: pokemonServiceClient, pokemonPersistence: pokemonPersistence!)

}
    
    // Adapted from proj 3, still a work in progress
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        inputValidation(textField: textField)
        if model.validInputs() {
            //addButtonOutlet.isEnabled = true
        }
        else {
            //addButtonOutlet.isEnabled = false
        }
        return true
    }
    
    func inputValidation (textField: UITextField){
        if textField == nickNameTextField {
            let validName = model.validNickName(NickName: nickNameTextField.text!)
            if validName.count > 0 {
                sendAlert(message: validName)
            }
        }
        if textField == currentLevelTextField {
            let validCurrentLevel = model.validCurrentLevel(CurrentLevel: currentLevelTextField.text!)
            if validCurrentLevel.count > 0 {
                sendAlert(message: validCurrentLevel)
            }
        }
        if textField == currentExperienceTextField {
            let validCurrentExperience = model.validCurrentExperience(CurrentExperience: currentExperienceTextField.text!)
            if validCurrentExperience.count > 0 {
                sendAlert(message: validCurrentExperience)
            }
        }

    }
    func sendAlert (message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(ok)
        
        if let presented = self.presentedViewController {
            presented.removeFromParent()
        }
        
        if presentedViewController == nil {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == currentLevelTextField || textField == currentExperienceTextField {
            let allowedChars = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedChars.isSuperset(of: characterSet)
        } else {
            return true
        }
        
    }
}


