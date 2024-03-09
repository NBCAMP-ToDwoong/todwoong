//
//  OnboardingViewController.swift
//  ToDwoong
//
//  Created by 홍희곤 on 2/28/24.
//

import CoreLocation
import UIKit
import UserNotifications

final class OnboardingViewController: UIViewController {
    
    // MARK: Properties
    
    private let locationManager = CLLocationManager()
    private let center = UNUserNotificationCenter.current()
    
    // MARK: UI Properties
    
    private var onboardingView = OnboardingView()
    
    // MARK: Life Cycle
    
    override func loadView() {
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAction()
        setDelegate()
    }
}

// MARK: Action

extension OnboardingViewController {
    
    private func setAction() {
        onboardingView.requestButton.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
    }
    
    @objc private func requestButtonTapped() {
        requestAuthorization()
        
        let firstAccess = false
        UserDefaults.standard.set(firstAccess, forKey: "first")
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(TabBarController(), animated: true)
    }
}

// MARK: Requset Method

extension OnboardingViewController {
    private func requestAuthorization() {
        requestLocationAuthorization()
        requestNotificationAuthorization()
    }
    
    private func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func requestNotificationAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {

            } else {

            }
        }
    }
}

// MARK: LocationDelegate

extension OnboardingViewController: CLLocationManagerDelegate {
    
    private func setDelegate() {
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        default:
            break
        }
    }
}
