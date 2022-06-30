//
//  Colors.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/27/22.
//

import Foundation
import UIKit
import AVFoundation
import CoreGraphics

struct Colors {
    static var backgroundTan = UIColor(red: 242/255, green: 239/255, blue: 227/255, alpha: 1.0)
    static var titleBrown = UIColor(red: 104/255, green: 79/255, blue: 59/255, alpha: 1.0)
    
}

class ColorUtilities {
    static func getColorsFromRGB(rGB: [Double]) -> UIColor {
        return UIColor(red: rGB[0]/255, green: rGB[1]/255, blue: rGB[2]/255, alpha: 1.0)
    }
    static func getRGBFromColor(color: UIColor) -> [Double] {
        var colors: [Double] = []
        colors.append(CIColor(color: color).red*255)
        colors.append(CIColor(color: color).green*255)
        colors.append(CIColor(color: color).blue*255)
        
        return colors
    }
    static func blackOrWhiteText(color: UIColor) -> MoodColor {
        let colorComponents = (color.cgColor)
        
        let newColor = colorComponents.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        
        
        guard let components = newColor?.components, components.count >= 3 else {return .black}
    
        
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        
        return brightness < 0.5 ? .white : .black
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
