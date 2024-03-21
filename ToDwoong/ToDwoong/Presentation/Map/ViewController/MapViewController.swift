//
//  MapViewController2.swift
//  ToDwoong
//
//  Created by yen on 3/21/24.
//

import MapKit
import UIKit

import SnapKit
import TodwoongDesign


class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    let regionRadius: CLLocationDistance = 1000 // 지도 확대/축소를 위한 범위 설정
    
    // MARK: - UI Properties
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
        setUI()
        setMapSetting()
        setLocationManager()
        addPinsToMap()
    }
    
}

// MARK: - Setting Method

extension MapViewController {
    func setUI() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setMapSetting() {
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isRotateEnabled = false
    }
    
    func setNavigationItem() {
        let locationButton = UIBarButtonItem(
            image: UIImage(systemName: "scope"),
            style: .plain,
            target: self,
            action: #selector(centerToUserLocation))
        navigationItem.rightBarButtonItem = locationButton
        
        navigationController?.navigationBar.tintColor = TDStyle.color.mainTheme
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = .white
        }
    }
    
    func setLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
}

// MARK: - Objc Method

extension MapViewController {
    @objc 
    func centerToUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionRadius,
                                            longitudinalMeters: regionRadius)
            mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: - Objc Method

extension MapViewController: MKMapViewDelegate {
    
    func addPinsToMap() {
        // 예시 위치 핀 추가
        let pinLocation = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
        let pin = MKPointAnnotation()
        pin.coordinate = pinLocation
        pin.title = "서울 시청"
        mapView.addAnnotation(pin)
        
        let pinLocation2 = CLLocationCoordinate2D(latitude: 35.1795, longitude: 129.0756)
        let pin2 = MKPointAnnotation()
        pin2.coordinate = pinLocation2
        pin2.title = "부산"
        mapView.addAnnotation(pin2)
        
        // 모든 핀이 보이도록 지도 범위 조정
        mapView.showAnnotations([pin, pin2], animated: true)
    }
    
    // 핀 클릭 시 확대
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        let region = MKCoordinateRegion(center: annotation.coordinate,
                                        latitudinalMeters: regionRadius,
                                        longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
}
