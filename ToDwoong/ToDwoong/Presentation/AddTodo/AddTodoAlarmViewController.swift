//
//  AddTodoAlarmViewController.swift
//  ToDwoong
//
//  Created by yen on 3/4/24.
//

import UIKit

import TodwoongDesign

final class AddTodoAlarmViewController: UIViewController {
    
    // MARK: - Properties
    
    enum SelectedType {
        case timeSelect
        case locationSelect
    }

    var selectedButton: SelectedType = .timeSelect {
        didSet {
            updateButtonStyles()
        }
    }

    let timeList = ["직접 설정",
                    "5분 전",
                    "10분 전",
                    "15분 전",
                    "20분 전",
                    "25분 전",
                    "30분 전",
                    "1시간 전",
                    "2시간 전",
                    "3시간 전",
                    "6시간 전",
                    "12시간 전"]
    
    let locationList = ["100m", "200m", "300m", "400m", "500m",
                        "1km", "2km", "3km", "4km", "5km"]
    
    // MARK: - UI Properties
    
    private lazy var timeNotificationButton: UIButton = {
        createNotificationButton(title: "시간 알림", method: #selector(test1))
    }()
    
    private lazy var locationNotificationButton: UIButton = {
        createNotificationButton(title: "장소 알림", method: #selector(test2))
    }()
    
    private lazy var saveButton: UIButton = {
        createNotificationButton(title: "저장", method: #selector(test3), color: .systemBlue)
    }()
    
    private func createNotificationButton(title: String,
                                          method: Selector,
                                          color: UIColor? = TDStyle.color.primaryLabel
    ) -> UIButton {
        var config = UIButton.Configuration.plain()
        
        config.title = title
        config.baseForegroundColor = color
        config.baseBackgroundColor = .clear
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: TDStyle.font.body(style: .regular)
        ]
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer(attributes))
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.addTarget(self, action: method, for: .touchUpInside)
        
        return button
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)

        return tableView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setUI()
        setLayout()
    }
}

// MARK: - @objc Method

extension AddTodoAlarmViewController {
    @objc
    func test1() {
        print("시간 알림")
        selectedButton = .timeSelect
        tableView.reloadData()
    }
    
    @objc
    func test2() {
        print("장소 알림")
        selectedButton = .locationSelect
        tableView.reloadData()
    }
    
    @objc
    func test3() {
        print("저장")
    }
}

extension AddTodoAlarmViewController {
    private func setUI() {
        updateButtonStyles()
        
        [
            timeNotificationButton,
            locationNotificationButton,
            tableView,
            saveButton
        ].forEach {
            view.addSubview($0)
        }
        
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        timeNotificationButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(10)
        }
        
        locationNotificationButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(timeNotificationButton.snp.trailing)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(timeNotificationButton.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "timeTableViewCellIdentifier")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationTableViewCellIdentifier")
    }
    
    private func updateButtonStyles() {
        updateButtonStyle(button: timeNotificationButton, isBold: selectedButton == .timeSelect)
        updateButtonStyle(button: locationNotificationButton, isBold: selectedButton == .locationSelect)
    }

    private func updateButtonStyle(button: UIButton, isBold: Bool) {
        var currentConfig = button.configuration ?? UIButton.Configuration.plain()
        let style: TDFont.FontStyle = isBold ? .bold : .regular
        let font = TDStyle.font.body(style: style)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        currentConfig.attributedTitle = AttributedString(currentConfig.title ?? "",
                                                         attributes: AttributeContainer(attributes))
        
        currentConfig.baseForegroundColor = isBold ? TDStyle.color.mainDarkTheme : TDStyle.color.primaryLabel
        
        button.configuration = currentConfig
    }
}

// MARK: - UITableViewDataSource

extension AddTodoAlarmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedButton {
        case .timeSelect:
            return timeList.count
        case .locationSelect:
            return locationList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedButton {
        case .timeSelect:
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeTableViewCellIdentifier", for: indexPath)
            cell.textLabel?.text = timeList[indexPath.row]
            
            return cell
            
        case .locationSelect:
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationTableViewCellIdentifier", for: indexPath)
            cell.textLabel?.text = locationList[indexPath.row]
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension AddTodoAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.selectionStyle = .none
            cell.accessoryType = .checkmark
            
            switch selectedButton {
            case .timeSelect:
                print("시간 알림", timeList[indexPath.row])
            
            case .locationSelect:
                print("장소 알림", locationList[indexPath.row])
            }
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
