//
//  CalendarController.swift
//  ToDwoong
//
//  Created by mirae on 3/5/24.
//

import UIKit

import FSCalendar
import SnapKit
import TodwoongDesign

final class CalendarController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    // MARK: - UI Properties

    private var todos: [Date]?
    private var calendar: FSCalendar!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureCalendar()
        configureCalendarAppearance()
        fetchEvents()
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
            make.height.equalTo(300)
        }
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
                                                    o: self.calendar.currentPage) else { return }
        self.calendar.setCurrentPage(nextMonth, animated: true)
    }

    func fetchEvents() {
        let dateMatter = DateFormatter()
        dateMatter.locale = Locale(identifier: "ko_KR")
        dateMatter.dateFormat = "yyyy-MM-dd"

        let myFirstEvent = dateMatter.date(from: "2024-03-10")
        let mySecondEvent = dateMatter.date(from: "2024-03-20")

        todos = [myFirstEvent, mySecondEvent].compactMap { $0 }
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        guard let events = todos else { return 0 }
        if events.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
            return 1
        }
        return 0
    }

}
