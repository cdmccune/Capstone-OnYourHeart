//
//  HomeViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/21/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {

    //MARK: - Properties
    
    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var uid: String?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var idLabel: UILabel!
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Authentication check
        handle = Auth.auth().addStateDidChangeListener({ auth, user in
            if let user = user {
                self.uid = user.uid
                self.updateViews()
            }
        })
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    //MARK: - Helper Functions
    
    func updateViews() {
        guard let uid = uid else {return}

        db.collection(Constants.Firebase.usersKey).whereField(Constants.Firebase.uidKey, isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                print(error)
            }
            if let snapshot = snapshot {
                let data = snapshot.documents[0].data()
                
                guard let user = User(from: data) else {return}
                
                FirebaseDataController.shared.user = user
                self.idLabel.text = user.uid
                self.nameLabel.text = user.firstName + " " + user.lastName
                print(user.lists.description)
            }
        }
    }
    

}
