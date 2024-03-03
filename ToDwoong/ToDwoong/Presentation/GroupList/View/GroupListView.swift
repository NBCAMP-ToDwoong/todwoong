//
//  GroupListView.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 2/29/24.
//

import UIKit

import SnapKit
import TodwoongDesign

final class GroupListView: UIView {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let cellIdentifier = "CategoryCell"
    
    private var dummyCategories: [TodoModel] {
        return [
            TodoModel(id: "1", title: "밥먹기", isCompleted: false, placeAlarm: false, timeAlarm: true),
            TodoModel(id: "2", title: "운동가기", isCompleted: false, placeAlarm: true, timeAlarm: false),
            TodoModel(id: "3", title: "씻기", isCompleted: false, placeAlarm: false, timeAlarm: false)
        ]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
        reloadData()
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TDCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension GroupListView: UICollectionViewDelegate {
    // 델리게이트 코드
}

extension GroupListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyCategories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier, for: indexPath) as? TDCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = dummyCategories[indexPath.item]
        cell.configure(data: category)
        
        return cell
    }
}
