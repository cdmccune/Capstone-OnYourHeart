//
//  DiscoverViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/22/22.
//

import UIKit

class DiscoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func fetchBooksButtonTapped(_ sender: Any) {
        print("pressed")
        
        DispatchQueue.main.async {
            BibleController.shared.fetchBooks { result in
                switch result {
                case .success(let books):
                    print(books.count)
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
