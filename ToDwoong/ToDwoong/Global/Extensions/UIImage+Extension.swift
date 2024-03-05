//
//  UIImage+Extension.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/5/24.
//

import UIKit

extension UIImage {
    static func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    static func roundedImage(color: UIColor, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let roundedRect = CGRect(origin: .zero, size: size).insetBy(dx: 4, dy: 4)
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.setStrokeColor(UIColor.clear.cgColor)
            context.cgContext.setLineWidth(0)
            context.cgContext.addEllipse(in: roundedRect)
            context.cgContext.drawPath(using: .fillStroke)
        }
    }
}
