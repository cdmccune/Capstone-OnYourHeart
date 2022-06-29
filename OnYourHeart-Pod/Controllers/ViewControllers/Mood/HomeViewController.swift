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
    
    
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Authentication check
        handle = Auth.auth().addStateDidChangeListener({ auth, user in
            if let user = user {
//                let newUser = AppUser(
//                FirebaseDataController.shared.user = newUser
                self.updateViews(uid: user.uid)
            }
        })
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    //MARK: - Helper Functions
    
    func updateViews(uid: String) {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        FirebaseDataController.shared.getUserInfo(uid: uid) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    FirebaseDataController.shared.user = user
                    
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
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