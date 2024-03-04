//
//  AddTodoAlarmViewController.swift
//  ToDwoong
//
//  Created by yen on 3/4/24.
//

import UIKit

import TodwoongDesign

final class AddTodoAlarmViewController: UIViewController {
    
    let dummy = ["1", "2", "3", "4", "5"]
    
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

    
    @objc
    func test1() {
        print("시간 알림")
    }
    
    @objc
    func test2() {
        print("장소 알림")
    }
    
    @objc
    func test3() {
        print("저장")
    }
    
    private lazy var timeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBlue
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)

        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setUI()
        setLayout()
    }
}

extension AddTodoAlarmViewController {
    private func setUI() {
        [
            timeNotificationButton,
            locationNotificationButton,
            timeTableView,
            saveButton
        ].forEach {
            view.addSubview($0)
        }
        
        view.backgroundColor = TDStyle.color.lightGray
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
        
        timeTableView.snp.makeConstraints { make in
            make.top.equalTo(timeNotificationButton.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setTableView() {
        timeTableView.dataSource = self
        timeTableView.delegate = self
        
        timeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension AddTodoAlarmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = dummy[indexPath.row]
        
        return cell
    }
}

extension AddTodoAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.selectionStyle = .none
            cell.accessoryType = .checkmark
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
}
