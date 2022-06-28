//
//  MoodScriptureViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/28/22.
//

import UIKit

class MoodScriptureViewController: UIViewController {

    //MARK: Properties
    
    var listName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showVerse(from: listName)
    }
    
    func showVerse(from list: String) {
        
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
