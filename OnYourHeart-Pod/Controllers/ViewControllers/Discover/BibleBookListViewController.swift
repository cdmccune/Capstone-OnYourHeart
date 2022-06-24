//
//  BibleBookListViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/22/22.
//

import UIKit

class BibleBookListViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var chapterNumberCollectionView: UICollectionView!
    
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getbooks()
        
    }
    

    //MARK: - Helper Functions
    
    func getbooks() {
        BibleController.shared.fetchBooks { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    BibleController.shared.books = books
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
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
        if collectionView == chapterNumberCollectionView {
            return BibleController.shared.chapters.count
        } else {
            return BibleController.shared.books.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == chapterNumberCollectionView {
            
            guard let cell = chapterNumberCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Storyboard.chapterNumberCell, for: indexPath) as? ChapterNumberCollectionViewCell else {return UICollectionViewCell()}
            
            cell.chapter = BibleController.shared.chapters[indexPath.row]
            cell.translatesAutoresizingMaskIntoConstraints = true
            
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Storyboard.bibleBookCell, for: indexPath) as? BibleBookCollectionViewCell else {return UICollectionViewCell()}
            
            cell.book = BibleController.shared.books[indexPath.row]
            cell.translatesAutoresizingMaskIntoConstraints = true
            
            return cell
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BibleBookCollectionViewCell {
            cell.bibleImage.tintColor = .black
            BibleController.shared.chapters = BibleController.shared.books[indexPath.row].chapters
            chapterNumberCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BibleBookCollectionViewCell {
            cell.bibleImage.tintColor = .systemBrown
            BibleController.shared.chapters = []
            chapterNumberCollectionView.reloadData()
        }
    }

    
    
    
    //For ChapterNumberCollectionView

    

}
