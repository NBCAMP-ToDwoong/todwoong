//
//  AddTodoPlaceAlarmViewController.swift
//  ToDwoong
//
//  Created by mirae on 3/15/24.
//

import UIKit

import TodwoongDesign

final class AddTodoPlaceAlarmViewController: UIViewController {
    
    // MARK: - Properties
    
    let locationList = ["100m", "200m", "300m", "400m", "500m",
                        "1km", "2km", "3km", "4km", "5km"]
    var selectedLocation: [String] = []
    
    weak var delegate: PlaceAlarmSelectControllerDelegate?
    
    // MARK: - UI Properties
    
    private lazy var placeNotificationButton: UIButton = {
        var config = UIButton.Configuration.plain()
        
        config.title = "장소 알람"
        config.baseForegroundColor = TDStyle.color.mainDarkTheme
        config.baseBackgroundColor = .clear
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: TDStyle.font.body(style: .bold)
        ]
        config.attributedTitle = AttributedString("장소 알람", attributes: AttributeContainer(attributes))
        
        let button = UIButton(configuration: config, primaryAction: nil)
        
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        createNotificationButton(title: "저장", method: #selector(saveLocation), color: .systemBlue)
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
        
        setUI()
        setLayout()
        setTableView()
    }
}

// MARK: - @objc Method

extension AddTodoPlaceAlarmViewController {
    @objc
    func saveLocation() {
        delegate?.locationSelected(selectedLocation)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UI Method

extension AddTodoPlaceAlarmViewController {
    private func setUI() {
        [placeNotificationButton, tableView, saveButton].forEach { view.addSubview($0) }
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        placeNotificationButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(10)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(placeNotificationButton.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddTodoPlaceAlarmCell")
    }
}

// MARK: - UITableViewDataSource

extension AddTodoPlaceAlarmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddTodoPlaceAlarmCell", for: indexPath)
        cell.textLabel?.text = locationList[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AddTodoPlaceAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            let selectedLocationString = locationList[indexPath.row]
            
            if selectedLocation.contains(selectedLocationString) {
                selectedLocation.removeAll()
                cell.accessoryType = .none
            } else {
                selectedLocation.removeAll()
                selectedLocation.append(selectedLocationString)
                cell.accessoryType = .checkmark
            }
            
            tableView.reloadData()
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let selectedLocationString = locationList[indexPath.row]
            cell.accessoryType = selectedLocation.contains(selectedLocationString) ? .checkmark : .none
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
