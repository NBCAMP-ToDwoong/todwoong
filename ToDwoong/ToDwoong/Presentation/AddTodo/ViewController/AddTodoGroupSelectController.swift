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
    
    // MARK: - Properties
    
    weak var delegate: AddTodoGroupSelectControllerDelegate?
    var groupList: [Category] = []
    private var selectedCategory: Category?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupList = CoreDataManager.shared.readCategories()
        setUI()
        setLayout()
        setTableView()
    }
}

// MARK: - @objc Method

extension AddTodoGroupSelectController {
    @objc
    func saveGroup() {
        if let selectedCategory = selectedCategory {
            delegate?.groupSelectController(self, didSelectGroup: selectedCategory)
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UI Method

extension AddTodoGroupSelectController {
    private func setUI() {
        [timeNotificationButton, tableView, saveButton].forEach { view.addSubview($0) }
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
        cell.textLabel?.text = groupList[indexPath.row].title
        
        let colorDiameter: CGFloat = 20
        let colorView = UIView()
        colorView.backgroundColor = UIColor(named: groupList[indexPath.row].color ?? "#D1FADF")
        colorView.layer.cornerRadius = colorDiameter / 2
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        for subview in cell.contentView.subviews where subview.tag == 99 {
            subview.removeFromSuperview()
        }

        colorView.tag = 99
        cell.contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
            colorView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: colorDiameter),
            colorView.heightAnchor.constraint(equalToConstant: colorDiameter)
        ])
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AddTodoGroupSelectController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = groupList[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
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
