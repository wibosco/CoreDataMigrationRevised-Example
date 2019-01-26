//
//  UIColor+Random.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 12/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Random
    
    static var randomPastelColor: UIColor {
        let mixColor = UIColor.white
        
        let randomColorGenerator = { ()-> CGFloat in
            CGFloat(arc4random() % 256) / 256
        }
        
        var red: CGFloat = randomColorGenerator()
        var green: CGFloat = randomColorGenerator()
        var blue: CGFloat = randomColorGenerator()
        
        var mixRed: CGFloat = 0
        var mixGreen: CGFloat = 0
        var mixBlue: CGFloat = 0
        mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)
        
        red = (red + mixRed) / 2
        green = (green + mixGreen) / 2
        blue = (blue + mixBlue) / 2
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
