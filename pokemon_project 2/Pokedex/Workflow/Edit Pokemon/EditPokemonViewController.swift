import Foundation
import UIKit

class EditPokemonViewController: UIViewController, UITextFieldDelegate {
    
    let model = userData()

    @IBOutlet weak var nickName: UITextField!

    @IBOutlet weak var currentLevel: UITextField!
    
    @IBOutlet weak var currentExperience: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickName.delegate = self
        currentLevel.delegate = self
        currentExperience.delegate = self

}
    
    // Functions section
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
        if textField == nickName {
            let validName = model.validNickName(NickName: nickName.text!)
            if validName.count > 0 {
                sendAlert(message: validName)
            }
        }
        if textField == currentLevel {
            let validCurrentLevel = model.validCurrentLevel(CurrentLevel: currentLevel.text!)
            if validCurrentLevel.count > 0 {
                sendAlert(message: validCurrentLevel)
            }
        }
        if textField == currentExperience {
            let validCurrentExperience = model.validCurrentExperience(CurrentExperience: currentExperience.text!)
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

        if textField == currentLevel || textField == currentExperience {
            let allowedChars = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedChars.isSuperset(of: characterSet)
        } else {
            return true
        }
        
    }
}


