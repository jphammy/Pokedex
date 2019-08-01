import Foundation
// - **NickName** **MUST** be at least 3 characters long
// **CurrentLevel** and **CurrentExperience** **MUST** be numbers
struct user {
    var NickName = ""
    var CurrentLevel = ""
    var CurrentExperience = ""
}

class userData {
    var myUser = [user]()
    var displayUser = [String]()
    var inputTracker = [String]()
    
    func addNewUser(NickName:String, CurrentLevel:String, CurrentExperience:String) {
        let newUser = user(NickName: NickName, CurrentLevel: CurrentLevel, CurrentExperience: CurrentExperience)
 
        displayUser.append("NickName: \(newUser.NickName)\nCurrentLevel: \(newUser.CurrentLevel)\nCurrentExperience: \(newUser.CurrentExperience)")
        myUser.append(newUser)
        inputTracker = []
    }
    
    func validNickName (NickName: String) -> String {
        if (NickName.isEmpty){
            return ("A NickName is required")
        }
        else if (NickName.count) < 3  {
            return "NickName must be at least 3 characters" //Must be at least 3 letters
        }
        else {
            inputTracker.append("NickName")
            return ""
        }
    }
    
    func validCurrentLevel (CurrentLevel: String) -> String {
        if (CurrentLevel.isEmpty){
            return ("CurrentLevel is required")
        }
        else if (CurrentLevel.count) < 1  {
            return "CurrentLevel must be at least 1 character"
        }
        else {
            inputTracker.append("CurrentLevel")
            return ""
        }
    }
    
    func validCurrentExperience (CurrentExperience: String) -> String {
        if (CurrentExperience.count < 1) {
            return "CurrentExperience must be at least 1 character"
        }
        else {
            inputTracker.append("CurrentExperience")
            return ""
        }
    }
    
    func validInputs() -> Bool {
        if inputTracker.contains("NickName"), inputTracker.contains("CurrentLevel"), inputTracker.contains("CurrentExperience")
        {
            return true
        }
        else {
            return false
        }
    }
}


