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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let chapterId = chapterId else {return}

        getScriptures(id: chapterId)
        updateViews(id: chapterId)
    }
    
    func updateViews(id: String) {
        titleLabel.text = FormatUtilities.getBookAndChapter(chapterId: id)
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
    
    
}
