//
//  RGBColor.swift
//  Lyrics
//
//  Created by Martin Mitrevski on 31/05/15.
//  Copyright (c) 2015 Martin Mitrevski. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func RGBColorWithRed(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        let convertedRed = red / 255.0
        let convertedGreen = green / 255.0
        let convertedBlue = blue / 255.0
    
        return UIColor(red: convertedRed, green: convertedGreen, blue: convertedBlue, alpha: alpha)
    }
}