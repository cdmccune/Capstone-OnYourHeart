//
//  ScriptureListViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/23/22.
//

import UIKit
import FirebaseAuth

class ScriptureListViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var copyrightLabel: UILabel!
    var chapterId: String?
    var scriptureTitle: String = ""
    var scriptureNumbers: [Int] = []
    var pageTitle: String = ""
    var scriptureContent: String = ""
    var addToListButton = UIBarButtonItem()
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let chapterId = chapterId else {return}

        getScriptures(id: chapterId)
        updateViews(id: chapterId)
        setUpAddButtonMenu(id: chapterId)
        setUpNotificationListeners()
    }
    
    
    //MARK: - Helper Functions
    
    func setUpNotificationListeners() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(heardEventPost),
                                               name: NSNotification.Name(rawValue: Constants.Notifications.listAdded),
                                               object: nil)
    }
    
    func updateViews(id: String) {
        self.pageTitle = FormatUtilities.getBookAndChapter(chapterId: id)
        titleLabel.text = self.pageTitle
        tableView.allowsMultipleSelection = true
        titleLabel.textColor = Colors.titleBrown
    }
    
    @objc func heardEventPost() {
        guard let chapterId = chapterId else {return}
        setUpAddButtonMenu(id: chapterId)
    }
    
    func setUpAddButtonMenu(id: String) {
        
        guard Auth.auth().currentUser != nil else {
            self.addToListButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(notLoggedInAlert))
            self.navigationItem.setRightBarButton(self.addToListButton, animated: true)
            return
        }
        
        //Adding the button (Required to show menu on primary action)
        self.addToListButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:nil)
        self.navigationItem.setRightBarButton(self.addToListButton, animated: true)
        
        
        let lists = FirebaseDataController.shared.user.lists
        
        var actions: [UIAction] = []
        
        lists.forEach { list in
            let action = UIAction(title: list.name, image: UIImage(named: "book.fill")) { _ in
                self.addTo(list: list.name, chapterId: id)
            }
            actions.append(action)
        }
        
        let menu = UIMenu(title: "Add to List", options: .displayInline, children: actions)
        
        addToListButton.menu = menu
    }
    
    @objc func notLoggedInAlert() {
        LoginUtilities.presentNotLoggedInAlert(viewController: self, tabbar: self.tabBarController)
    }
    
    func addTo(list: String, chapterId: String) {
        FirebaseDataController.shared.add(scriptures: self.scriptureNumbers, to: list, scriptureTitle: self.scriptureTitle, chapterId: chapterId, scriptureContent: self.scriptureContent) { result in
            switch result {
            case .success(let verse):
                if let index = FirebaseDataController.shared.lists.firstIndex(where: {$0.name == list}) {
                    FirebaseDataController.shared.lists[index].scriptureListEntries.append(verse)
                }
                NotificationCenter.default.post(name: NSNotification.Name(Constants.Notifications.scriptureAdded), object: self)
                self.tableView.selectRow(at: nil, animated: true, scrollPosition: .top)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getScriptures(id: String) {
        self.showSpinner()
        BibleController.shared.fetchChapter(id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let verses):
                    print("success")
                    BibleController.shared.verses = verses
                    self.tableView.reloadData()
                    self.removeSpinner()
                    self.copyrightLabel.isHidden = false
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    func highlightedScripturesChanged(index: [IndexPath]) {
        
        
        var scriptureNumbers = index.map({$0.row + 1})
        scriptureNumbers.sort()
        self.scriptureNumbers = scriptureNumbers
        
        scriptureContent = ""
        scriptureNumbers.forEach({self.scriptureContent = "\(scriptureContent)" + "\(BibleController.shared.verses[$0 - 1].content)"})
        
        self.scriptureTitle = FormatUtilities.getScriptureTitle(title: self.pageTitle, scriptureNumbers: self.scriptureNumbers)
    }

}


//MARK: - Tableview Functions

extension ScriptureListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BibleController.shared.verses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.verseCell) as? VerseTableViewCell  else {return UITableViewCell()}
        
        cell.verse = BibleController.shared.verses[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = tableView.indexPathsForSelectedRows {
            if index.count > 0 {
                highlightedScripturesChanged(index: index)
                addToListButton.isEnabled = true
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = tableView.indexPathsForSelectedRows {
            if index.count < 1 {
                addToListButton.isEnabled = false
            } else {
                highlightedScripturesChanged(index: index)
            }
        } else {
            addToListButton.isEnabled = false
        }
    }
    
    
}
