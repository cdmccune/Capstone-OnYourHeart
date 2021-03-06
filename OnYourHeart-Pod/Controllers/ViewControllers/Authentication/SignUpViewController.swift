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

    //MARK: - Properties
    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var lastNameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
        passwordTF.delegate = self
        firstNameTF.delegate = self
        lastNameTF.delegate = self

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    //MARK: - Helper Functions
    func setUpElements() {
        errorLabel.alpha = 0
        
        LoginUtilities.styleTextField(firstNameTF)
        LoginUtilities.styleTextField(lastNameTF)
        LoginUtilities.styleTextField(emailTF)
        LoginUtilities.styleTextField(passwordTF)
        LoginUtilities.styleFilledButton(signUpButton)
        
        
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
        
        //Check if email is valid
        let cleanEmail = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !LoginUtilities.isEmailValid(cleanEmail) {
            return "Please make sure your email has been formatted properly (name@website.com)"
        }
        
        
        //Check if password is valid
        let cleanPassword = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !LoginUtilities.isPasswordValid(cleanPassword) {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        emailTF.resignFirstResponder()
        firstNameTF.resignFirstResponder()
        lastNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        signUp()
    }
    
    func signUp() {
        //Validate Fields
        let error = validateFields()
        
        if let error = error {
            showError(error)
        } else {
    
            //Create non-optional and clean data
            let firstName = firstNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            
            FirebaseDataController.shared.createUser(firstName: firstName, lastName: lastName, email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        if success {
                            self.transitionToHome()
                        }
                    case .failure(let error):
                        self.showError("Server error occurred")
                        print(error)
                    }
                }
            }
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
        print(message)
    }
    
    func transitionToHome() {
        let window = self.view.window
        
        LoginUtilities.userIsLoggedIn(window: window)
        
//        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController) as? UITabBarController
//        
//        self.view.window?.rootViewController = tabBarController
//        self.view.window?.makeKeyAndVisible()
    }
    
}


extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTF {
            lastNameTF.becomeFirstResponder()
        } else if textField == lastNameTF {
            emailTF.becomeFirstResponder()
        } else if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            passwordTF.resignFirstResponder()
            signUp()
        }
        return true
    }
    
    
    
}
