//
//  ListsViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/22/22.
//

import UIKit
import FirebaseAuth

class ListsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getListData()
        
        
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getListData() {
        
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            let window = self.view.window
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

extension ListsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return FirebaseDataController.shared.lists.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FirebaseDataController.shared.lists[section].name
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if FirebaseDataController.shared.
        
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.listCell, for: indexPath)
        
        let content = cell.defaultContentConfiguration()
        content.text =
        
        
    }
    
    
}
