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
    
    //MARK: Properties
    
    private let LocationManager = CLLocationManager()
    private let center = UNUserNotificationCenter.current()
    
    //MARK: UI Properties
    
    private var onboardingView = OnboardingView()
    
    //MARK: Life Cycle
    
    override func loadView() {
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAction()
        setDelegate()
    }
}

//MARK: Action

extension OnboardingViewController {
    
    private func setAction() {
        onboardingView.requestButton.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
    }
    
    @objc private func requestButtonTapped() {
        requestAuthorization()
    }
}

//MARK: Requset Method

extension OnboardingViewController {
    private func requestAuthorization() {
        requestLocationAuthorization()
        requestNotificationAuthorization()
    }
    
    private func requestLocationAuthorization() {
        LocationManager.requestWhenInUseAuthorization()
    }
    
    private func requestNotificationAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {

            } else {

            }
        }
    }
}

//MARK: LocationDelegate

extension OnboardingViewController: CLLocationManagerDelegate {
    
    private func setDelegate() {
        LocationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            LocationManager.requestAlwaysAuthorization()
        default:
            break
        }
    }
}
