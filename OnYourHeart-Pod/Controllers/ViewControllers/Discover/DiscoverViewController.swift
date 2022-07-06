//
//  DiscoverViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/22/22.
//

import UIKit
import FirebaseAuth

class DiscoverViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet var openBibleLabel: UILabel!
    @IBOutlet var keywordSearchLabel: UILabel!
    @IBOutlet var topBooksLabel: UILabel!
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
    }
    
    //MARK: - Helper Functions
    
    
    func setUpViews() {
        
        //Underlines for the labels
        let labels = [openBibleLabel, keywordSearchLabel, topBooksLabel]
        labels.forEach { label in
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: label!.text!)
            attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            label!.attributedText = attributeString
        }
        
        //Sets large title to brown
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.titleBrown]
    }

    @IBAction func logOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let window = self.view.window
            LoginUtilities.routeToLogin(window: window )
            FirebaseDataController.shared.user = AppUser(firstName: "john", lastName: "doe", uid: "2")
            FirebaseDataController.shared.lists = []
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
