//
//  UIColor+Hex.swift
//  CoreDataMigration-Example
//
//  Created by William Boles on 12/09/2017.
//  Copyright © 2017 William Boles. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Hex
    
    var hexString: String {
        let components = self.cgColor.components
        
        let red = Float((components?[0])!)
        let green = Float((components?[1])!)
        let blue = Float((components?[2])!)
        
        return String(format: "%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
    }
    
    static func colorWithHex(hexColor: String) -> UIColor? {
        guard hexColor.count == 6 else {
            return nil
        }
        
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        guard scanner.scanHexInt64(&hexNumber) else {
            return nil
        }
        
        let red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
        let green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
        let blue = CGFloat(hexNumber & 0x0000ff) / 255
        let alpha = CGFloat(1)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
