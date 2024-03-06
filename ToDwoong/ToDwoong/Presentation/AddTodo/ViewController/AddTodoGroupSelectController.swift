//
//  AddTodoGroupSelectController.swift
//  ToDwoong
//
//  Created by mirae on 3/5/24.
//

import UIKit

import SnapKit
import TodwoongDesign

final class AddTodoGroupSelectController: UIViewController {
    
    // MARK: - UI Properties
    
    private let tableView = UITableView()
    var groups: [String] = ["학교", "병원", "살려주세요"] // 예시 그룹 데이터
    // MARK: - Properties
    
    weak var delegate: AddTodoGroupSelectControllerDelegate?
    private let groupList = ["test1", "test2", "test3"]
    private var selectGroup = ""
    
    // MARK: - UI Properties
    
    private lazy var timeNotificationButton: UIButton = {
        var config = UIButton.Configuration.plain()
        
        config.title = "그룹"
        config.baseForegroundColor = TDStyle.color.mainDarkTheme
        config.baseBackgroundColor = .clear
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: TDStyle.font.body(style: .bold)
        ]
        config.attributedTitle = AttributedString("그룹", attributes: AttributeContainer(attributes))
        
        let button = UIButton(configuration: config, primaryAction: nil)
        
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        createNotificationButton(title: "저장", method: #selector(saveGroup), color: .systemBlue)
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setModalPresentationStyle()
    }
    
    func setModalPresentationStyle() {
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
    }
    
    func setTableView() {
        let modalHeight = view.frame.height * 0.8
        let modalWidth = view.frame.width
        let modalYPosition = view.frame.height * (1 - 0.7) / 2
        let modalViewFrame = CGRect(x: 0, y: modalYPosition, width: modalWidth, height: modalHeight)
        let modalView = UIView(frame: modalViewFrame)
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 15
        modalView.clipsToBounds = true
        modalView.backgroundColor = .systemGray6
        
        view.addSubview(modalView)
        modalView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        view.addGestureRecognizer(tapGesture)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GroupCell")
    }
    
    @objc func dismissModal() {
        self.dismiss(animated: true, completion: nil)
        setTableView()
        setUI()
        setLayout()
    }
}

// MARK: - @objc Method

extension AddTodoGroupSelectController {
    @objc
    func saveGroup() {
        delegate?.groupSelectController(self, didSelectGroup: selectGroup)
    }
}

// MARK: - UI Method

extension AddTodoGroupSelectController {
    private func setUI() {
        [
            timeNotificationButton,
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "groupTableViewCellIdentifier")
    }
}

// MARK: - UITableViewDataSource

extension AddTodoGroupSelectController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupTableViewCellIdentifier", for: indexPath)
        cell.textLabel?.text = groupList[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AddTodoGroupSelectController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.selectionStyle = .none
            cell.accessoryType = .checkmark
            
            selectGroup = groupList[indexPath.row]
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

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AddTodoGroupSelectController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        cell.textLabel?.text = groups[indexPath.row]
        return cell
    }
    
    // MARK: - Table view delegate
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedGroup = groups[indexPath.row]
//        delegate?.groupSelectController(self, didSelectGroup: selectedGroup)
//    }
//    
//    weak var delegate: AddTodoGroupSelectControllerDelegate?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .red
//    }
}
