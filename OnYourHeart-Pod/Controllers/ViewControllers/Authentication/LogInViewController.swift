//
//  LogInViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/21/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LogInViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helper Functions
    func setUpElements() {
        
        errorLabel.alpha = 0
        LoginUtilities.styleTextField(emailTF)
        LoginUtilities.styleTextField(passwordTF)
        LoginUtilities.styleFilledButton(loginButton)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        passwordTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        loginCheck()
        }
        
        func loginCheck() {
            //Validate Text Fields
            let error = validateFields()
            
            if let error = error {
                showError(error)
            }
            
            guard let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
            
            
            //Signing in the user
            Auth.auth().signIn(withEmail:email , password: password) { result, error in
                if let error = error {
                    self.errorLabel.text = "Incorrect username or password"
                    self.errorLabel.alpha = 1
                    print(error.localizedDescription)
                    return
                } else {
//                    let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController) as? UITabBarController
//
//                    self.view.window?.rootViewController = tabBarController
//                    self.view.window?.makeKeyAndVisible()
                    let window = self.view.window
                    LoginUtilities.userIsLoggedIn(window: window)
                }
        }
        
        
    }
    
    func validateFields() -> String? {
        //Check that all fields have values
        guard let email = emailTF.text, email != "", let password = passwordTF.text, password != "" else {
            return "Please fill in all fields"
        }
        return nil
    }
    
    func showError(_ message: String) {
        self.errorLabel.text = message
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            passwordTF.resignFirstResponder()
            loginCheck()
        }
        return true
    }
    
    
    
}
