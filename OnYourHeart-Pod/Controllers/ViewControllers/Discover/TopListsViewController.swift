//
//  TopListsViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/30/22.
//

import UIKit

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
        
        self.showSpinner()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        FirebaseDataController.shared.fetchTopBooks { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.tableView.reloadData()
                    self.removeSpinner()
                case .failure(let error):
                    print(error)
                }
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.topBookCell, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = FirebaseDataController.shared.topBooksList[indexPath.row].name
        
        cell.contentConfiguration = content
        
        return cell
    }
}
