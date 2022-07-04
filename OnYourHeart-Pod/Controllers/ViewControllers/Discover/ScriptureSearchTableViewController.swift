//
//  ScriptureSearchTableViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/27/22.
//

import UIKit

class ScriptureSearchTableViewController: UITableViewController {

    //MARK: Properties
    @IBOutlet var copyrightLabel: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var addVerseBarButton: UIBarButtonItem!
    var searchVerse: SearchVerse?
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

     setUpAddButtonMenu()
     setUpNotificationListeners()
        
    }

    //MARK: - Helper Functions
    
    func setUpNotificationListeners() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(heardEventPost),
                                               name: NSNotification.Name(rawValue: Constants.Notifications.listAdded),
                                               object: nil)
    }
    
    @objc func heardEventPost() {
        setUpAddButtonMenu()
    }
    
    func setUpAddButtonMenu() {
        
        let lists = FirebaseDataController.shared.user.lists
        
        var actions: [UIAction] = []
        
        lists.forEach { list in
            let action = UIAction(title: list.name, image: UIImage(named: "book.fill")) { _ in
                self.addTo(list: list.name)
            }
            actions.append(action)
        }
        
        let menu = UIMenu(title: "Add to List", options: .displayInline, children: actions)
        
        addVerseBarButton.menu = menu
        
    }
    
    func addTo(list: String) {
        
        guard let searchVerse = searchVerse else {return}
        let scriptures = FormatUtilities.getVerseFromId(verseId: searchVerse.id)
        
        FirebaseDataController.shared.add(scriptures:scriptures, to: list, scriptureTitle: searchVerse.reference, chapterId: searchVerse.chapterId, scriptureContent: searchVerse.text) { result in
            switch result {
            case .success(let verse):
                if let index = FirebaseDataController.shared.lists.firstIndex(where: {$0.name == list}) {
                    FirebaseDataController.shared.lists[index].scriptureListEntries.append(verse)
                }
                NotificationCenter.default.post(name: NSNotification.Name(Constants.Notifications.scriptureAdded), object: self)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return BibleController.shared.searchVerses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.searchVerseCell, for: indexPath) as? ScriptureSearchTableViewCell else {return UITableViewCell()}


        cell.searchVerse = BibleController.shared.searchVerses[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addVerseBarButton.isEnabled = true
        searchVerse = BibleController.shared.searchVerses[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        addVerseBarButton.isEnabled = false
        
    }
}


extension ScriptureSearchTableViewController: UISearchBarDelegate {
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("changed")
//    }
    
    
    
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        
        guard let text = searchBar.text, text != "" else { return }


        BibleController.shared.fetchQuery(text) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let scriptures):
                    BibleController.shared.searchVerses = scriptures
                    self.searchBar.resignFirstResponder()
                    self.tableView.reloadData()
                    self.copyrightLabel.isHidden = false
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
