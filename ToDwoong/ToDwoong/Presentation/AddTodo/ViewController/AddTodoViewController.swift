//
//  AddTodoViewController.swift
//  ToDwoong
//
//  Created by mirae on 2/29/24.
//

import UIKit

import SnapKit
import TodwoongDesign

final class AddTodoViewController: UIViewController {
    
    // MARK: - Properties
    
    var todoToEdit: Todo?
    var selectedTitle: String?
    var selectedDueDate: Date?
    var selectedDueTime: Date?
    var selectedPlace: String?
    var selectedGroup: Category?
    var selecetTimeAlarm: Bool!
    var selectePlaceAlarm: Bool!
    
    var datePickerIndexPath: IndexPath?
    var dateTimePickerContainerCell: DateTimePickerContainerCell?
    
    private var todoView: AddTodoView {
        guard let todoView = view as? AddTodoView else {
            fatalError("View is not of type AddTodoView")
        }
        return todoView
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTapGesture()
        setCollectionView()
        setViewBasedOnTodo()
    }
    
    override func loadView() {
        view = AddTodoView()
    }
    
    private func setViewBasedOnTodo() {
        if let todo = todoToEdit {
            navigationItem.title = "투두 수정"
            selectedTitle = todo.title
            selectedDueDate = todo.dueDate
            selectedDueTime = todo.dueTime
            selectedPlace = todo.place
            selecetTimeAlarm = todo.timeAlarm
            selectePlaceAlarm = todo.placeAlarm
            selectedGroup = todo.category
        } else {
            navigationItem.title = "투두 추가"
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = "투두 추가"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: self,
            action: #selector(doneButtonTapped)
        )
    }
    
    private func setCollectionView() {
        todoView.collectionView.dataSource = self
        todoView.collectionView.delegate = self
    }
    
    @objc func doneButtonTapped() {
        guard let title = selectedTitle, !title.isEmpty else {
            print("제목이 비어 있습니다.")
            return
        }
        let place = selectedPlace
        let isCompleted = false
        let timeAlarm = selecetTimeAlarm ?? false
        let placeAlarm = selectePlaceAlarm ?? false
        let category = selectedGroup
        
        if let todo = todoToEdit {
            CoreDataManager.shared.updateTodo(todo: todo,
                                              newTitle: title,
                                              newPlace: place ?? "",
                                              newDate: selectedDueDate,
                                              newTime: selectedDueTime,
                                              newCompleted: isCompleted,
                                              newTimeAlarm: timeAlarm,
                                              newPlaceAlarm: placeAlarm,
                                              newCategory: category)
            print("투두 항목이 업데이트되었습니다.")
        } else {
            CoreDataManager.shared.createTodo(title: title,
                                              place: place,
                                              dueDate: selectedDueDate,
                                              dueTime: selectedDueTime,
                                              isCompleted: isCompleted,
                                              timeAlarm: timeAlarm,
                                              placeAlarm: placeAlarm,
                                              category: category)
            print("새 투두 항목이 생성되었습니다.")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func handleDateOrTimeCellSelected(at indexPath: IndexPath,
                                      in cell: DateTimePickerContainerCell,
                                      mode: UIDatePicker.Mode) {
        guard let cellIndexPath = todoView.collectionView.indexPath(for: cell) else { return }
        
        if mode == .time && selectedDueDate == nil {
            selectedDueDate = Date()
        }
        
        let newItem = mode == .date ? 0 : 1
        if let existingDatePickerIndexPath = datePickerIndexPath,
           existingDatePickerIndexPath.section == cellIndexPath.section + 1,
           existingDatePickerIndexPath.item == newItem {
            return
        } else {
            if let existingDatePickerIndexPath = datePickerIndexPath {
                todoView.collectionView.performBatchUpdates({
                    self.todoView.collectionView.deleteSections(IndexSet(integer: existingDatePickerIndexPath.section))
                    self.datePickerIndexPath = nil
                }, completion: { _ in
                    self.addDatePickerSection(below: cellIndexPath.section, with: newItem, mode: mode)
                })
            } else {
                addDatePickerSection(below: cellIndexPath.section, with: newItem, mode: mode)
            }
        }
    }
    
    func addDatePickerSection(below section: Int, with item: Int, mode: UIDatePicker.Mode) {
        let newSection = section + 1
        datePickerIndexPath = IndexPath(item: item, section: newSection)
        todoView.collectionView.performBatchUpdates({
            self.todoView.collectionView.insertSections(IndexSet(integer: newSection))
        }, completion: nil)
        
        if mode == .date {
            selectedDueDate = Date()
        } else if mode == .time {
            let fixedDate = Calendar.current.date(from: DateComponents(year: 1970, month: 1, day: 1))!
            let currentTime = Calendar.current.dateComponents([.hour, .minute], from: Date())
            selectedDueTime = Calendar.current.date(bySettingHour: currentTime.hour!,
                                                    minute: currentTime.minute!,
                                                    second: 0, of: fixedDate)
        }
    }
    
    @objc func removeAddress() {
        self.selectedPlace = nil
        let indexPath = IndexPath(item: 1, section: 2)
        todoView.collectionView.reloadItems(at: [indexPath])
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension AddTodoViewController: UIGestureRecognizerDelegate {
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissDatePicker() {
        guard let datePickerIndexPath = datePickerIndexPath else { return }
        self.datePickerIndexPath = nil
        
        DispatchQueue.main.async {
            if self.todoView.collectionView.numberOfSections > self.numberOfSections(in: self.todoView.collectionView) {
                self.todoView.collectionView.performBatchUpdates({
                    self.todoView.collectionView.deleteSections(IndexSet(integer: datePickerIndexPath.section))
                }, completion: nil)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view {
            if touchView.isDescendant(of: todoView.collectionView) {
                let touchLocation = touch.location(in: todoView.collectionView)
                if let indexPath = todoView.collectionView.indexPathForItem(at: touchLocation) {
                    if indexPath.section == 1 {
                        return false
                    }
                }
            }
        }
        return true
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension AddTodoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datePickerIndexPath == nil ? 3 : 4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if let datePickerIndexPath = datePickerIndexPath, section == datePickerIndexPath.section {
            return 1
        } else if section == 2 || (datePickerIndexPath != nil && section == 3) {
            return 3
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let datePickerIndexPath = datePickerIndexPath, indexPath.section == datePickerIndexPath.section {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DatePickerCell", for: indexPath) as? DatePickerCollectionViewCell else {
                fatalError("DatePickerCollectionViewCell dequeuing failed.")
            }
            let mode: UIDatePicker.Mode = datePickerIndexPath.item == 0 ? .date : .time
            cell.configure(for: mode)
            cell.delegate = self
            return cell
            
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DateTimeContainerCell",
                for: indexPath
            ) as? DateTimePickerContainerCell else {
                fatalError("DateTimePickerContainerCell dequeuing failed.")
            }
            
            cell.parentViewController = self
            cell.configure(withDate: selectedDueDate, withTime: selectedDueTime)
            
            dateTimePickerContainerCell = cell
            
            return cell
        } else if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "TitleCell",
                for: indexPath
            ) as? TitleCollectionViewCell else {
                fatalError("TitleCollectionViewCell dequeuing failed.")
            }
            cell.delegate = self
            cell.textField.text = selectedTitle
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "InfoCell",
                for: indexPath
            ) as? InfoCollectionViewCell else {
                fatalError("InfoCollectionViewCell dequeuing failed.")
            }
            switch indexPath.section {
            case 2:
                switch indexPath.item {
                case 0:
                    cell.configureCell(title: "그룹", detail: selectedGroup?.title ?? "") // 그룹 셀, 받아온 그룹 정보 설정
                case 1:
                    cell.configureCell(title: "위치", detail: selectedPlace ?? "", showremoveButton: selectedPlace != nil)
                    cell.removeButton.removeTarget(nil, action: nil, for: .allEvents)
                    cell.removeButton.addTarget(self, action: #selector(removeAddress), for: .touchUpInside)
                case 2:
                    cell.configureCell(title: "알람")
                default: break
                }
            default: break
            }
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                print("Section 1, 제목")
            default:
                break
            }
        case 1:
            if let datePickerIndexPath = datePickerIndexPath {
                self.datePickerIndexPath = nil
                collectionView.performBatchUpdates({
                    collectionView.deleteSections(IndexSet(integer: datePickerIndexPath.section))
                }, completion: nil)
            } else {
                let newSection = indexPath.section + 1
                self.datePickerIndexPath = IndexPath(row: indexPath.item, section: newSection)
                collectionView.performBatchUpdates({
                    collectionView.insertSections(IndexSet(integer: newSection))
                }, completion: nil)
            }
        case 2:
            switch indexPath.item {
            case 0:
                goToGroupSelectController()
            case 1:
                goToMapViewController()
            case 2:
                print("Section 2, 알람")
            default:
                break
            }
        default:
            break
        }
    }
    
}

// MARK: - PresentController

extension AddTodoViewController: AddTodoGroupSelectControllerDelegate {
    private func goToMapViewController() {
        let mapViewController = AddTodoLocationPickerViewController()
        mapViewController.delegate = self
        mapViewController.modalPresentationStyle = .fullScreen
        if let todo = todoToEdit, let address = selectedPlace {
            mapViewController.setLocation(address)
        }
        present(mapViewController, animated: true, completion: nil)
    }
    
    private func goToGroupSelectController() {
        let groupSelectController = AddTodoGroupSelectController()
        groupSelectController.delegate = self
        present(groupSelectController, animated: true, completion: nil)
    }
    
    func groupSelectController(_ controller: AddTodoGroupSelectController, didSelectGroup group: Category) {
        selectedGroup = group
        controller.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AddTodoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let datePickerIndexPath = datePickerIndexPath, indexPath.section == datePickerIndexPath.section {
            if datePickerIndexPath.item == 0 {
                return CGSize(width: collectionView.frame.width, height: 360)
            } else {
                return CGSize(width: collectionView.frame.width, height: 200)
            }
        }
        
        if indexPath.section == 1 {
            return CGSize(width: collectionView.bounds.width, height: 80)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (section == 0 || section == 1) ? 10 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 3 {
            return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        } else if section == 1 {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        } else {
            return UIEdgeInsets.zero
        }
    }
    
}

// MARK: - DateTimePickerDelegate

extension AddTodoViewController: DateTimePickerDelegate {
    func didPickDateOrTime(date: Date, mode: UIDatePicker.Mode) {
        if mode == .date {
            selectedDueDate = date
        } else if mode == .time {
            let fixedDate = Calendar.current.date(from: DateComponents(year: 1970, month: 1, day: 1))!
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
            selectedDueTime = Calendar.current.date(bySettingHour: timeComponents.hour!,
                                                    minute: timeComponents.minute!,
                                                    second: 0, of: fixedDate)
        }
        updateSelectedDueDateTime()
    }
    
    func updateSelectedDueDateTime() {
        let indexPath = IndexPath(item: 0, section: 1)
        guard let cell = todoView.collectionView.cellForItem(at: indexPath) as? DateTimePickerContainerCell else {
            return
        }
        dateTimePickerContainerCell = cell
        
        if selectedDueTime != nil {
            selectedDueDate = selectedDueDate ?? Date()
        }
        
        cell.configure(withDate: selectedDueDate, withTime: selectedDueTime)
    }
}

// MARK: - AddTodoLocationPickerDelegate

extension AddTodoViewController: AddTodoLocationPickerDelegate {
    func didPickLocation(_ address: String) {
        self.selectedPlace = address
        
        let indexPath = IndexPath(item: 1, section: 2)
        todoView.collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - TitleCollectionViewCellDelegate

extension AddTodoViewController: TitleCollectionViewCellDelegate {
    func titleCellDidEndEditing(_ text: String?) {
        self.selectedTitle = text
    }
}
