//
//  DateTimePickerContainerCell.swift
//  ToDwoong
//
//  Created by mirae on 3/2/24.
//

import UIKit

import SnapKit

class DateTimePickerContainerCell: UICollectionViewCell {
    
    // MARK: - Properties
    var selectedDueDate: Date?
    var selectedDueTime: Date?
    var collectionView: UICollectionView!
    
    weak var parentViewController: AddTodoViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DateTimeOptionCell.self, forCellWithReuseIdentifier: "DateTimeContainerCell")
        collectionView.register(DatePickerCollectionViewCell.self, forCellWithReuseIdentifier: "DatePickerCell")
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
    
    func configure(withDate date: Date?, withTime time: Date?) {
        self.selectedDueDate = date
        self.selectedDueTime = time
        collectionView.reloadData()
    }
    
    private func configureDateTimeOptionCell(_ cell: DateTimeOptionCell, isDateCell: Bool) {
        cell.deleteButtonAction = { [weak self] in
            if isDateCell {
                self?.selectedDueDate = nil
                self?.selectedDueTime = nil
            } else {
                self?.selectedDueTime = nil
            }
            if let parentViewController = self?.parentViewController,
               let indexPath = parentViewController.datePickerIndexPath,
               indexPath.section == 2 {
                parentViewController.dismissDatePicker()
            }
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension DateTimePickerContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, 
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            if selectedDueDate == nil {
                selectedDueDate = Date()
            }
        } else if indexPath.item == 1 {
            if selectedDueTime == nil {
                selectedDueTime = Date()
            }
            if selectedDueDate == nil {
                selectedDueDate = Date()
            }
        }
        
        collectionView.reloadData()
        parentViewController?.handleDateOrTimeCellSelected(at: indexPath, in: self, 
                                                           mode: indexPath.item == 0 ? .date : .time)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "DateTimeContainerCell",
            for: indexPath
        ) as? DateTimeOptionCell else {
            return UICollectionViewCell()
        }
        
        let isDateCell = indexPath.item == 0
        configureDateTimeOptionCell(cell, isDateCell: isDateCell)
        
        let formatter = DateFormatter()
        formatter.dateFormat = indexPath.item == 0 ? "yyyy.MM.dd" : "a HH:mm"
        
        let date = indexPath.item == 0 ? selectedDueDate : selectedDueTime
        let dateString = date != nil ? formatter.string(from: date!) : ""
        
        cell.titleLabel.text = indexPath.item == 0 ? "날짜" : "시간"
        cell.setInfo(labelText: cell.titleLabel.text!, infoText: dateString)
        print("DateTimePickerContainerCell : \(dateString)")
        print("-------------------------------------------")
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DateTimePickerContainerCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 0, height: 0)
        }
        
        let spacing = layout.minimumInteritemSpacing
        let totalSpacing = spacing * (2 - 1)
        let width = (collectionView.bounds.width - totalSpacing) / 2
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}
  
