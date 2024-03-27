//
//  AddTodoView.swift
//  ToDwoong
//
//  Created by mirae on 3/4/24.
//

import UIKit

import TodwoongDesign

final class AddTodoView: UIView {
    
    // MARK: UI Properties
    
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: setView

extension AddTodoView {
    private func setView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: "InfoCell")
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCell")
        collectionView.register(DateTimePickerContainerCell.self, forCellWithReuseIdentifier: "DateTimeContainerCell")
        collectionView.register(DatePickerCollectionViewCell.self, forCellWithReuseIdentifier: "DatePickerCell")
        collectionView.backgroundColor = TDStyle.color.lightGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(60)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
}
