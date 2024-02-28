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
    
    //MARK: UI Properties
    
    private var onboardingView = OnboardingView()
    
    //MARK: Life Cycle
    
    override func loadView() {
        view = onboardingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAction()
    }
}

//MARK: Action

extension OnboardingViewController {
    
    private func setAction() {
        onboardingView.requestButton.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
    }
    
    @objc func requestButtonTapped() {
        
    }
}
