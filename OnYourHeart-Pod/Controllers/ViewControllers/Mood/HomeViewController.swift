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
    
    @IBOutlet var tableView: UITableView!
    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var uid: String?
    
    
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        do {
//           try Auth.auth().signOut()
//        } catch let e {
//            print(e)
//        }
        
        
//        Authentication check
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        guard let uid = uid else {return}

        DispatchQueue.main.async {
            self.db.collection(Constants.Firebase.usersKey).whereField(Constants.Firebase.uidKey, isEqualTo: uid).getDocuments { snapshot, error in
                if let error = error {
                    print(error)
                }
                if let snapshot = snapshot {
                    let data = snapshot.documents[0].data()
                    guard let user = User(from: data) else {return}
                    FirebaseDataController.shared.user = user
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }
    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseDataController.shared.user.lists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.moodCell, for: indexPath) as? MoodTableViewCell else {return UITableViewCell()}

        cell.list = FirebaseDataController.shared.user.lists[indexPath.row]
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Storyboard.segueMoodScriptureVC,
        let destinationVC = segue.destination as? MoodScriptureViewController,
        let index = tableView.indexPathForSelectedRow {
            destinationVC.listName = FirebaseDataController.shared.user.lists[index.row].name
        }
    }


}
