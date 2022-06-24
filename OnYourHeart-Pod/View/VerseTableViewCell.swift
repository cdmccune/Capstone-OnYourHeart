//
//  VerseTableViewCell.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/24/22.
//

import UIKit

class VerseTableViewCell: UITableViewCell {

    @IBOutlet var verseContentLabel: UILabel!
    @IBOutlet var verseCodeLabel: UILabel!
    
    var verse: Verse? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let verse = verse else {return}
        
        verseCodeLabel.text = FormatUtilities.formatVerseCode(verseId: verse.id)
        verseContentLabel.text = verse.content
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
