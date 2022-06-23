//
//  BibleBookCollectionViewCell.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/22/22.
//

import UIKit

class BibleBookCollectionViewCell: UICollectionViewCell {
    
    //Properties
    
    
    @IBOutlet var bibleImage: UIImageView!
    @IBOutlet var bookNameLabel: UILabel!
    
    
    
    
    var book: Book? {
        didSet{
            updateViews()
        }
    }
    
    func updateViews() {
        guard let book = book else {return}

        bookNameLabel.text = book.abbreviation
        
        
    }
    
    
    
}
