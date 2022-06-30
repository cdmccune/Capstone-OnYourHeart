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
        
    }

    //MARK: - Helper Functions
    func setUpAddButtonMenu() {
      
        
        //Adding the button (Required to show menu on primary action)
        self.addVerseBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:nil)
        self.navigationItem.setRightBarButton(self.addVerseBarButton, animated: true)
        
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
            case .success(_):
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
