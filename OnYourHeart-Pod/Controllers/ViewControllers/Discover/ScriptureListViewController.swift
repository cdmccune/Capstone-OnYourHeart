//
//  ScriptureListViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/23/22.
//

import UIKit

class ScriptureListViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    
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
    }
    
    
    //MARK: - Helper Functions
    
    func updateViews(id: String) {
        self.pageTitle = FormatUtilities.getBookAndChapter(chapterId: id)
        titleLabel.text = self.pageTitle
        
        tableView.allowsMultipleSelection = true
    }
    
    func setUpAddButtonMenu(id: String) {
      
        
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
    
    func addTo(list: String, chapterId: String) {
        FirebaseDataController.shared.add(scriptures: self.scriptureNumbers, to: list, scriptureTitle: self.scriptureTitle, chapterId: chapterId, scriptureContent: self.scriptureContent) { result in
            switch result {
            case .success(_):
                print("success")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getScriptures(id: String) {
        BibleController.shared.fetchChapter(id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let verses):
                    BibleController.shared.verses = verses
                    self.tableView.reloadData()
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
