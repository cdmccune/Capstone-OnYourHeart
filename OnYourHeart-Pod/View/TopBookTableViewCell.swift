//
//  TopBookTableViewCell.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 7/6/22.
//

import UIKit

class TopBookTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet var bookNameLabel: UILabel!
    
    var book: String? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Helper Functions
    
    func updateViews() {
        guard let book = book else {return}

        bookNameLabel.text = book
    }
    
}
