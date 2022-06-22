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
                
                if let firstName = data[Constants.Firebase.firstNameKey], let lastName = data[Constants.Firebase.lastNameKey] {
                    self.nameLabel.text = "\(firstName) \(lastName)"
                }
                if let uid = data[Constants.Firebase.uidKey] {
                    self.idLabel.text = "\(uid)"
                }
            }
        }
    }
    

}