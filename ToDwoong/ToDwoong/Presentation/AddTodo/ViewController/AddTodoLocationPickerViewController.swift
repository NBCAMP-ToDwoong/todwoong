//
//  AddTodoLocationPickerViewController.swift
//  ToDwoong
//
//  Created by mirae on 3/4/24.
//

import CoreLocation
import MapKit
import UIKit

protocol AddTodoLocationPickerDelegate: AnyObject {
    func didPickLocation(_ address: String)
}

final class AddTodoLocationPickerViewController: UIViewController {
    
    // MARK: Properties
    
    var addressString: String = ""
    var selectedPlace: String?
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    // MARK: UI Properties
    
    weak var delegate: AddTodoLocationPickerDelegate?
    
    private var locationPickerView: AddTodoLocationPickerView {
        return view as? AddTodoLocationPickerView ?? AddTodoLocationPickerView()
    }
    
    override func loadView() {
        let locationPickerView = AddTodoLocationPickerView()
        locationPickerView.delegate = self
        locationPickerView.mapView.delegate = self
        locationPickerView.searchBar.delegate = self
        view = locationPickerView
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        requestLocationAccess()
        centerMapOnUserLocation()
    }
    
    private func setDelegates() {
        locationPickerView.searchBar.delegate = self
        locationManager.delegate = self
    }
    
    private func requestLocationAccess() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func centerMapOnUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func closeAddTodoLocationPickerModal(with address: String?) {
        selectedPlace = address
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - MKMapViewDelegate

extension AddTodoLocationPickerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        fetchAddressFromCoordinates(center)
    }
    
    private func fetchAddressFromCoordinates(_ coordinates: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Error fetchting address: \(error)")
                return
            }
            
            // TODO: 수정 및 테스트중
            if let placemark = placemarks?.first {
                var addressComponents: [String] = []
                // 시/구
                if let locality = placemark.locality {
                    addressComponents.append(locality)
                }
                // 지번 주소
                if let thoroughfare = placemark.thoroughfare {
                    addressComponents.append(thoroughfare)
                }
                // 도로명 주소
                if let street = placemark.subThoroughfare {
                    addressComponents.append(street)
                }
                
                let addressString = addressComponents.joined(separator: " ")
                print(addressString)
                DispatchQueue.main.async {
                    strongSelf.locationPickerView.addressLabel.text = addressString
                    print(addressString)
                }
            }
        }
    }
}

// MARK: CLLocationManagerDelegate

extension AddTodoLocationPickerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, 
                                            longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        locationPickerView.mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error fetchting location: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}

// MARK: UISearchBarDelegate

extension AddTodoLocationPickerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        geocoder.geocodeAddressString(searchBar.text ?? "") { [weak self] (placemarks, error) in
            if let error = error {
                print("Error searching address: \(error)")
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                let region = MKCoordinateRegion(center: location.coordinate, 
                                                latitudinalMeters: 1000, longitudinalMeters: 1000)
                self?.locationPickerView.mapView.setRegion(region, animated: true)
            }
        }
    }
}

// MARK: AddTodoLocationPickerViewDelegate

extension AddTodoLocationPickerViewController: AddTodoLocationPickerViewDelegate {
    func didTapConfirmAddress(_ address: String) {
        self.selectedPlace = address
        delegate?.didPickLocation(address)
        dismiss(animated: true, completion: nil)
    }
}
