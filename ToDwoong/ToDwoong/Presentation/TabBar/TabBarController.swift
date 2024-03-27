//
//  TabbarViewController.swift
//  ToDwoong
//
//  Created by yen on 3/3/24.
//

import UIKit

import TodwoongDesign

class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    var isExpanded = false
    
    // MARK: - UI Properties
    
    private lazy var floatingButton: UIButton = createButton(
        withImage: "plus",
        backgroundColor: TDStyle.color.mainTheme,
        foregroundColor: .white,
        action: #selector(floatingButtonTapped))

    private lazy var addTodoButton: UIButton = createButton(
        withImage: "pencil",
        backgroundColor: TDStyle.color.bgGray,
        foregroundColor: TDStyle.color.mainTheme,
        action: #selector(addTodoButtonTapped))

    private lazy var addGroupButton: UIButton = createButton(
        withImage: "folder.fill",
        backgroundColor: TDStyle.color.bgGray,
        foregroundColor: TDStyle.color.mainTheme,
        action: #selector(addGroupButtonTapped))
    
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
    
    private func createButton(withImage systemName: String,
                              backgroundColor: UIColor,
                              foregroundColor: UIColor,
                              action: Selector) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = backgroundColor
        config.image = UIImage(systemName: systemName)
        config.imagePadding = 10
        config.cornerStyle = .fixed
        config.background.cornerRadius = 30
        config.baseForegroundColor = foregroundColor

        let button = UIButton(configuration: config, primaryAction: nil)
        button.clipsToBounds = true
        button.isHidden = true
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return button
    }
    
    
    private func setFloatingButton() {
        view.addSubview(floatingButton)
        view.addSubview(addTodoButton)
        view.addSubview(addGroupButton)
        
        floatingButton.isHidden = false
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-70)
            make.width.height.equalTo(60)
        }

        addTodoButton.snp.makeConstraints { make in
            make.centerX.equalTo(floatingButton)
            make.bottom.equalTo(floatingButton.snp.top).offset(-16)
            make.width.height.equalTo(60)
        }

        addGroupButton.snp.makeConstraints { make in
            make.centerX.equalTo(floatingButton)
            make.bottom.equalTo(addTodoButton.snp.top).offset(-16)
            make.width.height.equalTo(60)
        }
    }
    
    private func updateUI() {
        let image = self.isExpanded ? UIImage(systemName: "xmark") : UIImage(systemName: "plus")
        self.floatingButton.setImage(image, for: .normal)
        
        self.addTodoButton.isHidden = !self.isExpanded
        self.addGroupButton.isHidden = !self.isExpanded
        
        let yOffset: CGFloat = self.isExpanded ? -16 : 0
        self.addTodoButton.snp.updateConstraints { make in
            make.bottom.equalTo(self.floatingButton.snp.top).offset(yOffset)
        }
        self.addGroupButton.snp.updateConstraints { make in
            make.bottom.equalTo(self.addTodoButton.snp.top).offset(yOffset)
        }
    }
}

// MARK: - Floating Button @objc Method

extension TabBarController {
    @objc
    func floatingButtonTapped() {
        isExpanded.toggle()
        updateUI()
    }
    
    @objc
    func addTodoButtonTapped() {
        let viewController = AddTodoViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true) { [weak self] in
            self?.isExpanded.toggle()
            self?.updateUI()
        }
    }
    
    @objc
    func addGroupButtonTapped() {
        let viewController = AddGroupViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true) { [weak self] in
            self?.isExpanded.toggle()
            self?.updateUI()
        }
    }
}
