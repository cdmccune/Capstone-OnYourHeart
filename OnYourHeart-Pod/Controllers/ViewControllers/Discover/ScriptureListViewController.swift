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
    @IBOutlet var addToListButton: UIBarButtonItem!
    
    var chapterId: String?
    var scriptureTitle: String = ""
    var scriptureNumbers: [Int] = []
    var pageTitle: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let chapterId = chapterId else {return}

        getScriptures(id: chapterId)
        updateViews(id: chapterId)
        setUpAddButtonMenu(id: chapterId)
    }
    
    func updateViews(id: String) {
        self.pageTitle = FormatUtilities.getBookAndChapter(chapterId: id)
        titleLabel.text = self.pageTitle
        
        tableView.allowsMultipleSelection = true
    }
    
    func setUpAddButtonMenu(id: String) {
        let lists = FirebaseDataController.shared.user.lists
        
        var actions: [UIAction] = []
        
        lists.forEach { list in
            let action = UIAction(title: list, image: UIImage(named: "book.fill")) { _ in
                self.addTo(list: list, chapterId: id)
            }
            actions.append(action)
        }
        
        let menu = UIMenu(title: "Add to List", options: .displayInline, children: actions)
        
        addToListButton.menu = menu
        
    }
    
    func addTo(list: String, chapterId: String) {
        FirebaseDataController.shared.add(scriptures: self.scriptureNumbers, to: list, scriptureTitle: self.scriptureTitle, chapterId: chapterId) { result in
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
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        guard let index = tableView.indexPathsForSelectedRows else {return}
        
        var scriptureNumbers = index.map({$0.row + 1})
        scriptureNumbers.sort()
        self.scriptureNumbers = scriptureNumbers
        
        self.scriptureTitle = FormatUtilities.getScriptureTitle(title: self.pageTitle, scriptureNumbers: self.scriptureNumbers)
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
                addToListButton.isEnabled = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = tableView.indexPathsForSelectedRows {
            if index.count < 1 {
                addToListButton.isEnabled = false
            }
        } else {
            addToListButton.isEnabled = false
        }
    }
    
    
}
