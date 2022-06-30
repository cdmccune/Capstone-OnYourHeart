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
    @IBOutlet var favoriteButton: UIBarButtonItem!
    
    var tag: Int = 0
    var favVerse: ScriptureListEntry?
    
    
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
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        
        guard let favVerse = favVerse else {return}

        
        FirebaseDataController.shared.setFavoriteVerse(verse: favVerse) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.tableView.selectRow(at: nil, animated: false, scrollPosition: .top)
                    NotificationCenter.default.post(name: NSNotification.Name(Constants.Notifications.favVerseUpdated), object: self)
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

extension ListDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return FirebaseDataController.shared.lists[tag].scriptureListEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.listVerseCell, for: indexPath) as? ListVerseTableViewCell else {return UITableViewCell()}
        
        cell.verse = FirebaseDataController.shared.lists[tag].scriptureListEntries[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let verse = FirebaseDataController.shared.lists[tag].scriptureListEntries[indexPath.row]
            
            FirebaseDataController.shared.delete(scripture: verse) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        FirebaseDataController.shared.lists[self.tag].scriptureListEntries.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .left)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favoriteButton.isEnabled = true
        favVerse =
        FirebaseDataController.shared.lists[tag].scriptureListEntries[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        favoriteButton.isEnabled = false
    }
    
    
    
}
