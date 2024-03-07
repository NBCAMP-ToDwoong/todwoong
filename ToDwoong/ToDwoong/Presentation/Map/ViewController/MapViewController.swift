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

struct DummyCategory {
    let title: String
    let color: String
}

class MapViewController: UIViewController {
    
    var customMapView: MapView!
    let locationManager = CLLocationManager()
    
    var categories: [DummyCategory] = []
    
    override func loadView() {
        customMapView = MapView()
        view = customMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customMapView.mapView.delegate = self
        setLocationManager()
        loadTodosAndPins()
        loadCategoriesAndCategoryChips()
    }
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Todo데이터를 불러오고, 각 투두의 장소에 맞는 핀을 생성하는 메서드를 실행하는 메서드
    private func loadTodosAndPins() {
        let categories = [
            "직장": "bgBlue",
            "취미": "bgRed",
            "운동": "bgGreen"
        ]

        let mockTodos = [
            (title: "프로젝트 끝내기", place: "서울", category: "직장"),
            (title: "체육관", place: "부산", category: "운동"),
            (title: "밥먹기", place: "대구", category: "취미")
        ]
        
        mockTodos.forEach { todo in
            let colorName = categories[todo.category] ?? "bgBlue" // 기본 색상
            addPinForPlace(todo.place, colorName: colorName, category: todo.category)
        }
    }

    // 장소, 색상 이름, 카테고리를 입력받아 해당 장소에 핀을 표시해주는 메서드
    func addPinForPlace(_ place: String, colorName: String, category: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(place) { [weak self] (placemarks, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                let annotation = TodoAnnotation(coordinate: location.coordinate, title: place, colorName: colorName, category: category)
                
                DispatchQueue.main.async {
                    strongSelf.customMapView.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    private func loadCategoriesAndCategoryChips() {
        
        categories = [
            DummyCategory(title: "직장", color: "bgBlue"),
            DummyCategory(title: "학교", color: "bgRed"),
            DummyCategory(title: "운동", color: "bgGreen"),
            DummyCategory(title: "취미", color: "bgYellow"),
            DummyCategory(title: "공부", color: "bgBlue"),
            DummyCategory(title: "여행", color: "bgBlue"),
            DummyCategory(title: "여행", color: "bgBlue"),
            DummyCategory(title: "여행", color: "bgBlue"),
            DummyCategory(title: "여행", color: "bgBlue")
        ]
        
        categories.forEach { category in
            customMapView.addCategoryChip(category: category, action: #selector(categoryChipTapped(_:)), target: self)
        }
    }
    
    @objc func categoryChipTapped(_ sender: TDCustomButton) {
        guard let title = sender.titleLabel?.text else { return }
            customMapView.mapView.annotations.forEach { annotation in
            guard let todoAnnotation = annotation as? TodoAnnotation else { return }
            customMapView.mapView.view(for: annotation)?.isHidden = todoAnnotation.category != title
        }
    }
    
    // 버튼을 눌렀을 때, 사용자의 현재 위치로 돌아가는 메서드
    @objc func moveToCurrentLocation() {
        if let currentLocation = locationManager.location {
            let region = MKCoordinateRegion(center: currentLocation.coordinate,
                                            latitudinalMeters: 300,
                                            longitudinalMeters: 300)
            customMapView.mapView.setRegion(region, animated: true)
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
            customMapView.mapView.setRegion(region, animated: true)
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
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let coordinate = view.annotation?.coordinate {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            mapView.setRegion(region, animated: true)
        }
        
        let detailVC = TodoDetailViewController()
        detailVC.modalPresentationStyle = .pageSheet
        
        if let sheet = detailVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(detailVC, animated: true, completion: nil)
    }

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
