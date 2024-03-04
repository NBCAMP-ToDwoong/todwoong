//
//  DateTimePickerContainerCell.swift
//  ToDwoong
//
//  Created by mirae on 3/2/24.
//

import UIKit

import SnapKit

class DateTimePickerContainerCell: UICollectionViewCell {
    var collectionView: UICollectionView!
    weak var parentViewController: AddTodoViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DateTimeOptionCell.self, forCellWithReuseIdentifier: "DateTimeContainerCell")
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension DateTimePickerContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let mode: UIDatePicker.Mode = indexPath.item == 0 ? .date : .time
        parentViewController?.handleDateOrTimeCellSelected(at: indexPath, in: self, mode: mode)
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
        cell.label.text = indexPath.item == 0 ? "날짜" : "시간"
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
