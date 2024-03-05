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
