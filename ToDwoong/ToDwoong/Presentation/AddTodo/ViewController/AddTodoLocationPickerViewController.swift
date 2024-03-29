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
    var selectedPlace: String?
    
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
        locationPickerView.onSearchTapped = { [weak self] in
            self?.presentSearchResultsController()
        }
        locationPickerView.onSaveTapped = { [weak self] in
            guard let self = self,
                  let latitude = self.selectedLatitude,
                  let longitude = self.selectedLongitude else { return }

            var addressToSend: String?

            if let addressLabel = self.locationPickerView.addressLabel.text {
                let lines = addressLabel.split(separator: "\n")
                addressToSend = lines.first.map { String($0) }
            } else {
                addressToSend = self.addressString.isEmpty ? nil : self.addressString
            }

            guard let address = addressToSend else {
                print("주소가 없습니다.")
                return
            }

            self.delegate?.didPickLocation(address, latitude: latitude, longitude: longitude)
            self.dismiss(animated: true, completion: nil)
        }
        locationPickerView.onCloseTapped = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        locationPickerView.onCenterLocationTapped = { [weak self] in
            self?.centerMapOnUserLocation()
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
        guard let userLocation = locationManager.location?.coordinate else {
            return
        }

        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        locationPickerView.mapView.setRegion(region, animated: true)
    }
    
    private func configureMapLocation() {
        if let latitude = selectedLatitude, let longitude = selectedLongitude {
            setLocation(latitude, longitude: longitude)
        } else {
            centerMapOnUserLocation()
        }
    }
    
    func setLocation(_ latitude: Double, longitude: Double) {
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        isMapCenteredByUser = true

        DispatchQueue.main.async {
            let region = MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            self.locationPickerView.mapView.setRegion(region, animated: true)
            self.fetchAddressFromCoordinates(locationCoordinate)
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

// MARK: - SearchResultsViewControllerDelegate

extension AddTodoLocationPickerViewController: SearchResultsViewControllerDelegate {
    func didSelectSearchResult(_ mapItem: MKMapItem, at coordinate: CLLocationCoordinate2D) {
        locationPickerView.mapView.setRegion(MKCoordinateRegion(center: coordinate, 
                                                                latitudinalMeters: 500,
                                                                longitudinalMeters: 500
                                                               ), animated: true)
    }

    private func presentSearchResultsController() {
        let searchViewController = LocationSearchViewController()
        searchViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: searchViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
