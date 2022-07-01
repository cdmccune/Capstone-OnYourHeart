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

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helper Functions
    

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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.listCell, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = FirebaseDataController.shared.lists[indexPath.section].scriptureListEntries[indexPath.row].scriptureTitle
        
        cell.contentConfiguration = content
        
        return cell
    }
}
