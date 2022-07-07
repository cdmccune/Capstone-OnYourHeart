//
//  ListDetailViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/29/22.
//

import UIKit

class ListDetailViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet var copyrightLabel: UILabel!
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
        if FirebaseDataController.shared.lists[tag].scriptureListEntries.count > 0 {
            copyrightLabel.isHidden = false 
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        
        guard let favVerse = favVerse else {
            return}
        
        FirebaseDataController.shared.setFavoriteVerse(verse: favVerse) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    let _ : String? = nil
                case .failure(let error):
                    print(error)
                }
            }
        }
        FirebaseDataController.shared.favVerse = favVerse
        self.tableView.selectRow(at: nil, animated: false, scrollPosition: .top)
        NotificationCenter.default.post(name: NSNotification.Name(Constants.Notifications.favVerseUpdated), object: self)
        self.favoriteButton.isEnabled = false
    }
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
                        NotificationCenter.default.post(name: NSNotification.Name(Constants.Notifications.scriptureAdded), object: self)
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
