//
//  MoodScriptureViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/28/22.
//

import UIKit

class MoodScriptureViewController: UIViewController {

    //MARK: Properties
    @IBOutlet var copyrightLabel: UILabel!
    @IBOutlet var nextVerseButton: UIButton!
    @IBOutlet var scriptureView: UIView!
    @IBOutlet var scripture: UILabel!
    var listName: String = ""
    var currentVerse: ScriptureListEntry?
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showSpinner()
        
        updateViews()
        getVerses(from: listName)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentVerse = nil
    }
    
    
    //MARK: - Helper Functions
    func updateViews() {
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.titleBrown]
        
        scriptureView.layer.cornerRadius = 25
        scriptureView.layer.borderWidth = 2
        scriptureView.layer.borderColor = Colors.titleBrown.cgColor
    }
    
    func getVerses(from list: String) {
        FirebaseDataController.shared.getVerses(for: list) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let verses):
                    BibleController.shared.moodVerses = []
                    BibleController.shared.moodVerses = verses
                    
                    if verses.count > 1 {
                        self.nextVerseButton.isHidden = false
                        self.copyrightLabel.isHidden = false
                    }
                    
                    verses.count > 0 ? self.showNextVerse() : self.showDefaultText()
                    self.scriptureView.isHidden = false
                    self.removeSpinner()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func showNextVerse() {
        copyrightLabel.isHidden = false
        
        
        guard let theCurrentVerse = currentVerse else {
            currentVerse = BibleController.shared.moodVerses[0]
            title = BibleController.shared.moodVerses[0].scriptureTitle
            scripture.text = BibleController.shared.moodVerses[0].scriptureContent
            return}
        
        guard let index = BibleController.shared.moodVerses.firstIndex(of: theCurrentVerse) else {
            return}
        
        if BibleController.shared.moodVerses.count - 1 == index  {
            
            currentVerse = BibleController.shared.moodVerses[0]
            title = BibleController.shared.moodVerses[0].scriptureTitle
            scripture.text = BibleController.shared.moodVerses[0].scriptureContent
            return
        }
        let nextVerse = BibleController.shared.moodVerses[index + 1]
        title = nextVerse.scriptureTitle
        scripture.text = nextVerse.scriptureContent
        currentVerse = nextVerse
    }
    
    func showDefaultText() {
        title = listName
        scripture.text = "You need to add some scriptures to this list in the Discover Tab!"
    }
    
    @IBAction func nextVerseButtonTapped(_ sender: Any) {
        showNextVerse()
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
