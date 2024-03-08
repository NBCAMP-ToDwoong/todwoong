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
    
    var customMapView: MapView!
    let locationManager = CLLocationManager()
    
    var todos: [TodoModel] = []
    var categories: [CategoryModel] = []
    
    override func loadView() {
        customMapView = MapView()
        view = customMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customMapView.mapView.delegate = self
        setLocationManager()
        createDummyData()
    }
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // 더미데이터 생성코드
    func createDummyData() {
        let allCategory = CategoryModel(id: UUID(), title: "전체", color: "bgGray", indexNumber: 0, todo: nil)
        let workCategory = CategoryModel(id: UUID(), title: "일", color: "bgRed", indexNumber: 1, todo: nil)
        let personalCategory = CategoryModel(id: UUID(), title: "운동", color: "bgBlue", indexNumber: 2, todo: nil)
        categories = [workCategory, personalCategory]
        categories.insert(allCategory, at: 0)

        let todos = [
            TodoModel(id: UUID(), title: "프로젝트 끝내기",
                      dueDate: Date(),
                      dueTime: Date(),
                      place: "서울",
                      isCompleted: false,
                      fixed: false,
                      timeAlarm: true,
                      placeAlarm: true,
                      category: workCategory),
            TodoModel(id: UUID(), title: "운동 가기",
                      dueDate: Date().addingTimeInterval(86400 * 2),
                      dueTime: Date(), place: "부산",
                      isCompleted: false,
                      fixed: false,
                      timeAlarm: true,
                      placeAlarm: true,
                      category: personalCategory)
        ]

        self.todos = todos

        loadCategoriesAndCategoryChips()
        loadTodosAndPins()
    }
    
    // Todo데이터를 불러오고, 각 투두의 장소에 맞는 핀을 생성하는 메서드를 실행하는 메서드
    private func loadTodosAndPins() {
        for todo in self.todos {
            if let place = todo.place, let categoryColor = todo.category?.color {
                addPinForPlace(place, colorName: categoryColor, category: todo.category?.title ?? "")
            }
        }
    }

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
        categories.forEach { category in
            customMapView.addCategoryChip(category: category, action: #selector(categoryChipTapped(_:)), target: self)
        }
    }
    
    @objc func categoryChipTapped(_ sender: TDCustomButton) {
        guard let title = sender.titleLabel?.text else { return }
        
        if title == "전체" {
            customMapView.mapView.annotations.forEach { annotation in
                guard let todoAnnotation = annotation as? TodoAnnotation else { return }
                customMapView.mapView.view(for: annotation)?.isHidden = false
            }
        } else {
            customMapView.mapView.annotations.forEach { annotation in
                guard let todoAnnotation = annotation as? TodoAnnotation else { return }
                customMapView.mapView.view(for: annotation)?.isHidden = todoAnnotation.category != title
            }
        }
        
        let detailVC = TodoDetailViewController()
        detailVC.selectedCategoryTitle = title
        detailVC.todos = self.todos
        detailVC.modalPresentationStyle = .pageSheet
        
        if let sheet = detailVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(detailVC, animated: true, completion: nil)
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
