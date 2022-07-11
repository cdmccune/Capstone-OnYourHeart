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
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[$@$#!%*?&])(?=.*\\d)[A-Za-z\\d$@$#!%*?&]{8,}")
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
    
    //Calls tabBarController with 4 tabs with Account Page
    static func userIsLoggedIn(window: UIWindow?) {
        //Resets the lists
        FirebaseDataController.shared.lists = []
        
        let storyboard = UIStoryboard(name: Constants.Storyboard.mainStoryboard, bundle: nil)
        
        guard let homeNav = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.homeNavBar) as? UINavigationController else {return}
        guard let listNav = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.listNavBar) as? UINavigationController else {return}
        guard let discoverNav = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.discoverNavBar) as? UINavigationController else {return}
        guard let accountNav = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.accountNavBar) as? UINavigationController else {return}
        
        
        guard let tabBar = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController) as? UITabBarController else {return}

        
        tabBar.viewControllers = [homeNav, listNav, discoverNav, accountNav]
        tabBar.selectedIndex = 0
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }
    
    //Calls tabBarController with 4 tabs with Login Page
    static func userIsLoggedOut(window: UIWindow?) {
        //Sets the default list
        
        FirebaseDataController.shared.user = Constants.Firebase.defaultUser
        FirebaseDataController.shared.lists = FirebaseDataController.shared.user.lists
        
        //Add the correct tabBar
        let storyboard = UIStoryboard(name: Constants.Storyboard.mainStoryboard, bundle: nil)
        
        guard let homeNav = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.homeNavBar) as? UINavigationController else {return}
        guard let listNav = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.listNavBar) as? UINavigationController else {return}
        guard let discoverNav = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.discoverNavBar) as? UINavigationController else {return}
        guard let loginNav = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginNavController) as? UINavigationController else {return}
        
        guard let tabBar = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController) as? UITabBarController else {return}
        
        tabBar.viewControllers = [loginNav, homeNav, listNav, discoverNav]
        tabBar.selectedIndex = 0
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }
    
    static func presentNotLoggedInAlert(viewController: UIViewController, tabbar: UITabBarController?){
        let alert = UIAlertController(title: "Not Logged in", message: "Please login to access this feature", preferredStyle: .alert)
        
        let loginAction = UIAlertAction(title: "Login", style: .default) { _ in
            tabbar?.selectedIndex = 0
        }
        let continueAction = UIAlertAction(title: "Continue", style: .default)
        
        alert.addAction(loginAction)
        alert.addAction(continueAction)
        
        viewController.present(alert, animated: true)
        
    }
}
