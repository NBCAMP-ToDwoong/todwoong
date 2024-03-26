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
    var group: String
    var groupIndexNumber: Int
    
    init(coordinate: CLLocationCoordinate2D,
         title: String,
         colorName: String,
         group: String,
         groupIndexNumber: Int) {
        self.coordinate = coordinate
        self.title = title
        self.colorName = colorName
        self.group = group
        self.groupIndexNumber = groupIndexNumber
        
        super.init()
    }
}

class ColoredAnnotation: MKPointAnnotation {
    var pinColor: UIColor?
}
