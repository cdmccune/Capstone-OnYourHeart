//
//  ListsViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/22/22.
//

import UIKit
import FirebaseAuth

class ListsViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("linked")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        print("trying")
        do {
            try Auth.auth().signOut()
            let window = self.view.window
            print("logged out")
            LoginUtilities.routeToLogin(window: window )
        } catch let e {
            print(e)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
