//
//  TopListsViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/30/22.
//

import UIKit
import FirebaseAuth

class TopListsViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    //MARK: - Helper Functions
    
    func updateViews() {
        
        guard Auth.auth().currentUser != nil else {
            notLoggedInAlert()
            return
        }
        
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.titleBrown]
        
        self.showSpinner()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        FirebaseDataController.shared.fetchTopBooks { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.tableView.reloadData()
                    self.removeSpinner()
                case .failure(let error):
                    self.removeSpinner()
                    print(error)
                    let alert = UIAlertController(title: "Error", message: "There was an error reaching the database", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Okay", style: .default) { action in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(okayAction)
                    self.present(alert, animated: true)
                }
            }
        }
        
    func notLoggedInAlert() {
            LoginUtilities.presentNotLoggedInAlert(viewController: self, tabbar: self.tabBarController)
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

extension TopListsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseDataController.shared.topBooksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.topBookCell, for: indexPath) as? TopBookTableViewCell else {return UITableViewCell()}
        
        cell.book = "\(indexPath.row+1). \(FirebaseDataController.shared.topBooksList[indexPath.row].name)"
        
        return cell
    }
}
