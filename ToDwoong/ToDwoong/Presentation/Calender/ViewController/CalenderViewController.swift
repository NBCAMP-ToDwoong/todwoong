//
//  TodoCalandarController.swift
//  ToDwoong
//
//  Created by mirae on 3/5/24.
//

import CoreData
import UIKit

import FSCalendar
import SnapKit
import TodwoongDesign

final class CalendarViewController: UIViewController {
    
    // MARK: - Properties
    
    private var todoList: [TodoDTO] {
        if let selectedDate = selectedDueDate {
            let filteredTodoList = allTodoList.filter {
                guard let todoDate = $0.dueTime else { return false }
                return Calendar.current.isDate(todoDate, equalTo: selectedDate, toGranularity: .day)
            }
            return filteredTodoList
        }
        else {
            return allTodoList
        }
    }
    private var eventDates: [Date]?
    private var selectedDueDate: Date?
    private var allTodoList = CoreDataManager.shared.readTodos()
    
    private var lastSelectedIndexPath: IndexPath?
    private var lastSelectedTimestamp: TimeInterval = 0
    
    // MARK: - UI Properties
    
    private var calendar: FSCalendar!
    private var tableView: UITableView!
    private var containerView: UIView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
        setNotifications()
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Setup and Configuration

extension CalendarViewController {
    func loadData() {
        selectedDueDate = Date()
        fetchTodosAndSetEventDates()
    }
    
    private func todoDataFetch() {
        allTodoList = CoreDataManager.shared.readTodos()
        tableView.reloadData()
    }
    
    func setViews() {
        view.backgroundColor = .white
        configureCalendar()
        configureCalendarAppearance()
        configureContainerView()
        configureTableView()
        selectTodayDate()
    }
    private func setNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataUpdated(_:)),
            name: .TodoDataUpdatedNotification,
            object: nil)
    }
    private func configureCalendar() {
        calendar = FSCalendar()
        calendar.placeholderType = .none
        calendar.delegate = self
        calendar.dataSource = self
        view.addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(view)
            make.height.equalTo(330)
        }
    }
    
    private func configureContainerView() {
        containerView = UIView()
        containerView.backgroundColor = TDStyle.color.lightGray
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(8)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: TodoListTableViewCell.identifier)
        tableView.layer.masksToBounds = true
        
        let emptyStateView = UIView()
        let emptyStateImageView = UIImageView()
        let emptyStateLabel = UILabel()
        
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.image = UIImage(named: "dwoong")
        emptyStateLabel.text = "오늘은 어떤 일을 할까요?"
        emptyStateLabel.textColor = TDStyle.color.mainTheme
        emptyStateLabel.font = TDStyle.font.body(style: .bold)
        emptyStateLabel.textAlignment = .center
        
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -20),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 100),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 100),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 20),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor)
        ])
        
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.backgroundView = emptyStateView
        tableView.backgroundView?.isHidden = true
    }
    
    private func configureCalendarAppearance() {
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerDateFormat = "yyyy.MM"
        calendar.appearance.headerTitleColor = TDStyle.color.mainDarkTheme
        calendar.appearance.weekdayTextColor = .systemGray3
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.selectionColor = UIColor(red: 230/255, green: 244/255, blue: 237/255, alpha: 1)
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.titleSelectionColor = UIColor.black
        calendar.appearance.titleFont = TDStyle.font.body(style: .regular)
        calendar.appearance.eventDefaultColor = TDStyle.color.mainDarkTheme
        calendar.appearance.eventSelectionColor = TDStyle.color.mainDarkTheme
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.backgroundColor = .white
        
        let prevMonthButton = UIButton(type: .system)
        let nextMonthButton = UIButton(type: .system)
        prevMonthButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        nextMonthButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        prevMonthButton.tintColor = TDStyle.color.mainDarkTheme
        nextMonthButton.tintColor = TDStyle.color.mainDarkTheme
        prevMonthButton.addTarget(self, action: #selector(goToPreviousMonth), for: .touchUpInside)
        nextMonthButton.addTarget(self, action: #selector(goToNextMonth), for: .touchUpInside)
        
        view.addSubview(prevMonthButton)
        view.addSubview(nextMonthButton)
        
        prevMonthButton.snp.makeConstraints { make in
            make.left.equalTo(calendar.snp.left).offset(15)
            make.centerY.equalTo(calendar.calendarHeaderView.snp.centerY)
        }
        
        nextMonthButton.snp.makeConstraints { make in
            make.right.equalTo(calendar.snp.right).offset(-15)
            make.centerY.equalTo(calendar.calendarHeaderView.snp.centerY)
        }
    }
    
    private func selectTodayDate() {
        let today = Date()
        calendar.select(today)
        selectedDueDate = today
    }
}

// MARK: - FSCalendarDelegate, FSCalendarDataSource

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        guard let eventDates = eventDates else { return 0 }
        return eventDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) ? 1 : 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDueDate = date
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let hasData = !todoList.isEmpty
        tableView.backgroundView?.isHidden = hasData
        tableView.backgroundColor = .clear
        return hasData ? todoList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.identifier,
                                                       for: indexPath) as? TodoListTableViewCell else {
            fatalError("Unable to dequeue TDTableViewCell")
        }
        
        var todo = todoList[indexPath.row]
        
        cell.tdCellView.onCheckButtonTapped = {
            todo.isCompleted = !todo.isCompleted
            CoreDataManager.shared.updateIsCompleted(id: todo.id, status: todo.isCompleted)
            self.todoDataFetch()
            NotificationCenter.default.post(name: .TodoDataUpdatedNotification, object: nil)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        cell.tdCellView.onLocationButtonTapped = { [weak self] in
            guard let self = self else { return }
            let mapViewController = MapViewController()
            
            // FIXME: mapViewController 수정 이후 FIX
            
//            self.navigationController?.pushViewController(mapViewController, animated: true)
          }
          
        cell.configure(todo: todo)
        
        
        return cell
    }

}

// MARK: - UITableViewDelegate

extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal,
                                            title: "편집") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let todoToEdit = self.todoList[indexPath.row]
            let addTodoVC = AddTodoViewController()
            addTodoVC.todoToEdit = todoToEdit
            addTodoVC.modalPresentationStyle = .fullScreen
            self.present(addTodoVC, animated: true)
            completionHandler(true)
        }
        editAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "삭제") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            AlertController.presentDeleteAlert(on: self,
                                               message: "이 투두가 영구히 삭제됩니다!",
                                               cancelHandler: {
                completionHandler(false)
            },
                                               confirmHandler: {
                let todoToDelete = self.todoList[indexPath.row]
                CoreDataManager.shared.deleteTodo(todo: todoToDelete)
                self.todoDataFetch()
                NotificationCenter.default.post(name: .TodoDataUpdatedNotification,
                                                object: nil)
                self.fetchTodosAndSetEventDates()
                completionHandler(true)
            })
        }
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentTimestamp = Date().timeIntervalSince1970
        
        if lastSelectedIndexPath == indexPath && currentTimestamp - lastSelectedTimestamp < 0.4 {
            var todo = todoList[indexPath.row]
            todo.isCompleted = !todo.isCompleted
            CoreDataManager.shared.updateIsCompleted(id: todo.id, status: todo.isCompleted)
            
            self.todoDataFetch()
            NotificationCenter.default.post(name: .TodoDataUpdatedNotification, object: nil)
            
            return
        }
        lastSelectedIndexPath = indexPath
        lastSelectedTimestamp = currentTimestamp
    }
}

// MARK: - CoreData Methods

extension CalendarViewController {
    
    private func fetchTodosAndSetEventDates() {
        todoDataFetch()
        
        let todos = self.allTodoList
        var uniqueDates = Set<Date>()
        
        for todo in todos {
            if let dueDate = todo.dueTime {
                let dateWithoutTime = Calendar.current.startOfDay(for: dueDate)
                uniqueDates.insert(dateWithoutTime)
            }
        }
        
        eventDates = Array(uniqueDates)
        calendar.reloadData()
    }
    
    private func updateEventDatesAfterDeletion() {
        let todos = CoreDataManager.shared.readTodos()
        var uniqueDates = Set<Date>()
        
        for todo in todos {
            if let dueDate = todo.dueTime {
                let dateWithoutTime = Calendar.current.startOfDay(for: dueDate)
                uniqueDates.insert(dateWithoutTime)
            }
        }
        
        eventDates = Array(uniqueDates)
        calendar.reloadData()
    }
    
    private func getTodoById(id: UUID) -> Todo? {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try CoreDataManager.shared.context.fetch(fetchRequest)
            return results.first
        } catch let error as NSError {
            print("Error fetching Todo with id: \(id), \(error), \(error.userInfo)")
            return nil
        }
    }
    
}

// MARK: - @objc mothode

extension CalendarViewController {
    @objc private func goToPreviousMonth() {
        guard let previousMonth = Calendar.current.date(byAdding: .month,
                                                        value: -1,
                                                        to: self.calendar.currentPage) else { return }
        self.calendar.setCurrentPage(previousMonth, animated: true)
    }
    
    @objc private func goToNextMonth() {
        guard let nextMonth = Calendar.current.date(byAdding: .month,
                                                    value: 1,
                                                    to: self.calendar.currentPage) else { return }
        self.calendar.setCurrentPage(nextMonth, animated: true)
    }
    
    @objc private func dataUpdated(_ notification: Notification) {
        fetchTodosAndSetEventDates()
        tableView.reloadData()
    }
}
