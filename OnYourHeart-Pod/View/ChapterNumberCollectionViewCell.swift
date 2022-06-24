//
//  ChapterNumberCollectionViewCell.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/23/22.
//

import UIKit

class ChapterNumberCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    @IBOutlet var circleImage: UIImageView!
    @IBOutlet var numberLabel: UILabel!
    
    var chapter: Chapter? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Helper Functions
    
    func updateViews() {
        guard let chapter = chapter else {return}
        numberLabel.text = chapter.number
    }
    
    
}
