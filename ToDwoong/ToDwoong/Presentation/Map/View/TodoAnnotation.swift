//
//  TodoAnnotation.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/7/24.
//

import MapKit
import UIKit

import TodwoongDesign

class TodoAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var colorName: String
    var category: String
    var categoryIndexNumber: Int
    
    init(coordinate: CLLocationCoordinate2D,
         title: String,
         colorName: String,
         category: String,
         categoryIndexNumber: Int) {
        self.coordinate = coordinate
        self.title = title
        self.colorName = colorName
        self.category = category
        self.categoryIndexNumber = categoryIndexNumber
        
        super.init()
    }
}
