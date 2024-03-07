//
//  UIColor+Extension.swift
//  ToDwoong
//
//  Created by yen on 3/5/24.
//

import UIKit

extension UIColor {
    func toHex(includeHashSign: Bool = true) -> String? {
        var rColor: CGFloat = 0
        var gColor: CGFloat = 0
        var bColor: CGFloat = 0
        var aColor: CGFloat = 0
        
        guard self.getRed(&rColor, green: &gColor, blue: &bColor, alpha: &aColor) else {
            return nil
        }
        
        let rgb: Int = (Int)(rColor*255)<<16 | (Int)(gColor*255)<<8 | (Int)(bColor*255)<<0
        
        return includeHashSign ? String(format: "#%06x", rgb) : String(format: "%06x", rgb)
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
