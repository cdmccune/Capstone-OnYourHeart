//
//  MoodTableViewCell.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/28/22.
//

import UIKit

class MoodTableViewCell: UITableViewCell {

    @IBOutlet var moodLabel: UILabel!
    
    var list: ListItem? {
        didSet {
            updateViews()
        }
    }
    

    func updateViews() {
        guard let list = list else {return}
        moodLabel.text = list.name
        
        let color = UIColor(red: list.color[0]/255, green: list.color[1]/255, blue: list.color[2]/255, alpha: 1)
        let textColor = MoodColor(rawValue: list.textColor)?.create ?? .black
        
        moodLabel.textColor = textColor
        self.backgroundColor = color
    }
}
