//
//  PreferencesViewController.swift
//  ToDwoong
//
//  Created by 홍희곤 on 3/8/24.
//

import UIKit

final class PreferencesViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private let preferencesView = PreferencesView()
    
    private let pushPreferences: PreferencesModel = {
        let preferences = PreferencesModel(title: "Push 알림 설정")
        preferences.action = {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        
        return preferences
    }()
    
    private lazy var preferencesList = [pushPreferences]
    
    // MARK: - Life Cycle

    override func loadView() {
        view = preferencesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setTableView()
    }
}

// MARK: - Extension

extension PreferencesViewController {
    private func setUI() {
        self.title = "설정"
    }
}

// MARK: - TableViewDataSource

extension PreferencesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        preferencesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: PreferencesTableViewCell.identifier, 
            for: indexPath
        ) as? PreferencesTableViewCell
        {
            cell.setTitle(title: preferencesList[indexPath.row].title)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - TableViewDelegate

extension PreferencesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let action = preferencesList[indexPath.row].action {
            action()
        }   
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    private func setTableView() {
        preferencesView.preferencesTableView.delegate = self
        preferencesView.preferencesTableView.dataSource = self
    }
}
