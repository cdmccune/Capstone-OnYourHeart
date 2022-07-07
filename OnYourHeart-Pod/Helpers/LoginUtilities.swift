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
        
        bottomLine.backgroundColor = Colors.titleBrown.cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    //Filled Button Style
    static func styleFilledButton(_ button:UIButton) {
        button.backgroundColor = Colors.titleBrown
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    //Hollow Button Style
    static func styleHollowButton(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.titleBrown.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = Colors.titleBrown
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isEmailValid(_ email: String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailTest.evaluate(with: email)
    }
    
    
    //Checks if user is logged in
    static func isUserLoggedIn() -> Bool{
        return Auth.auth().currentUser != nil
    }
    
    //brings User to main tab bar
    static func routeToTB(window: UIWindow? ){
        let storyboard = UIStoryboard(name: Constants.Storyboard.mainStoryboard, bundle: nil)
        let tB  = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController) as? UITabBarController
        window?.rootViewController = tB
        window?.makeKeyAndVisible()
    }
    
    //Brings User to login screen
    static func routeToLogin(window: UIWindow?) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.mainStoryboard, bundle: nil)
        let navigationBar = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginNavController) as? UINavigationController
        window?.rootViewController = navigationBar
        window?.makeKeyAndVisible()
    }
    
}
