//
//  BibleBookListViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/22/22.
//

import UIKit

class BibleBookListViewController: UIViewController {

    //MARK: - Properties
    var pageLoaded: Bool = false
    @IBOutlet var bookLabelButton: UIButton!
    //    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var bibleBookTableView: UITableView!
    @IBOutlet var chapterNumberCollectionView: UICollectionView!
    
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showSpinner()
        getbooks()
        addNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let index = bibleBookTableView.indexPathForSelectedRow {
            bookLabelButton.setTitle(BibleController.shared.books[index.row].name, for: .normal)
        }
            
    }
    

    //MARK: - Helper Functions
    func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(couldNotConnect),
                                               name: NSNotification.Name(Constants.Notifications.couldNotConnect),
                                               object: nil)
    }
    
    @objc func couldNotConnect() {
        self.removeSpinner()
        
        if !pageLoaded {
        
        let alert = UIAlertController(title: "Error", message: "There was an error reaching the database", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okayAction)
        self.present(alert, animated: true)
        }
    }
    
    func getbooks() {
        BibleController.shared.fetchBooks { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    self.pageLoaded = true
                    self.bibleBookTableView.isHidden = false
                    self.chapterNumberCollectionView.isHidden = true
                    BibleController.shared.books = books
                    self.bibleBookTableView.reloadData()
                    self.removeSpinner()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @IBAction func bookButtonPressed(_ sender: Any) {
        bibleBookTableView.isHidden = false
        chapterNumberCollectionView.isHidden = true
        bookLabelButton.setTitle("Book", for: .normal)
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == Constants.Storyboard.segueScriptureListVC,
           let destinationVC = segue.destination as? ScriptureListViewController,
           let indexPath = chapterNumberCollectionView.indexPathsForSelectedItems?.first {
           destinationVC.chapterId = BibleController.shared.chapters[indexPath.row].id
        }
    }


}

extension BibleBookListViewController: UICollectionViewDelegate, UICollectionViewDataSource {


    
    //For Bible Book Collection View

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return BibleController.shared.chapters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            guard let cell = chapterNumberCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Storyboard.chapterNumberCell, for: indexPath) as? ChapterNumberCollectionViewCell else {return UICollectionViewCell()}
            
            cell.chapter = BibleController.shared.chapters[indexPath.row]
            cell.translatesAutoresizingMaskIntoConstraints = true
            
            return cell
            
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BibleBookCollectionViewCell {
           
            cell.bibleImage.tintColor = .black
            BibleController.shared.chapters = BibleController.shared.books[indexPath.row].chapters
            chapterNumberCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BibleBookCollectionViewCell {
            
            cell.bibleImage.tintColor = .systemBrown
            BibleController.shared.chapters = []
            chapterNumberCollectionView.reloadData()
        }
    }
}

extension BibleBookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return BibleController.shared.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.bibleBookCell, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        switch cell.isSelected {
        case true:
            content.text = "selected"
        case false:
            content.text = BibleController.shared.books[indexPath.row].name
        }
        

        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = bibleBookTableView.cellForRow(at: indexPath) else {return}
        
        
        bookLabelButton.setTitle(BibleController.shared.books[indexPath.row].name, for: .normal)

        bibleBookTableView.isHidden = true
        chapterNumberCollectionView.isHidden = false
        
        BibleController.shared.chapters = BibleController.shared.books[indexPath.row].chapters
        chapterNumberCollectionView.reloadData()
        
    }
}
