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
    static var backgroundTan = UIColor(red: 242/256, green: 239/256, blue: 227/256, alpha: 1.0)
    
    
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
