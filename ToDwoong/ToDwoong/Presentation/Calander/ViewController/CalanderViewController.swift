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
    
    lazy var todoList: [Todo] = []
    private var eventDates: [Date]?
    private var selectedDueDate: Date?
    
    // MARK: - UI Properties
    
    private var calendar: FSCalendar!
    private var tableView: UITableView!
    private var containerView: UIView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(dataUpdated(_:)), name: .DataUpdatedNotification, object: nil)
    }
    
    @objc func dataUpdated(_ notification: Notification) {
        fetchTodosAndSetEventDates()
        fetchTodos(for: selectedDueDate)
        tableView.reloadData()
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
        fetchTodos(for: selectedDueDate)
    }
    
    func setViews() {
        view.backgroundColor = .white
        configureCalendar()
        configureCalendarAppearance()
        configureContainerView()
        configureTableView()
        selectTodayDate()
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
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TDTableViewCell.self, forCellReuseIdentifier: TDTableViewCell.identifier)
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
            make.top.equalTo(containerView.snp.top).offset(16)
            make.left.equalTo(containerView.snp.left).offset(16)
            make.right.equalTo(containerView.snp.right).offset(-16)
            make.bottom.equalTo(containerView.snp.bottom)
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
        fetchTodos(for: today)
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
        fetchTodos(for: selectedDueDate)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TDTableViewCell.identifier,
                                                       for: indexPath) as? TDTableViewCell else {
            fatalError("Unable to dequeue TDTableViewCell")
        }
        
        let todo = todoList[indexPath.row]
        let todoModel = convertTodoData(todo: todo)!
        
        cell.configure(data: todoModel, iconImage: UIImage(named: "AddTodoMapPin")!)
        cell.checkButton.isSelected = todo.isCompleted
        
        cell.onCheckButtonTapped = { [weak tableView] in
            let isCompleted = !todo.isCompleted
            todo.isCompleted = isCompleted
            CoreDataManager.shared.saveContext()
            tableView?.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }

}

// MARK: - UITableViewDelegate

extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal,
                                            title: "수정") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let todoToEdit = self.todoList[indexPath.row]
            let addTodoVC = AddTodoViewController()
            addTodoVC.todoToEdit = todoToEdit
            self.navigationController?.pushViewController(addTodoVC, animated: true)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "삭제") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            let todoToDelete = self.todoList[indexPath.row]
            CoreDataManager.shared.deleteTodo(todo: todoToDelete)
            self.todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
            self.fetchTodosAndSetEventDates()  // 데이터 갱신
        }
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

// MARK: - CoreData Methods

extension CalendarViewController {
    private func fetchTodos(for date: Date?) {
        guard let selectedDate = date else { return }
        self.todoList = CoreDataManager.shared.filterTodoByDuedate(selectedDate)
        tableView.reloadData()
    }
    
    private func fetchTodosAndSetEventDates() {
        let todos = CoreDataManager.shared.readTodos()
        var uniqueDates = Set<Date>()
        
        for todo in todos {
            if let dueDate = todo.dueDate {
                let dateWithoutTime = Calendar.current.startOfDay(for: dueDate)
                uniqueDates.insert(dateWithoutTime)
            }
        }
        
        eventDates = Array(uniqueDates)
        calendar.reloadData()
    }
    
    private func convertTodoData(todo: Todo) -> TodoModel? {
        guard let id = todo.id, let title = todo.title else {
            return nil
        }
        
        let dueDate = todo.dueDate
        let dueTime = todo.dueTime
        let isCompleted = todo.isCompleted
        let place = todo.place
        let placeAlarm = todo.placeAlarm
        let timeAlarm = todo.timeAlarm
        let fixed = todo.fixed
        var category: CategoryModel?
        
        if let todoCategory = todo.category {
            category = CategoryModel(id: todoCategory.id ?? UUID(),
                                     title: todoCategory.title ?? "",
                                     color: todoCategory.color,
                                     indexNumber: todoCategory.indexNumber,
                                     todo: nil)
        }
        
        return TodoModel(id: id,
                         title: title,
                         dueDate: dueDate,
                         dueTime: dueTime,
                         place: place,
                         isCompleted: isCompleted,
                         fixed: fixed,
                         timeAlarm: timeAlarm,
                         placeAlarm: placeAlarm,
                         category: category)
    }
    
    private func convertTodoDatas(todos: [Todo]) -> [TodoModel] {
        let convertedTodos = todos.compactMap { convertTodoData(todo: $0) }
        return convertedTodos
    }
    
    func updateTodoInCoreData(todoId: UUID, isCompleted: Bool, completion: @escaping () -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", todoId as CVarArg)
        
        do {
            let fetchedTodos = try managedContext.fetch(fetchRequest)
            if let fetchedTodo = fetchedTodos.first {
                fetchedTodo.isCompleted = isCompleted
                try managedContext.save()
                completion()
            }
        } catch let error as NSError {
            print("Could not fetch or update. \(error), \(error.userInfo)")
        }
    }
    
    private func updateEventDatesAfterDeletion() {
        let todos = CoreDataManager.shared.readTodos()
        var uniqueDates = Set<Date>()
        
        for todo in todos {
            if let dueDate = todo.dueDate {
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
}
