//
//  ScriptureListViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/23/22.
//

import UIKit

class ScriptureListViewController: UIViewController {

    //MARK: - Properties
    
    var chapterId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let chapterId = chapterId else {return}

        getScriptures(id: chapterId)
    }
    
    
    func getScriptures(id: String) {
        BibleController.shared.fetchChapter(id) { result in
            switch result {
            case .success(let verses):
                print("success")
            case .failure(let error):
                print(error)
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
