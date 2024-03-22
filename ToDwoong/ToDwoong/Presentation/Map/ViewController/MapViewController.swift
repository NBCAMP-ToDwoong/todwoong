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
    
    var todoDetailViewController = TodoDetailViewController()
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
        mapView.isPitchEnabled = false
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

// MARK: - MapView Pin

extension MapViewController {
    func addPinsToMap() {
        // 예시 위치 핀
        let pin = createAnnotation(title: "서울 시청에서 레쓰비 고소하기",
                                   latitude: 37.5665,
                                   longitude: 126.9780, 
                                   pinColor: TDStyle.color.bgBlue)
        let pin2 = createAnnotation(title: "부산",
                                    latitude: 35.1795,
                                    longitude: 129.0756, 
                                    pinColor: nil)
        
        [pin, pin2].forEach {
            mapView.addAnnotation($0)
        }
            
        // 모든 핀이 보이도록 지도 범위 조정
        mapView.showAnnotations([pin, pin2], animated: true)
    }
    

    func createAnnotation(title: String, latitude: Double, longitude: Double, pinColor: UIColor?) -> ColoredAnnotation {
        let annotation = ColoredAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = title
        annotation.pinColor = pinColor ?? TDStyle.color.mainTheme
        
        return annotation
    }
}

// MARK: - MKMapViewDelegate

class ColoredAnnotation: MKPointAnnotation {
    var pinColor: UIColor?
}

extension MapViewController: MKMapViewDelegate {
    
    // 핀 클릭 시 확대
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        let offset = -0.005
        let newCenterLatitude = annotation.coordinate.latitude + offset
        let newCenter = CLLocationCoordinate2D(latitude: newCenterLatitude, 
                                               longitude: annotation.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: newCenter,
                                        latitudinalMeters: regionRadius,
                                        longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        
        if let sheet = todoDetailViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(todoDetailViewController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let coloredAnnotation = annotation as? ColoredAnnotation else {
            return nil
        }

        let reuseId = "customPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
        } else {
            pinView?.annotation = annotation
        }
        
        if let customImage = UIImage(named: "AddTodoMapPin")?.withRenderingMode(.alwaysTemplate) {
            let resizedImage = resizeImage(image: customImage, targetSize: CGSize(width: 26, height: 26))
            let coloredAndResizedImage = resizedImage.withTintColor(
                coloredAnnotation.pinColor ?? TDStyle.color.mainTheme)
            pinView?.image = coloredAndResizedImage
            
            pinView?.layer.shadowColor = UIColor.black.cgColor
            pinView?.layer.shadowOpacity = 0.8
            pinView?.layer.shadowOffset = CGSize(width: 0, height: 1)
            pinView?.layer.shadowRadius = 2
        }

        return pinView
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }

}
extension UIImage {
    func withTintColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.set()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        
        let rect = CGRect(origin: .zero, size: self.size)
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage ?? self
    }
}
