//
//  AddTodoViewController.swift
//  ToDwoong
//
//  Created by mirae on 3/13/24.
//

import CoreData
import CoreLocation
import UIKit

import SnapKit
import TodwoongDesign

class AddTodoViewController: UIViewController {
    
    // MARK: - Properties
    
    var todoToEdit: TodoDTO?
    var selectedTitle: String = ""
    var selectedDueDate: Date? = Date()
    var selectedDueTime: Date? = Date()
    var selectedGroup: Group?
    var selectedTimesAlarm: [Int]? = [5]
    var selectedPlaceAlarm: PlaceAlarmType?
    var selectedPlaceName: String?
    var selectedLatitude: Double?
    var selectedLongitude: Double?
    
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
        
        if let todoID = todoToEdit?.id {
            if let todo = CoreDataManager.shared.readTodo(id: todoID) {
                selectedTitle = todo.title
                selectedDueDate = todo.dueTime
                selectedPlaceName = todo.placeName
                selectedPlaceAlarm = todo.placeAlarm
                
                titleTextField.text = selectedTitle
                
                tableView.reloadData()
            }
        }
        if todoToEdit != nil {
            guard let todo = todoToEdit else { return }
            selectedGroup = todo.group
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
        var groupType: GroupType? = nil
        if let selectedGroup = selectedGroup {
            groupType = GroupType(
                id: selectedGroup.id!,
                title: selectedGroup.title!,
                color: selectedGroup.color,
                indexNumber: selectedGroup.indexNumber,
                todo: nil
            )
        }

        var placeAlarm: PlaceAlarm? = nil
        if let placeAlarmType = selectedPlaceAlarm {
            placeAlarm = findOrCreatePlaceAlarm(from: placeAlarmType)
        }

        if let todo = todoToEdit {
            let todoToUpdate = TodoType(
                id: todo.id,
                title: selectedTitle,
                isCompleted: todo.isCompleted,
                dueTime: selectedDueDate,
                placeName: selectedPlaceName,
                timeAlarm: selectedTimesAlarm,
                group: groupType,
                placeAlarm: selectedPlaceAlarm
            )
            CoreDataManager.shared.updateTodo(info: todoToUpdate)

        } else {
            CoreDataManager.shared.createTodo(
                title: selectedTitle,
                dueTime: selectedDueDate,
                placeName: selectedPlaceName,
                group: selectedGroup,
                timeAlarm: selectedTimesAlarm,
                placeAlarm: placeAlarm
            )
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
        titleTextField.tintColor = TDStyle.color.mainDarkTheme
        
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
                cell.onDateChanged = { [weak self] newDate in
                    self?.selectedDueDate = newDate
                }
                cell.dateChipTappedHandler = { [weak self] in
                    self?.goDatePickerViewController()
                    self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
                cell.dateChipDeleteHandler = { [weak self] in
                    self?.selectedDueDate = nil
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
                cell.configure(with: selectedPlaceName)
                cell.onDeleteButtonTapped = { [weak self] in
                    self?.selectedPlaceName = nil
                    self?.selectedPlaceAlarm = nil
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
//                cell.configure(with: selectedTimesAlarm)
//                cell.onDeleteButtonTapped = { [weak self] deletedTime in
//                    guard let self = self else { return }
//                    self.selectedTimesAlarm.removeAll { $0 == deletedTime }
//                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                }
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
            border.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
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
//        if indexPath.section == 1 && indexPath.row == 0 {
//            let rowCount = CGFloat((selectedTimesAlarm.count + 2) / 3)
//            return 44 + rowCount * (30 + 10)
//        }
        
        return 44
    }
}

// MARK: - LocationPickerDelegate

extension AddTodoViewController: LocationPickerDelegate {
    func didPickLocation(_ address: String, latitude: Double, longitude: Double) {
        self.selectedPlaceName = address
        self.selectedPlaceAlarm = PlaceAlarmType(id: UUID(), distance: 0, latitude: latitude, longitude: longitude)
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? LocationTableViewCell {
            cell.configure(with: selectedPlaceName)
            tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        }
    }
    
    func goLocationPickerViewController() {
        let locationManager = CLLocationManager()
        let status = locationManager.authorizationStatus

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            let locationPickerVC = AddTodoLocationPickerViewController()
            locationPickerVC.delegate = self
            locationPickerVC.selectedPlace = selectedPlaceName
            locationPickerVC.selectedLatitude = selectedPlaceAlarm?.latitude
            locationPickerVC.selectedLongitude = selectedPlaceAlarm?.longitude
            locationPickerVC.modalPresentationStyle = .fullScreen
            present(locationPickerVC, animated: true, completion: nil)

        case .denied, .restricted:
            showAlertForLocationPermission()

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        @unknown default:
            print("Unknown authorization status")
        }
    }
    
    func showAlertForLocationPermission() {
        let alert = UIAlertController(title: "위치 권한 필요",
                                      message: "이 기능을 사용하기 위해서는 위치 권한이 필요합니다. 설정에서 위치 권한을 허용해주세요.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func findOrCreatePlaceAlarm(from type: PlaceAlarmType?) -> PlaceAlarm? {
        guard let type = type else { return nil }
        
        let fetchRequest: NSFetchRequest<PlaceAlarm> = PlaceAlarm.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", type.id as CVarArg)
        if let results = try? CoreDataManager.shared.context.fetch(fetchRequest), !results.isEmpty {
            return results.first
        }
        
        let newPlaceAlarm = PlaceAlarm(context: CoreDataManager.shared.context)
        newPlaceAlarm.id = type.id
        newPlaceAlarm.latitude = type.latitude
        newPlaceAlarm.longitude = type.longitude
        newPlaceAlarm.distance = Int32(type.distance)
        return newPlaceAlarm
    }
}

// MARK: - GroupSelectControllerDelegate

extension AddTodoViewController: GroupSelectModalDelegate {
    func groupSelectController(_ controller: GroupSelectModal, didSelectGroup group: Group) {
        self.selectedGroup = group
        let indexPath = IndexPath(row: 1, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func goToGroupSelectController() {
        let groupSelectController = GroupSelectModal()
        groupSelectController.delegate = self
        groupSelectController.selectedGroup = self.selectedGroup
        present(groupSelectController, animated: true, completion: nil)
    }
    
}

// MARK: - TimeAlarmSelectControllerDelegate

extension AddTodoViewController: TimeAlarmModalDelegate {
    func timesSelected(_ times: [String]) {
//        selectedTimesAlarm = times
//        let indexPath = IndexPath(row: 0, section: 1)
//        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    private func goTimeAlarmViewController() {
//        let timeAlarmViewController = TimeAlarmModal()
//        timeAlarmViewController.selectedTimes = selectedTimesAlarm
//        timeAlarmViewController.delegate = self
//        present(timeAlarmViewController, animated: true, completion: nil)
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
        //cell.locationLabel.text = selectedPlaceAlarm
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
