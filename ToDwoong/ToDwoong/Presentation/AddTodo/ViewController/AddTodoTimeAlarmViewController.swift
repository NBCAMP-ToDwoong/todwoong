//
//  AddTodoTimeAlarmViewController.swift
//  ToDwoong
//
//  Created by mirae on 3/14/24.
//

import UIKit

import TodwoongDesign

final class AddTodoTimeAlarmViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: AddTodoTimeAlarmSelectControllerDelegate?
    
    // FIXME: 직접설정이 없어서 주석처리 추후 변경
//    let timeList = ["직접 설정",
//                    "5분 전",
//                    "10분 전",
//                    "15분 전",
//                    "20분 전",
//                    "25분 전",
//                    "30분 전",
//                    "1시간 전",
//                    "2시간 전",
//                    "3시간 전",
//                    "6시간 전",
//                    "12시간 전"]
    let timeList = ["5분 전",
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
    var selectedTimes: [String] = []
    
    // MARK: - UI Properties
    
    private lazy var timeNotificationButton: UIButton = {
        var config = UIButton.Configuration.plain()
        
        config.title = "시간 알람"
        config.baseForegroundColor = TDStyle.color.mainDarkTheme
        config.baseBackgroundColor = .clear
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: TDStyle.font.body(style: .bold)
        ]
        config.attributedTitle = AttributedString("시간 알람", attributes: AttributeContainer(attributes))
        
        let button = UIButton(configuration: config, primaryAction: nil)
        
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        createNotificationButton(title: "저장", method: #selector(saveTimes), color: .systemBlue)
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

extension AddTodoTimeAlarmViewController {
    @objc
    func saveTimes() {
        delegate?.timesSelected(selectedTimes)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UI Method

extension AddTodoTimeAlarmViewController {
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddTodoTimeAlarmCell")
    }
}

// MARK: - UITableViewDataSource

extension AddTodoTimeAlarmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddTodoTimeAlarmCell", for: indexPath)
        cell.textLabel?.text = timeList[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AddTodoTimeAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let selectedTime = timeList[indexPath.row]
        
        if selectedTimes.contains(selectedTime) {
            selectedTimes.removeAll { $0 == selectedTime }
            cell.accessoryType = .none
        } else {
            // FIXME: 추후 코어데이터 수정후 6개로 수정
            if selectedTimes.count < 1 {
            //if selectedTimes.count < 6 {
                selectedTimes.append(selectedTime)
                cell.accessoryType = .checkmark
                selectedTimes.sort { timeList.firstIndex(of: $0)! < timeList.firstIndex(of: $1)! }
            } else {
                print("최대 6개까지만 선택할 수 있습니다.")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let time = timeList[indexPath.row]
        cell.accessoryType = selectedTimes.contains(time) ? .checkmark : .none
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
