//
//  ListDetailViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/29/22.
//

import UIKit

class ListDetailViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet var tableView: UITableView!
    
    var tag: Int = 0
    
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
  
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    //MARK: - Helper Functions
    
    func updateViews() {
        guard let newTag = FirebaseDataController.shared.currentListTag else {return}
        
        tag = newTag
        title = FirebaseDataController.shared.lists[tag].name
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

extension ListDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let tag = FirebaseDataController.shared.currentListTag else {return 0}
        
        return FirebaseDataController.shared.lists[tag].scriptureListEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.listVerseCell, for: indexPath) as? ListVerseTableViewCell else {return UITableViewCell()}
        
//        guard let tag = FirebaseDataController.shared.currentListTag else {return UITableViewCell()}
        
        cell.verse = FirebaseDataController.shared.lists[tag].scriptureListEntries[indexPath.row]
        
        return cell
    }
    
    
}
