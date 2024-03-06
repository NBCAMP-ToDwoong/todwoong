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

final class CalendarController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    // MARK: - Properties
    
    lazy var todoList = convertTodoDatas(todos: [])
    
    private var eventDates: [Date]? // 이벤트 날짜만 따로 저장하기 위한 배열
    private var selectedDueDate: Date?
    
    // MARK: - UI Properties
    private var calendar: FSCalendar!
    private var tableView: UITableView!
    private var containerView: UIView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCalendar()
        configureCalendarAppearance()
        configureContainerView()
        configureTableView()
        
        selectedDueDate = Date()
        fetchTodosAndSetEventDates()
        fetchTodos(for: selectedDueDate)
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
    
    // MARK: - Configure UI
    private func configureContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        containerView.layer.cornerRadius = 12
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
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        
        // 빈 상태의 뷰 구성
        let emptyStateView = UIView()
        let emptyStateImageView = UIImageView()
        let emptyStateLabel = UILabel()

        // 빈 상태의 이미지와 라벨을 설정
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.image = UIImage(named: "Dwong")
        emptyStateLabel.text = "오늘은 어떤 일을 할까요?"
        emptyStateLabel.textColor = TDStyle.color.mainDarkTheme
        emptyStateLabel.textAlignment = .center

        // 빈 상태 뷰에 이미지 뷰와 라벨을 추가
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)

        // 오토레이아웃 설정
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

        // 빈 상태 뷰를 테이블뷰의 backgroundView로 설정
        tableView.backgroundView = emptyStateView
        tableView.backgroundView?.isHidden = true // 초기 상태에서는 숨겨진 상태로 설정
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
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        guard let eventDates = eventDates else { return 0 }
        return eventDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) ? 1 : 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDueDate = date
        fetchTodos(for: selectedDueDate)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CalendarController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let hasData = !todoList.isEmpty
        tableView.backgroundView?.isHidden = hasData
        return hasData ? todoList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TDTableViewCell.identifier,
                                                       for: indexPath) as? TDTableViewCell else {
            fatalError("존재하지 않는 셀입니다.")
        }
        
        let todo = todoList[indexPath.row]
        cell.configure(data: todo)
        
        // 체크 버튼이 눌렸을 때의 동작을 정의합니다.
        cell.onCheckButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            print("체크박스 선택됨 > UUID: \(todo.id)")
            
            let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", todo.id! as any CVarArg as CVarArg)
            do {
                let fetchedTodos = try CoreDataManager.shared.context.fetch(fetchRequest)
                if let fetchedTodo = fetchedTodos.first {
                    CoreDataManager.shared.updateTodo(todo: fetchedTodo,
                                                      newTitle: fetchedTodo.title ?? "",
                                                      newPlace: fetchedTodo.place ?? "",
                                                      newDate: fetchedTodo.dueDate,
                                                      newTime: fetchedTodo.dueTime,
                                                      newCompleted: !fetchedTodo.isCompleted,
                                                      newTimeAlarm: fetchedTodo.timeAlarm,
                                                      newPlaceAlarm: fetchedTodo.placeAlarm,
                                                      newCategory: fetchedTodo.category)
                    
                    print("업데이트 완료 > UUID: \(fetchedTodo.id), isCompleted: \(fetchedTodo.isCompleted)")
                    
                    cell.checkButton.isSelected = !fetchedTodo.isCompleted
                    DispatchQueue.main.async {
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
            } catch let error {
                print("Todo fetching error: \(error)")
            }
        }
        
        cell.checkButton.isSelected = todo.isCompleted
        
        return cell
    }
}

// MARK: - CoreData Methods

extension CalendarController {
    func fetchTodos(for date: Date?) {
        guard let selectedDate = date else { return }
        let todos = CoreDataManager.shared.filterTodoByDuedate(selectedDate)
        self.todoList = convertTodoDatas(todos: todos)
        tableView.reloadData()
    }
    
    func fetchTodosAndSetEventDates() {
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
    
    private func convertTodoData(_ todo: Todo) -> TodoModel? {
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
        let convertedTodos = todos.compactMap { convertTodoData($0) }
        return convertedTodos
    }
}
