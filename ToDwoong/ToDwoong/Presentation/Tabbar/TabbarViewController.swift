//
//  TabbarViewController.swift
//  ToDwoong
//
//  Created by yen on 3/3/24.
//

import UIKit

class FirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }
}

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
    }
}

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
}

extension TabBarController {
    private func setTabBar() {
        let toDoListViewController = FirstViewController()
        toDoListViewController.tabBarItem = UITabBarItem(title: "할 일", image: UIImage(systemName: "checklist"), tag: 0)

        let calendarViewController = SecondViewController()
        calendarViewController.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName: "calendar"), tag: 1)

        viewControllers = [toDoListViewController, calendarViewController].map { UINavigationController(rootViewController: $0) }
    }
}
