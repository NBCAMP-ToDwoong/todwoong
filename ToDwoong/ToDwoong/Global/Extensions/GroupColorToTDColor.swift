//
//  GroupColorToTDColor.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/5/24.
//

import UIKit

import TodwoongDesign

public extension TDColor {
    func colorFromString(_ colorName: String) -> UIColor? {
        switch colorName {
        case "lightGray":
            return lightGray
        case "mainTheme":
            return mainTheme
        case "mainDarkTheme":
            return mainDarkTheme
        case "primaryLabel":
            return primaryLabel
        case "secondaryLabel":
            return secondaryLabel
        case "bgGray":
            return bgGray
        case "bgRed":
            return bgRed
        case "bgOrange":
            return bgOrange
        case "bgYellow":
            return bgYellow
        case "bgGreen":
            return bgGreen
        case "bgBlue":
            return bgBlue
        case "bgPurple":
            return bgPurple
        case "textRed":
            return textRed
        case "textOrangeYellow":
            return textOrangeYellow
        case "textGreen":
            return textGreen
        case "textBlue":
            return textBlue
        case "textPurple":
            return textPurple
        default:
            return nil
        }
    }
}
