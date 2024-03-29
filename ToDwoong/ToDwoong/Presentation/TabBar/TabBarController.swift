//
//  TabbarViewController.swift
//  ToDwoong
//
//  Created by yen on 3/3/24.
//

import UIKit

import TodwoongDesign

class TabBarController: UITabBarController {
    
    // MARK: - UI Properties
    
    private var floatingButton: FloatingButton!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
        setTabBar()
        setFloatingButton()
    }
}

extension TabBarController {
    private func setUI() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = TDStyle.color.mainDarkTheme
    }
    
    private func setTabBar() {
        let toDoListViewController = TodoListViewController()
        toDoListViewController.tabBarItem = UITabBarItem(title: "할 일", image: UIImage(systemName: "checklist"), tag: 0)
        
        let calendarViewController = CalendarViewController()
        calendarViewController.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName: "calendar"), tag: 1)
        
        viewControllers = [toDoListViewController, calendarViewController]
        
    }
}

extension TabBarController {
    private func setNavigationBar() {
        let customView: UIView = {
            let view = UIView()
            
            return view
        }()
        let mapButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "map"), for: .normal)
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            button.imageView?.contentMode = .scaleAspectFit
            button.tintColor = .black
            button.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
            
            return button
        }()
        let preferencesButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "ellipsis"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.tintColor = .black
            button.addTarget(self, action: #selector(preferencesButtonTapped), for: .touchUpInside)
            
            return button
        }()
        
        customView.addSubview(mapButton)
        customView.addSubview(preferencesButton)
        
        let customBarButtonItem = UIBarButtonItem(customView: customView)
        
        self.navigationItem.rightBarButtonItem = customBarButtonItem
        
        customView.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(70)
        }
        mapButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(mapButton.snp.height)
        }
        preferencesButton.snp.makeConstraints { make in
            make.leading.equalTo(mapButton.snp.trailing).offset(20)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(mapButton.snp.height)
        }
        
        navigationItem.hidesBackButton = true
    }
    
    @objc func mapButtonTapped() {
        navigationController?.pushViewController(MapViewController(), animated: true)
    }
    
    @objc func preferencesButtonTapped() {
        navigationController?.pushViewController(PreferencesViewController(), animated: true)
    }
}

// MARK: - Floating Button Setting

extension TabBarController {
    func setFloatingButton() {
        floatingButton = FloatingButton()
        view.addSubview(floatingButton)
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(tabBar.snp.top).offset(-20)
            make.width.height.equalTo(60)
        }
        
        floatingButton.floatingButtonTapped = { [weak self] in
            let addTodoVC = AddTodoViewController()
            addTodoVC.modalPresentationStyle = .fullScreen
            self?.present(addTodoVC, animated: true)
        }
    }
}
