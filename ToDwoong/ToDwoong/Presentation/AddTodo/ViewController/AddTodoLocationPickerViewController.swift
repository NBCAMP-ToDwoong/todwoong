//
//  AddTodoLocationPickerViewController.swift
//  ToDwoong
//
//  Created by mirae on 3/4/24.
//

import CoreLocation
import MapKit
import UIKit

final class AddTodoLocationPickerViewController: UIViewController {
    
    // MARK: - Properties
    
    var addressString: String = ""
    var selectedPlace: String?
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    // MARK: - UI Properties
    
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        requestLocationAccess()
        centerMapOnUserLocation()
        configureMapLocation()
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

extension AddTodoLocationPickerViewController {
    private func configureMapLocation() {
        if let selectedPlace = selectedPlace, !selectedPlace.isEmpty {
            setLocation(selectedPlace)
        } else {
            centerMapOnUserLocation()
        }
    }
    
    func setLocation(_ address: String) {
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Error geocoding address: \(error)")
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                let region = MKCoordinateRegion(center: location.coordinate,
                                                latitudinalMeters: 1000, longitudinalMeters: 1000)
                strongSelf.locationPickerView.mapView.setRegion(region, animated: true)
            }
        }
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
                print("Error fetching address: \(error)")
                return
            }
            
            if let placemark = placemarks?.first {
                var addressComponents: [String] = []
                
                if let administrativeArea = placemark.administrativeArea, administrativeArea != placemark.locality {
                    addressComponents.append(administrativeArea)
                }
                
                if let locality = placemark.locality {
                    addressComponents.append(locality)
                }
                
                if let thoroughfare = placemark.thoroughfare {
                    addressComponents.append(thoroughfare)
                    if let subThoroughfare = placemark.subThoroughfare {
                        addressComponents.append(subThoroughfare)
                    }
                } else if let name = placemark.name, !addressComponents.contains(name) {
                    addressComponents.append(name)
                }
                
                let addressString = addressComponents.joined(separator: " ")
                DispatchQueue.main.async {
                    strongSelf.locationPickerView.addressLabel.text = addressString
                    print("주소: \(addressString)")
                }
            }
        }
    }
    
}

// MARK: - CLLocationManagerDelegate

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

// MARK: - UISearchBarDelegate

extension AddTodoLocationPickerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        
        let koreaRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 37.5665,
                                                                          longitude: 126.9780),
                                           radius: 50000,
                                           identifier: "Korea")
        
        geocoder.geocodeAddressString(searchText, in: koreaRegion) { [weak self] (placemarks, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Error searching address: \(error)")
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000,
                                                longitudinalMeters: 1000)
                strongSelf.locationPickerView.mapView.setRegion(region, animated: true)
                strongSelf.updateAddressLabel(with: placemark, searchText: searchText)
            }
        }
    }
    
    private func updateAddressLabel(with placemark: CLPlacemark, searchText: String) {
        var addressComponents: [String] = []
        
        if let administrativeArea = placemark.administrativeArea {
            addressComponents.append(administrativeArea)
        }
        
        if let locality = placemark.locality {
            addressComponents.append(locality)
        }
        
        if let thoroughfare = placemark.thoroughfare {
            addressComponents.append(thoroughfare)
        }
        
        if let subThoroughfare = placemark.subThoroughfare {
            addressComponents.append(subThoroughfare)
        }
        
        let addressString = addressComponents.joined(separator: " ")
        DispatchQueue.main.async {
            self.locationPickerView.addressLabel.text = addressString
            print("검색어: \(searchText), 검색 결과: \(addressString)")
        }
    }
}

// MARK: - AddTodoLocationPickerViewDelegate

extension AddTodoLocationPickerViewController: AddTodoLocationPickerViewDelegate {
    func didTapConfirmAddress(_ address: String) {
        self.selectedPlace = address
        delegate?.didPickLocation(address)
        dismiss(animated: true, completion: nil)
    }
}
