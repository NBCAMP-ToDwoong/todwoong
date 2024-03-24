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
    
    var selectedLatitude: Double?
    var selectedLongitude: Double?
    var addressString: String = ""
    var selectedPlace: String? {
        didSet {
            configureMapLocation()
        }
    }
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var isMapCenteredByUser = false
    
    // MARK: - UI Properties
    
    weak var delegate: LocationPickerDelegate?
    
    private var locationPickerView: AddTodoLocationPickerView {
        return view as? AddTodoLocationPickerView ?? AddTodoLocationPickerView()
    }
    
    override func loadView() {
        let locationPickerView = AddTodoLocationPickerView()
        locationPickerView.mapView.delegate = self
        locationPickerView.onSaveTapped = { [weak self] in
            guard let self = self,
                  let latitude = self.selectedLatitude,
                  let longitude = self.selectedLongitude,
                  let address = self.addressString.isEmpty
                    ? self.locationPickerView.addressLabel.text : self.addressString else { return }
            self.delegate?.didPickLocation(address, latitude: latitude, longitude: longitude)
            self.dismiss(animated: true, completion: nil)
        }
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
    
    private func configureMapLocation() {
        if let selectedPlace = selectedPlace, !selectedPlace.isEmpty {
            setLocation(selectedPlace)
        } else {
            centerMapOnUserLocation()
        }
    }
    
    func setLocation(_ address: String) {
        isMapCenteredByUser = true
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = address
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] (response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error searching for address: \(error)")
                return
            }
            
            guard let response = response, let mapItem = response.mapItems.first else {
                print("No results found for address")
                return
            }
            
            let placemark = mapItem.placemark
            let latitude = placemark.coordinate.latitude
            let longitude = placemark.coordinate.longitude
            
            print("검색결과 Latitude: \(latitude), Longitude: \(longitude)")
            
            DispatchQueue.main.async {
                let region = MKCoordinateRegion(center: placemark.coordinate,
                                                latitudinalMeters: 500,
                                                longitudinalMeters: 500)
                self.locationPickerView.mapView.setRegion(region, animated: false)
                self.updateAddressLabel(with: placemark)
            }
        }
    }
}

// MARK: - MKMapViewDelegate
extension AddTodoLocationPickerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard !isMapCenteredByUser else {
            isMapCenteredByUser = false
            return
        }
        
        let center = mapView.centerCoordinate
        selectedLatitude = center.latitude
        selectedLongitude = center.longitude
        print("지도 중앙의 위도: \(center.latitude), 경도: \(center.longitude)")
        fetchAddressFromCoordinates(center)
    }
    
    private func fetchAddressFromCoordinates(_ coordinates: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching address: \(error)")
                return
            }
            
            if let placemark = placemarks?.first {
                self.updateAddressLabel(with: placemark)
            }
        }
    }
    
    private func updateAddressLabel(with placemark: CLPlacemark) {
        var addressComponents: [String] = []
        
        var cityAddress = ""
        if let locality = placemark.locality, !locality.isEmpty {
            cityAddress += locality
        }
        
        var roadAddress = ""
        if let thoroughfare = placemark.thoroughfare, !thoroughfare.isEmpty {
            roadAddress += thoroughfare
            if let subThoroughfare = placemark.subThoroughfare, !subThoroughfare.isEmpty {
                roadAddress += " " + subThoroughfare
            }
        }
        
        if let name = placemark.name, !name.isEmpty, name != roadAddress, name != cityAddress {
            addressComponents.append(name)
        }
        
        if !cityAddress.isEmpty && cityAddress != roadAddress && !roadAddress.isEmpty {
            let addressLine = "\(cityAddress) \(roadAddress)"
            addressComponents.append(addressLine)
        }
        
        let addressString = addressComponents.joined(separator: "\n")
        DispatchQueue.main.async {
            if !addressString.allSatisfy({ $0.isNumber }) {
                self.locationPickerView.addressLabel.text = addressString
            }
        }
    }
    
}

// MARK: - CLLocationManagerDelegate
extension AddTodoLocationPickerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first, !isMapCenteredByUser {
            let region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: 500,
                                            longitudinalMeters: 500)
            locationPickerView.mapView.setRegion(region, animated: false)
            locationManager.stopUpdatingLocation()
            isMapCenteredByUser = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error fetching location: \(error)")
    }
}

// MARK: - UISearchBarDelegate

extension AddTodoLocationPickerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        
        DispatchQueue.main.async {
            self.locationPickerView.addressLabel.text = ""
        }
        
        setLocation(searchTerm)
    }
}
