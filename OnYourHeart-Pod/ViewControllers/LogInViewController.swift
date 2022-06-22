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

    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTF)
        Utilities.styleTextField(passwordTF)
        Utilities.styleFilledButton(loginButton)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
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
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
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
