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
    
    // MARK: - Instance
    
    var initialTodo: TodoModel?
    var customMapView: MapView!
    // 핀 크기관련 프로퍼티... 현재 작동하지않음
//    var selectedAnnotation: MKAnnotation?
    let locationManager = CLLocationManager()
    
    // MARK: - Data Storage
    
    var todos: [Todo] = []
    var categories: [Category] = []
    var todoAnnotationMap: [String: TodoAnnotation] = [:]
    
    // MARK: - Lifecycle
    
    override func loadView() {
        customMapView = MapView()
        view = customMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customMapView.mapView.delegate = self
        setLocationManager()
        setNavigationBar()
        
        loadCategoriesAndCategoryChips()
        loadTodosAndPins()
        
        customMapView.groupChipsView.groupListButton.addTarget(self,
                                                                  action: #selector(showGroupList),
                                                                  for: .touchUpInside)
        
        customMapView.groupChipsView.selectCategoryButton(customMapView.groupChipsView.allGroupButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = .clear
            
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let todo = initialTodo {
            zoomToTodo(todo) {}
            initialTodo = nil
        }
    }
    
    // MARK: - Setting Method
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setNavigationBar() {
        let leftBarButtonItem = UIBarButtonItem(
            title: "< Back",
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let locationImage = UIImage(named: "currentLocationIcon")?.resizableImage(withCapInsets: UIEdgeInsets(top: 9,
                                                                                                              left: 9,
                                                                                                              bottom: 9,
                                                                                                              right: 9),
                                                                                  resizingMode: .stretch)
        let rightBarButtonItem = UIBarButtonItem(
            image: locationImage,
            style: .plain,
            target: self,
            action: #selector(moveToCurrentLocation)
        )
        rightBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -112.5)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        // 네비게이션 색상 설정
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = .clear
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }

    private func loadTodosAndPins() {
        todos = CoreDataManager.shared.readTodos()
        for todo in todos {
            if let place = todo.place, let categoryColor = todo.category?.color {
                addPinForPlace(place,
                               colorName: categoryColor,
                               category: todo.category?.title ?? "",
                               todo: todo.toTodoModel())
            }
        }
    }

    func addPinForPlace(_ place: String, colorName: String, category: String, todo: TodoModel) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(place) { [weak self] (placemarks, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                let categoryIndexNumber = Int(todo.category?.indexNumber ?? 0)
                
                let annotation = TodoAnnotation(coordinate: location.coordinate,
                                                title: todo.title,
                                                colorName: colorName,
                                                category: category,
                                                categoryIndexNumber: categoryIndexNumber)
                
                strongSelf.todoAnnotationMap[todo.id?.uuidString ?? ""] = annotation
                
                DispatchQueue.main.async {
                    strongSelf.customMapView.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    private func loadCategoriesAndCategoryChips() {
        categories = CoreDataManager.shared.readCategories()
        categories.forEach { category in
            customMapView.addCategoryChip(category: category.toCategoryModel(),
                                          action: #selector(categoryChipTapped(_:)), target: self)
        }
    }
    
    private func selectCategory(_ category: CategoryModel) {
        guard let chipButton = customMapView.groupChipsView.groupStackView.arrangedSubviews.first(where: {
            ($0 as? TDCustomButton)?.titleLabel?.text == category.title
        }) as? TDCustomButton else {
            return
        }
        
        categoryChipTapped(chipButton)
    }
    
    // MARK: - Objc Func
    
    @objc func categoryChipTapped(_ sender: TDCustomButton) {
        let indexNumber = sender.tag
        customMapView.groupChipsView.selectCategoryButton(sender)
        
        customMapView.mapView.annotations.forEach { annotation in
            guard let view = customMapView.mapView.view(for: annotation) else { return }
            view.isHidden = !(annotation is TodoAnnotation)
        }
        
        if indexNumber == -1 {
            customMapView.mapView.annotations.forEach { annotation in
                customMapView.mapView.view(for: annotation)?.isHidden = !(annotation is TodoAnnotation)
            }
        } else {
            customMapView.mapView.annotations.forEach { annotation in
                guard let todoAnnotation = annotation as? TodoAnnotation else { return }
                customMapView.mapView.view(for: annotation)?.isHidden
                = todoAnnotation.categoryIndexNumber != indexNumber
            }
        }
        
        let detailVC = TodoDetailViewController()
        
        detailVC.selectedCategoryIndex = indexNumber
        detailVC.modalPresentationStyle = .pageSheet
        
        if let sheet = detailVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(detailVC, animated: true, completion: nil)
    }


    @objc func allGroupButtonTapped(_ sender: TDCustomButton) {
        customMapView.groupChipsView.selectCategoryButton(sender)
        
        customMapView.mapView.annotations.forEach { annotation in
            if annotation is TodoAnnotation {
                customMapView.mapView.view(for: annotation)?.isHidden = false
            }
        }

        let detailVC = TodoDetailViewController()
        detailVC.selectedCategoryTitle = "전체"
        detailVC.todos = CoreDataManager.shared.readTodos().map { $0.toTodoModel() }
        detailVC.modalPresentationStyle = .pageSheet
        
        if let sheet = detailVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(detailVC, animated: true, completion: nil)
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
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
    
    @objc private func showGroupList() {
        let groupListViewController = GroupListViewController()
        navigationController?.pushViewController(groupListViewController, animated: true)
    }
}

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
        
        switch status {
            case .denied, .restricted:
                promptForLocationServices()
            case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            @unknown default:
                break
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
        
        if let todoAnnotation = view.annotation as? TodoAnnotation {
            let filteredTodos
            = CoreDataManager.shared.readTodos()
                .filter { $0.category?.title == todoAnnotation.category }
                .map { $0.toTodoModel() }
            detailVC.todos = filteredTodos
            if let index = categories.firstIndex(where: { $0.title == todoAnnotation.category }) {
                detailVC.selectedCategoryIndex = index
            }
        }
        
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
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }

            let customImage = UIImage(named: "AddTodoMapPin")?
                .withRenderingMode(.alwaysTemplate)
                .withTintColor(UIColor(hex: todoAnnotation.colorName))
            
            let size = CGSize(width: 30, height: 30)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            customImage?.draw(in: CGRect(origin: .zero, size: size))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView?.image = resizedImage
            
            return annotationView
        }

        return nil
    }
}

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

    func promptForLocationServices() {
        let alertController = UIAlertController(title: "위치 서비스 필요",
                                                message: "이 앱은 위치 서비스가 필요 합니다. 설정에서 위치 권한을 허용해주세요.",
                                                preferredStyle: .alert)
            
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
            
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
            
        present(alertController, animated: true, completion: nil)
    }
}
