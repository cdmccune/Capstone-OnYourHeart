//
//  Colors.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/27/22.
//

import Foundation
import UIKit
import AVFoundation

struct Colors {
    static var backgroundTan = UIColor(red: 242/255, green: 239/255, blue: 227/255, alpha: 1.0)
    static var titleBrown = UIColor(red: 104/255, green: 79/255, blue: 59/255, alpha: 1.0)
    
}


enum MoodColor: String {
    case black
    case white
    
    var create: UIColor {
        switch self {
        case .black:
            return UIColor.black
        case .white:
            return UIColor.white
        }
    }
}
