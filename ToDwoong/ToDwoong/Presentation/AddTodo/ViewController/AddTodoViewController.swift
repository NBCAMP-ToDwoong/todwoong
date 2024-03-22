//
//  AddTodoViewController.swift
//  ToDwoong
//
//  Created by mirae on 3/13/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class AddTodoViewController: UIViewController {
    
    // MARK: - Properties
    
    var todoToEdit: Todo?
    var selectedTitle: String = ""
    var selectedDueDate: Date? = Date()
    var selectedDueTime: Date? = Date()
    var selectedGroup: Category?
    var selectedTimesAlarm: [String] = ["5분 전"]
    var selectedPlaceAlarm: String?
    var selectedPlace: String?
    
    // MARK: - UI Properties
    
    let titleTextField = UITextField()
    let tableView = UITableView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "투두 추가"
        label.textAlignment = .center
        label.textColor = .black
        label.font = TDStyle.font.body(style: .bold)
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.tintColor = TDStyle.color.mainTheme
        button.setTitleColor(TDStyle.color.mainTheme, for: .normal)
        button.titleLabel?.font = TDStyle.font.body(style: .bold)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = TDStyle.color.mainTheme
        button.titleLabel?.font = TDStyle.font.body(style: .bold)
        button.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        
        return button
    }()
    
    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        if todoToEdit != nil {
            titleLabel.text = "투두 수정"
        } else {
            titleLabel.text = "투두 추가"
        }
        loadTodoToEdit()
    }
    
    private func loadTodoToEdit() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        
        if todoToEdit != nil {
            guard let todo = todoToEdit else { return }
            
            selectedTitle = todo.title!
            if let dueDate = todo.dueDate {
                let calendar = Calendar.current
                let dateComponents = calendar.dateComponents([.year, .month, .day], from: dueDate)
                selectedDueDate = calendar.date(from: DateComponents(year: dateComponents.year,
                                                                     month: dateComponents.month,
                                                                     day: dateComponents.day))
                
                let timeComponents = calendar.dateComponents([.hour, .minute], from: dueDate)
                if let hour = timeComponents.hour, let minute = timeComponents.minute, hour == 0 && minute == 0 {
                    selectedDueTime = nil
                } else {
                    selectedDueTime = calendar.date(from: DateComponents(hour: timeComponents.hour,
                                                                         minute: timeComponents.minute))
                }
            } else {
                selectedDueDate = nil
                selectedDueTime = nil
            }

            selectedGroup = todo.category
            selectedPlace = todo.place
            // FIXME: 코어데이터 수정 후 작업
            //            selectedPlaceAlarm =
            //            selectedTimesAlarm =
            
            titleTextField.text = selectedTitle
            
            tableView.reloadData()
        }
    }
    
    private func setView() {
        view.backgroundColor = TDStyle.color.lightGray
        titleTextField.becomeFirstResponder()
        
        setupTitleTextField()
        setupTableView()
        setupTapGesture()
        
        view.addSubview(titleLabel)
        view.addSubview(saveButton)
        view.addSubview(closeButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalToSuperview().offset(16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    // FIXME: - 추후 변경
    @objc func doneButtonTapped() {
        let title = selectedTitle
        guard !title.isEmpty else {
            print("제목이 비어 있습니다.")
            // 얼럿 뷰 표시
            return
        }
        let place = selectedPlace
        //let timeAlarm = selectedTimes ?? false 추후 수정
        //let placeAlarm = selectedPlace ?? false 추후 수정
        let timeAlarm = false
        let placeAlarm = false
        let category = selectedGroup
        
        var selectedDateTime: Date? = selectedDueDate
        if let dueDate = selectedDueDate {
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: dueDate)
            if let dueTime = selectedDueTime {
                let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: dueTime)
                dateComponents.hour = timeComponents.hour
                dateComponents.minute = timeComponents.minute
                dateComponents.second = timeComponents.second
            } else {
                dateComponents.hour = 0
                dateComponents.minute = 0
                dateComponents.second = 0
            }
            let selectedDateTime = calendar.date(from: dateComponents)
        }
        
        if let todo = todoToEdit {
            CoreDataManager.shared.updateTodo(todo: todo,
                                              newTitle: title,
                                              newPlace: place,
                                              newDate: selectedDateTime, // 추후 하나로 합침
                                              newTime: selectedDateTime,
                                              newCompleted: todo.isCompleted,
                                              newTimeAlarm: timeAlarm,
                                              newPlaceAlarm: placeAlarm,
                                              newCategory: category)
            print("투두 항목이 업데이트되었습니다.")
        } else {
            CoreDataManager.shared.createTodo(title: title,
                                              place: place,
                                              dueDate: selectedDateTime, // 추후 하나로 합침
                                              dueTime: selectedDateTime,
                                              isCompleted: false,
                                              timeAlarm: timeAlarm,
                                              placeAlarm: placeAlarm,
                                              category: category)
            print("새 투두 항목이 생성되었습니다.")
        }
        
        NotificationCenter.default.post(name: .TodoDataUpdatedNotification, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTitleTextField() {
        view.addSubview(titleTextField)
        titleTextField.placeholder = "제목"
        titleTextField.backgroundColor = .white
        titleTextField.layer.cornerRadius = 10
        titleTextField.layer.masksToBounds = true
        titleTextField.layer.borderWidth = 0
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: titleTextField.frame.height))
        titleTextField.leftView = paddingView
        titleTextField.leftViewMode = .always
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
            make.left.right.equalTo(view).inset(14)
            make.height.equalTo(44)
        }
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        selectedTitle = textField.text ?? ""
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = TDStyle.color.lightGray
        tableView.separatorStyle = .none
        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: DatePickerTableViewCell.identifier)
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        tableView.register(TimeAlarmTableViewCell.self, forCellReuseIdentifier: TimeAlarmTableViewCell.identifier)
        tableView.register(PlaceAlarmTableViewCell.self, forCellReuseIdentifier: PlaceAlarmTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(8)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        if #available(iOS 11.0, *) {
            tableView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
            tableView.insetsContentViewsToSafeArea = false
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension AddTodoViewController: UIGestureRecognizerDelegate {
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchedView = touch.view else { return false }
        if !(touchedView is UITableViewCell) && !(touchedView.isDescendant(of: tableView)) {
            return true
        }
        return false
    }
}

extension AddTodoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier,
                                                               for: indexPath) as? DatePickerTableViewCell else {
                    return UITableViewCell()
                }
                cell.selectedDate = self.selectedDueDate
                cell.selectedTime = self.selectedDueTime
                cell.onDateChanged = { [weak self] newDate in
                    self?.selectedDueDate = newDate
                }
                cell.onTimeChanged = { [weak self] newTime in
                    self?.selectedDueTime = newTime
                }
                cell.dateChipTappedHandler = { [weak self] in
                    self?.goDatePickerViewController()
                    self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
                cell.timeChipTappedHandler = { [weak self] in
                    self?.goTimePickerViewController()
                    self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
                cell.dateChipDeleteHandler = { [weak self] in
                    self?.selectedDueDate = nil
                    self?.selectedDueTime = nil
                    self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
                cell.timeChipDeleteHandler = { [weak self] in
                    self?.selectedDueTime = nil
                    self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier,
                                                               for: indexPath) as? GroupTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: selectedGroup?.title)
                cell.onDeleteButtonTapped = { [weak self] in
                    self?.selectedGroup = nil
                    self?.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                }
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier,
                                                               for: indexPath) as? LocationTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: selectedPlace)
                cell.onDeleteButtonTapped = { [weak self] in
                    self?.selectedPlace = nil
                    self?.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                }
                return cell
            default:
                break
            }
            return UITableViewCell()
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeAlarmTableViewCell.identifier,
                                                               for: indexPath) as? TimeAlarmTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: selectedTimesAlarm)
                cell.onDeleteButtonTapped = { [weak self] deletedTime in
                    guard let self = self else { return }
                    self.selectedTimesAlarm.removeAll { $0 == deletedTime }
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceAlarmTableViewCell.identifier,
                                                               for: indexPath) as? PlaceAlarmTableViewCell else {
                    return UITableViewCell()
                }
                cell.switchValueChangedHandler = { [weak self] isOn in
                    if isOn {
                        self?.goPlaceAlarmViewController()
                    } else {
                        self?.selectedPlaceAlarm = nil
                    }
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                tableView.deselectRow(at: indexPath, animated: true)
                guard let cell = tableView.cellForRow(at: indexPath) as? DatePickerTableViewCell else { return }
                cell.resetChipsNeeded()
            case 1:
                goToGroupSelectController()
            case 2:
                goLocationPickerViewController()
            default:
                break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                goTimeAlarmViewController()
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .white
        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let cornerRadius = CGFloat(10)
        var corners: UIRectCorner = []
        if indexPath.row == 0 {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }
        
        let path = UIBezierPath(roundedRect: cell.bounds.insetBy(dx: 14, dy: 0),
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        cell.layer.mask = maskLayer
        
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row < numberOfRows - 1 {
            let border = CALayer()
            border.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor // 밝은 그레이 색상과 50% 투명도
            border.frame = CGRect(x: 20, y: cell.frame.size.height - 1, width: cell.frame.size.width - 40, height: 1)
            cell.layer.addSublayer(border)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 7
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = TDStyle.color.lightGray
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = TDStyle.color.lightGray
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 0 {
            let rowCount = CGFloat((selectedTimesAlarm.count + 2) / 3)
            return 44 + rowCount * (30 + 10)
        }
        
        return 44
    }
}

// MARK: - LocationPickerDelegate

extension AddTodoViewController: LocationPickerDelegate {
    func goLocationPickerViewController() {
        let locationPickerVC = AddTodoLocationPickerViewController()
        locationPickerVC.delegate = self
        locationPickerVC.selectedPlace = selectedPlace
        present(locationPickerVC, animated: true, completion: nil)
    }
    
    func didPickLocation(_ address: String) {
        self.selectedPlace = address
        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? LocationTableViewCell {
            cell.configure(with: selectedPlace)
            tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        }
    }
    
}

// MARK: - GroupSelectControllerDelegate

extension AddTodoViewController: GroupSelectModalDelegate {
    func groupSelectController(_ controller: GroupSelectModal, didSelectGroup group: Category) {
        self.selectedGroup = group
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func goToGroupSelectController() {
        let groupSelectController = GroupSelectModal()
        groupSelectController.delegate = self
        groupSelectController.selectedCategory = self.selectedGroup
        present(groupSelectController, animated: true, completion: nil)
    }
    
}

// MARK: - TimeAlarmSelectControllerDelegate

extension AddTodoViewController: TimeAlarmModalDelegate {
    func timesSelected(_ times: [String]) {
        selectedTimesAlarm = times
        let indexPath = IndexPath(row: 0, section: 1)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    private func goTimeAlarmViewController() {
        let timeAlarmViewController = TimeAlarmModal()
        timeAlarmViewController.selectedTimes = selectedTimesAlarm
        timeAlarmViewController.delegate = self
        present(timeAlarmViewController, animated: true, completion: nil)
    }
}

// MARK: - PlaceAlarmSelectControllerDelegate

extension AddTodoViewController: PlaceAlarmModalDelegate {
    func locationSelected(_ location: [String]) {
        guard location.first != nil else {
            return
        }
        
        let indexPath = IndexPath(row: 1, section: 1)
        guard let cell = tableView.cellForRow(at: indexPath) as? PlaceAlarmTableViewCell else {
            return
        }
        cell.locationLabel.text = selectedPlaceAlarm
    }
    
    private func goPlaceAlarmViewController() {
        let placeAlarmViewController = PlaceAlarmModal()
        placeAlarmViewController.delegate = self
        present(placeAlarmViewController, animated: true, completion: nil)
    }
    
}

// MARK: - DatePickerModalDelegate

extension AddTodoViewController: DatePickerModalDelegate {
    func didSelectDate(_ date: Date) {
        selectedDueDate = date
        
        if let datePickerCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DatePickerTableViewCell {
            datePickerCell.selectedDate = selectedDueDate
        }
    }
    
    private func goDatePickerViewController() {
        let datePickerViewController = DatePickerModal()
        datePickerViewController.selectedDate = selectedDueDate
        datePickerViewController.delegate = self
        present(datePickerViewController, animated: true, completion: nil)
    }
}

// MARK: - TimePickerModalDelegate

extension AddTodoViewController: TimePickerModalDelegate {
    func didSelectTime(_ date: Date) {
        selectedDueTime = date
        
        if let datePickerCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DatePickerTableViewCell {
            datePickerCell.selectedTime = selectedDueTime
        }
    }
    
    private func goTimePickerViewController() {
        let timePickerViewController = TimePickerModal()
        timePickerViewController.selectedTime = selectedDueTime
        timePickerViewController.delegate = self
        present(timePickerViewController, animated: true, completion: nil)
    }
}
