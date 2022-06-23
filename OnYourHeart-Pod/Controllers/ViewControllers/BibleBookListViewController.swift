//
//  BibleBookListViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/22/22.
//

import UIKit

class BibleBookListViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
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
//                    print("success")
//                    print(books.count)
                    BibleController.shared.books = books
                    self.collectionView.reloadData()
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

extension BibleBookListViewController: UICollectionViewDelegate, UICollectionViewDataSource {



    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BibleController.shared.books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Storyboard.BibleBookCell, for: indexPath) as? BibleBookCollectionViewCell else {return UICollectionViewCell()}
        
        cell.book = BibleController.shared.books[indexPath.row]
        cell.translatesAutoresizingMaskIntoConstraints = true
        
        return cell
    }





}
