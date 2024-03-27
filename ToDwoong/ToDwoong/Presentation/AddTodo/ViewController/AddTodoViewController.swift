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
    var selectedPlace: String?
    var selectedTimes: [String] = ["5분 전"]
    var selectedLocation: String?
    
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
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = TDStyle.color.mainTheme
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
        titleLabel.textColor = TDStyle.color.mainTheme
        
        if todoToEdit != nil {
            guard let todo = todoToEdit else { return }
            
            selectedTitle = todo.title!
            selectedDueDate = todo.dueDate
            selectedDueTime = todo.dueTime
            selectedGroup = todo.category
            selectedPlace = todo.place
            
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
        
        // UI 컴포넌트를 뷰에 추가
        view.addSubview(titleLabel)
        view.addSubview(saveButton)
        view.addSubview(closeButton)

        // titleLabel의 제약 조건 설정
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }

        // closeButton의 제약 조건 설정
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY) // titleLabel의 centerY와 맞춤
            make.leading.equalToSuperview().offset(16) // leading에 대한 제약 조건 유지
        }

        // saveButton의 제약 조건 설정
        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY) // titleLabel의 centerY와 맞춤
            make.trailing.equalToSuperview().offset(-16) // trailing에 대한 제약 조건 유지
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
        
        if let todo = todoToEdit {
            CoreDataManager.shared.updateTodo(todo: todo,
                                              newTitle: title,
                                              newPlace: place,
                                              newDate: selectedDueDate,
                                              newTime: selectedDueTime,
                                              newCompleted: todo.isCompleted,
                                              newTimeAlarm: timeAlarm,
                                              newPlaceAlarm: placeAlarm,
                                              newCategory: category)
            print("투두 항목이 업데이트되었습니다.")
        } else {
            CoreDataManager.shared.createTodo(title: title,
                                              place: place,
                                              dueDate: selectedDueDate,
                                              dueTime: selectedDueTime,
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
            make.height.equalTo(50)
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
        
        tableView.dataSource = self
        tableView.delegate = self
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

extension AddTodoViewController: UITableViewDelegate {
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
                    self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
                cell.timeChipDeleteHandler = { [weak self] in
                    self?.selectedDueTime = nil
                    self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
                cell.accessoryType = .none
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
                cell.configure(with: selectedTimes)
                cell.onDeleteButtonTapped = { [weak self] deletedTime in
                    guard let self = self else { return }
                    self.selectedTimes.removeAll { $0 == deletedTime }
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
                        self?.selectedLocation = nil
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
            let rowCount = CGFloat((selectedTimes.count + 2) / 3)
            return 50 + rowCount * (30 + 10)
        }
        return 50
    }
}

extension AddTodoViewController: UITableViewDataSource {}


extension AddTodoViewController: AddTodoLocationPickerDelegate {
    func goLocationPickerViewController() {
        let locationPickerVC = AddTodoLocationPickerViewController()
        locationPickerVC.delegate = self
        present(locationPickerVC, animated: true, completion: nil)
    }
    
    func didPickLocation(_ address: String) {
        self.selectedPlace = address
        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? LocationTableViewCell {
            cell.configure(with: selectedPlace)
        }
    }
    
}

extension AddTodoViewController: AddTodoGroupSelectControllerDelegate {
    func groupSelectController(_ controller: AddTodoGroupSelectController, didSelectGroup group: Category) {
        self.selectedGroup = group
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func goToGroupSelectController() {
        let groupSelectController = AddTodoGroupSelectController()
        groupSelectController.delegate = self
        groupSelectController.selectedCategory = self.selectedGroup
        present(groupSelectController, animated: true, completion: nil)
    }
    
}

extension AddTodoViewController: AddTodoTimeAlarmSelectControllerDelegate {
    func timesSelected(_ times: [String]) {
        selectedTimes = times
        let indexPath = IndexPath(row: 0, section: 1)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    private func goTimeAlarmViewController() {
        let timeAlarmViewController = AddTodoTimeAlarmViewController()
        timeAlarmViewController.selectedTimes = selectedTimes
        timeAlarmViewController.delegate = self
        present(timeAlarmViewController, animated: true, completion: nil)
    }
}

extension AddTodoViewController: AddTodoPlaceAlarmSelectControllerDelegate {
    func locationSelected(_ location: [String]) {
        guard let selectedLocation = location.first else {
            return
        }
        
        let indexPath = IndexPath(row: 1, section: 1)
        guard let cell = tableView.cellForRow(at: indexPath) as? PlaceAlarmTableViewCell else {
            return
        }
        cell.locationLabel.text = selectedLocation
    }
    
    private func goPlaceAlarmViewController() {
        let placeAlarmViewController = AddTodoPlaceAlarmViewController()
        placeAlarmViewController.delegate = self
        present(placeAlarmViewController, animated: true, completion: nil)
    }
    
}

extension AddTodoViewController: DatePickerModalDelegate {
    func didSelectDate(_ date: Date) {
        selectedDueDate = date
        
        if let datePickerCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DatePickerTableViewCell {
            datePickerCell.selectedDate = selectedDueDate
        }
    }
    
    private func goDatePickerViewController() {
        let datePickerViewController = AddTodoDatePickerController()
        datePickerViewController.delegate = self
        present(datePickerViewController, animated: true, completion: nil)
    }
}

extension AddTodoViewController: TimePickerModalDelegate {
    func didSelectTime(_ date: Date) {
        selectedDueTime = date
        
        if let datePickerCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DatePickerTableViewCell {
            datePickerCell.selectedTime = selectedDueTime
        }
    }
    
    private func goTimePickerViewController() {
        let timePickerViewController = AddTodoTimePickerController()
        timePickerViewController.delegate = self
        present(timePickerViewController, animated: true, completion: nil)
    }
}
