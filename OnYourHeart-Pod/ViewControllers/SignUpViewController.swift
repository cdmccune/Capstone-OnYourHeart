//
//  SignUpViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/21/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    
    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var lastNameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        
        Utilities.styleTextField(firstNameTF)
        Utilities.styleTextField(lastNameTF)
        Utilities.styleTextField(emailTF)
        Utilities.styleTextField(passwordTF)
        Utilities.styleFilledButton(signUpButton)
        
        
    }

    //Check the fields that the data is correct
    
    func validateFields() -> String? {
        
        //Check that all fields are turned in
        if firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        //Check if password is valid
        
        let cleanPassword = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanPassword) {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        
        
        
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        //Validate Fields
        let error = validateFields()
        
        if let error = error {
            showError(error)
        } else {
            //Create User
            Auth.auth().createUser(withEmail: "", password: "") { result, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    self.showError("Error creating user")
                }
                
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: <#T##[String : Any]#>)
                
                
            }
        }
        
        //Create the user
        
        //Transition to the home screen
        
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
}
