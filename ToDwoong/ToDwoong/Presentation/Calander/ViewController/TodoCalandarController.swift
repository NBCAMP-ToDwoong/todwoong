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
    
    var todos: [Date]?
    
    private var calendar: FSCalendar!

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
        
        // 오늘 날짜의 스타일을 설정
        calendar.appearance.titleTodayColor = .white // 오늘 날짜의 글자색
        calendar.appearance.todayColor = TDStyle.color.mainDarkTheme // 오늘 날짜의 배경색
        calendar.appearance.titleSelectionColor = UIColor.black
        
        // 폰트 설정
        calendar.appearance.titleFont = TDStyle.font.body(style: .regular) // 모든 날짜에 대한 볼드체 폰트 설정
        
        calendar.appearance.eventDefaultColor = UIColor.black
        calendar.appearance.eventSelectionColor = TDStyle.color.mainDarkTheme
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.backgroundColor = .white
        
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
    
    func fetchEvents() {
        let dateMatter = DateFormatter()
        dateMatter.locale = Locale(identifier: "ko_KR")
        dateMatter.dateFormat = "yyyy-MM-dd"
        
        // events
        let myFirstEvent = dateMatter.date(from: "2024-03-10")
        let mySecondEvent = dateMatter.date(from: "2024-03-20")
        
        // 두 날짜를 배열에 추가. 옵셔널 바인딩을 사용하여 nil을 확인
        todos = [myFirstEvent, mySecondEvent].compactMap { $0 }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        guard let events = todos else { return 0 }
        if events.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
            return 1 // 이 날짜에 이벤트가 있으면 점을 하나 표시
        }
        return 0
    }
    
}
