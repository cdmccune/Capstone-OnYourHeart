//
//  AccountViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 7/8/22.
//

import UIKit
import FirebaseAuth
import SafariServices

class AccountViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet var privacyPolicyButton: UIButton!
    @IBOutlet var deleteAccountButton: UIButton!
    @IBOutlet var logOutButton: UIButton!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
    }
    
    //MARK: - Helper Functions
    
    func style() {
        LoginUtilities.styleFilledButton(logOutButton)
        LoginUtilities.styleHollowButton(deleteAccountButton)
        LoginUtilities.styleFilledButton(privacyPolicyButton)
        deleteAccountButton.tintColor = .red
        privacyPolicyButton.layer.cornerRadius = 15
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.titleBrown]
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let window = self.view.window
            self.tabBarController?.view.removeFromSuperview()
            LoginUtilities.userIsLoggedOut(window: window)
        } catch let e {
            print(e)
        }
    }
    @IBAction func deleteTapped(_ sender: Any) {
        
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
            print(error)
          }
        }
        
        FirebaseDataController.shared.deleteUser { result in
            
            DispatchQueue.main.async {
            switch result {
            case .success(_):
                let user = Auth.auth().currentUser

                user?.delete { error in
                  if let error = error {
                    print(error)
                  } else {
                      let window = self.view.window
                      LoginUtilities.userIsLoggedOut(window: window)
                  }
                }
            case .failure(let error):
                print(error)
            }
            }
            
        }
    }
    @IBAction func privacyTapped(_ sender: Any) {
        guard let url = URL(string: "http://curtmccune.com/OYHPrivacyPolicy/") else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)

    }
}
