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

class ColorUtilities {
    static func getColorsFromRGB(rGB: [Double]) -> UIColor {
        return UIColor(red: rGB[0]/255, green: rGB[1]/255, blue: rGB[2]/255, alpha: 1.0)
    }
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
