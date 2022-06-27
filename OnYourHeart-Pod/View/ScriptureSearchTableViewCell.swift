//
//  ScriptureSearchTableViewCell.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/27/22.
//

import UIKit

class ScriptureSearchTableViewCell: UITableViewCell {

    //Properties
    @IBOutlet var verseNameLabel: UILabel!
    @IBOutlet var verseTextLabel: UILabel!
    
    var searchVerse: SearchVerse? {
        didSet {
            updateViews()
        }
    }
    
    
    func updateViews() {
        guard let searchVerse = searchVerse else {return}
        verseNameLabel.text = searchVerse.reference
        verseTextLabel.text = searchVerse.text
    }
   
}
