//
//  TodoCalandarController.swift
//  ToDwoong
//
//  Created by mirae on 3/5/24.
//

import UIKit

import FSCalendar
import SnapKit
import TodwoongDesign

class TodoCalendarController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    private var calendar: FSCalendar!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCalendar()
        configureCalendarAppearance()
    }

    private func configureCalendar() {
        calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        view.addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(view)
            make.height.equalTo(300)
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldDisplayCellForDate date: Date, atMonthPosition position: FSCalendarMonthPosition) -> Bool {
        return position == .current
    }

    private func configureCalendarAppearance() {
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.appearance.headerTitleColor = TDStyle.color.mainDarkTheme
        calendar.appearance.weekdayTextColor = .systemGray3
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.selectionColor = UIColor(red: 230/255, green: 244/255, blue: 237/255, alpha: 1)
        calendar.appearance.titleTodayColor = UIColor.red
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.titleSelectionColor = UIColor.black
        calendar.appearance.eventDefaultColor = UIColor.black
        calendar.appearance.eventSelectionColor = TDStyle.color.mainDarkTheme
        calendar.backgroundColor = .white
        calendar.placeholderType = .none
        
        // 화살표 버튼을 캘린더 뷰에 추가
        let prevMonthButton = UIButton(type: .system)
        let nextMonthButton = UIButton(type: .system)

        prevMonthButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        nextMonthButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        
        // 화살표 버튼의 색상을 TDStyle에 정의된 메인 다크 테마 색상으로 설정
        prevMonthButton.tintColor = TDStyle.color.mainDarkTheme
        nextMonthButton.tintColor = TDStyle.color.mainDarkTheme

        prevMonthButton.addTarget(self, action: #selector(goToPreviousMonth), for: .touchUpInside)
        nextMonthButton.addTarget(self, action: #selector(goToNextMonth), for: .touchUpInside)

        // 화살표 버튼을 캘린더 헤더 뷰에 추가하고 위치를 조정
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
        guard let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self.calendar.currentPage) else { return }
        self.calendar.setCurrentPage(previousMonth, animated: true)
    }

    @objc private func goToNextMonth() {
        guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: self.calendar.currentPage) else { return }
        self.calendar.setCurrentPage(nextMonth, animated: true)
    }

}
