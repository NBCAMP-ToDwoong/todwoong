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
        loadTodosAndPins()
    }
    
    private func setMapView() {
        mapView = MKMapView()
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Todo데이터를 불러오고, 각 투두의 장소에 맞는 핀을 생성하는 메서드를 실행하는 메서드
    private func loadTodosAndPins() {
        // Core Data에서 Todo항목을 불러오는 로직이 작성 되어야 함
        let mockTodos = [
            ("서울"),
            ("부산"),
            ("대구")
        ]
        
    for todo in mockTodos {
            addPinForPlace(todo)
        }
    }
    
    // 장소를 입력받아서 해당 장소에 핀을 표시해주는 메서드
    func addPinForPlace(_ place: String) {
        let geocoder = CLGeocoder()
                
        geocoder.geocodeAddressString(place) { [weak self] (placemarks, error) in
            guard let strongSelf = self else { return }
                    
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                
                DispatchQueue.main.async {
                    strongSelf.mapView.addAnnotation(annotation)
                }
            }
        }
    }
        
    
    // 버튼을 눌렀을 때, 사용자의 현재 위치로 돌아가는 메서드
    @objc func moveToCurrentLocation() {
        if let currentLocation = locationManager.location {
            let region = MKCoordinateRegion(center: currentLocation.coordinate,
                                            latitudinalMeters: 300,
                                            longitudinalMeters: 300)
            mapView.setRegion(region, animated: true)
        }
    }
}

// Extension

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

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

}
