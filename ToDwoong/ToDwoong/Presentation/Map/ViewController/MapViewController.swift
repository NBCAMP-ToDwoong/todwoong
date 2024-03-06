//
//  MapViewController.swift
//  ToDwoong
//
//  Created by yen on 3/6/24.
//

import CoreLocation
import MapKit
import UIKit

class MapViewController: UIViewController {
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
        setLocationManager()
    }
    
    private func setMapView() {
        mapView = MKMapView()
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
    }
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // 장소에 따라서 지도에 핀이 추가되는 메서드
    func addPinForPlace(_ place: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(place) { [weak self] (placemerks, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemark = placemerks?.first, let location = placemark.location {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = place
                
                DispatchQueue.main.async {
                    strongSelf.mapView.addAnnotation(annotation)
                    
                    strongSelf.mapView.setCenter(annotation.coordinate, animated: true)
                }
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
            mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}
