//
//  Utilities.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/21/22.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseAuth

class LoginUtilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isUserLoggedIn() -> Bool{
        return Auth.auth().currentUser != nil
    }
    
    static func routeToTB(window: UIWindow? ){
        let storyboard = UIStoryboard(name: Constants.Storyboard.mainStoryboard, bundle: nil)
        let tB  = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController) as? UITabBarController
        window?.rootViewController = tB
        window?.makeKeyAndVisible()
    }
    
    static func routeToLogin(window: UIWindow?) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.mainStoryboard, bundle: nil)
        let navigationBar = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginNavController) as? UITabBarController
        window?.rootViewController = navigationBar
        window?.makeKeyAndVisible()
    }
    
}
