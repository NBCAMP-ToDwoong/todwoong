//
//  MapViewController.swift
//  ToDwoong
//
//  Created by yen on 3/6/24.
//

import CoreLocation
import MapKit
import UIKit

import TodwoongDesign

class MapViewController: UIViewController {
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTodosAndPins()
    }
    
    private func loadTodosAndPins() {
        // 실제 Todo 데이터를 로드하고, 각 Todo의 장소에 맞는 핀을 생성
    }
    
    func addPinForPlace(_ place: String, colorName: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(place) { [weak self] (placemarks, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                let annotation = TodoAnnotation(coordinate: location.coordinate, title: place, colorName: colorName)
                DispatchQueue.main.async {
                    strongSelf.mapView.addAnnotation(annotation)
                }
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 위치 업데이트 처리
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 위치 서비스 권한 변경 처리
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let todoAnnotation = annotation as? TodoAnnotation {
            let reuseId = "marker"
            var markerView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
            if markerView == nil {
                markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                markerView?.canShowCallout = true
            } else {
                markerView?.annotation = annotation
            }
            let color = TDStyle.color.colorFromString(todoAnnotation.colorName)
            markerView?.markerTintColor = color ?? UIColor.green
            return markerView
        }
        return nil
    }
}

