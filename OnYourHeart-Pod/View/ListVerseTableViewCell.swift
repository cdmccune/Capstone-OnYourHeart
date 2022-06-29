//
//  ListVerseTableViewCell.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/29/22.
//

import UIKit

class ListVerseTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet var verseNameLabel: UILabel!
    @IBOutlet var verseContentLabel: UILabel!
    var verse: ScriptureListEntry? {
        didSet {
            updateViews()
        }
    }
    
    
    //MARK: - Helper Functions

    func updateViews() {
        guard let verse = verse else {return}

        verseNameLabel.text = verse.scriptureTitle
        verseContentLabel.text = verse.scriptureContent
        
    }
    
}
