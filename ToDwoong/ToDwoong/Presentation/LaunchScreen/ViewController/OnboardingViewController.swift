//
//  OnboardingViewController.swift
//  ToDwoong
//
//  Created by 홍희곤 on 2/28/24.
//

import UIKit
import CoreLocation
import UserNotifications

final class OnboardingViewController: UIViewController {
    
    //MARK: Properties
    let LocationManager = CLLocationManager()
    let center = UNUserNotificationCenter.current()
    
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
    
    @objc func requestButtonTapped() {
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
//        LocationManager.requestAlwaysAuthorization()
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
    
    func setDelegate() {
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
