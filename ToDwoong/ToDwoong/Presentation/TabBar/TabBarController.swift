//
//  TabbarViewController.swift
//  ToDwoong
//
//  Created by yen on 3/3/24.
//

import UIKit

import TodwoongDesign

class FirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = TDStyle.color.bgBlue
    }
}

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = TDStyle.color.bgRed
    }
}

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
        setTabBar()
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
        let customStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 20
            stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
            stackView.isLayoutMarginsRelativeArrangement = true
            
            return stackView
        }()
        let mapButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "map"), for: .normal)
            button.tintColor = .black
            button.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
            
            return button
        }()
        let preferencesButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "ellipsis"), for: .normal)
            button.tintColor = .black
            button.addTarget(self, action: #selector(preferencesButtonTapped), for: .touchUpInside)
            
            return button
        }()
        
        customStackView.addArrangedSubview(mapButton)
        customStackView.addArrangedSubview(preferencesButton)
        
        let customBarButtonItem = UIBarButtonItem(customView: customStackView)
        
        self.navigationItem.rightBarButtonItem = customBarButtonItem
    }
    
    @objc func mapButtonTapped() {
        // FIXME: 맵 구현 이후 주석 해제 예정
//        navigationController?.pushViewController(MapViewController(), animated: .true)
    }
    
    @objc func preferencesButtonTapped() {
        let preferencesViewController = PreferencesViewController()
        preferencesViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(preferencesViewController, animated: true)
    }
}
