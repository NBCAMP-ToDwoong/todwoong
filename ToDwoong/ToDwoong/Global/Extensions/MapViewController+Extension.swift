//
//  MapViewController+Extension.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/8/24.
//

import CoreLocation
import MapKit
import UIKit

import TodwoongDesign

extension MapViewController {
    func zoomToTodo(_ todo: TodoModel, completion: @escaping () -> Void) {
        if let annotation = todoAnnotationMap[todo.id?.uuidString ?? ""] {
            let region = MKCoordinateRegion(center: annotation.coordinate,
                                            latitudinalMeters: 300,
                                            longitudinalMeters: 300)
            customMapView.mapView.setRegion(region, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion()
            }
        } else {
            completion()
        }
    }
}
