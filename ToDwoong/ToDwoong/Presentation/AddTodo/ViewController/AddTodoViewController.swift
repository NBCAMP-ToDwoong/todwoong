//
//  AddTodoViewController.swift
//  ToDwoong
//
//  Created by mirae on 2/29/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class AddTodoViewController: UIViewController {
    
    // MARK: - Properties
    
    var selectedTitle: String?
    var selectedDueDate: Date?
    var selectedDueTime: Date?
    var selectedPlace: String?
    
    var datePickerIndexPath: IndexPath?
    var dateTimePickerContainerCell: DateTimePickerContainerCell?
    
    private var todoView: AddTodoView {
        guard let todoView = view as? AddTodoView else {
            fatalError("View is not of type AddTodoView")
        }
        return todoView
    }
    
    override func loadView() {
        view = AddTodoView()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBarButton()
        setNavigationBar()
        setTapGesture()
        setCollectionView()
    }
    // FIXME: - 테스트용 추후삭제
    func setBarButton() {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("완료", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
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
    
    // TODO: - 완료 버튼 액션 구현
    @objc func doneButtonTapped() {
        let title = "투두 제목" // 예시 제목
        let place = selectedPlace // 선택한 장소
        let dueDate = selectedDueDate // 선택한 기한 날짜
        let dueTime = selectedDueTime // 선택한 기한 시간
        let isCompleted = false // 완료 여부, 초기값으로 false 설정
        let timeAlarm = false // 시간 알람 설정, 초기값으로 false 설정
        let placeAlarm = false // 장소 알람 설정, 초기값으로 false 설정
        let category: Category? = nil // 카테고리 설정, 예시로는 nil로 설정

        // 얼럿으로 값 확인
        let alert = UIAlertController(title: "추가된 투두 정보", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))

        let message = """
        title: \(title)
        place: \(place)
        dueDate: \(dueDate)
        dueTime: \(dueTime)
        isCompleted: \(isCompleted)
        timeAlarm: \(timeAlarm)
        placeAlarm: \(placeAlarm)
        category: \(category)
        """
        alert.message = message
        present(alert, animated: true, completion: nil)
        
        CoreDataManager.shared.createTodo(title: title,
                                          place: place,
                                          dueDate: dueDate,
                                          dueTime: dueTime!,
                                          isCompleted: isCompleted,
                                          timeAlarm: timeAlarm,
                                          placeAlarm: placeAlarm,
                                          category: category)
        
    }
    
    func handleDateOrTimeCellSelected(at indexPath: IndexPath,
                                      in cell: DateTimePickerContainerCell,
                                      mode: UIDatePicker.Mode) {
        guard let cellIndexPath = todoView.collectionView.indexPath(for: cell) else { return }
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
                    self.addDatePickerSection(below: cellIndexPath.section, with: newItem)
                })
            } else {
                addDatePickerSection(below: cellIndexPath.section, with: newItem)
            }
        }
    }
    
    func addDatePickerSection(below section: Int, with item: Int) {
        let newSection = section + 1
        datePickerIndexPath = IndexPath(item: item, section: newSection)
        todoView.collectionView.performBatchUpdates({
            self.todoView.collectionView.insertSections(IndexSet(integer: newSection))
        }, completion: nil)
    }
    
    private func presentMapViewController() {
        let mapViewController = AddTodoLocationPickerViewController()
        mapViewController.modalPresentationStyle = .fullScreen
        self.present(mapViewController, animated: true, completion: nil)
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
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "InfoCell",
                for: indexPath
            ) as? InfoCollectionViewCell else {
                fatalError("InfoCollectionViewCell dequeuing failed.")
            }
            cell.label.text = ["그룹", "위치", "알람"][indexPath.item]
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
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
                print("Section 2, 그룹")
            case 1:
                presentMapViewController()
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

extension AddTodoViewController: DateTimePickerDelegate {
    func didPickDateOrTime(date: Date, mode: UIDatePicker.Mode) {
        print("didPickDateOrTime : \(date), \(mode.rawValue)")
        print("selectedDueDate : \(selectedDueDate)")
        print("selectedDueTime : \(selectedDueTime)")
        print("-------------------------------------------")
        
        if mode.rawValue == 1 {
            selectedDueDate = date
            print("Selected Date1: \(selectedDueDate)")
            if selectedDueTime != nil {
                selectedDueTime = nil
                print("Selected Time1: \(selectedDueTime)")
            }
        } else {
            selectedDueTime = date
            print("Selected Time2: \(selectedDueTime)")
            if selectedDueDate == nil {
                selectedDueDate = Calendar.current.startOfDay(for: Date())
                print("Selected Date2: \(selectedDueDate)")
            }
        }
        
        updateSelectedDueDateTime()
    }
    
    func updateSelectedDueDateTime() {
        let indexPath = IndexPath(item: 0, section: 1)
        guard let cell = todoView.collectionView.cellForItem(at: indexPath) as? DateTimePickerContainerCell else {
            return
        }
        dateTimePickerContainerCell = cell
        cell.configure(withDate: selectedDueDate, withTime: selectedDueTime)
        print("updateSelectedDueDateTime : \(selectedDueDate), \(selectedDueTime)")
        print("-------------------------------------------")
    }
}
