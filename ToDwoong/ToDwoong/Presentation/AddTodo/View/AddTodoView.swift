//
//  AddTodoView.swift
//  ToDwoong
//
//  Created by mirae on 3/4/24.
//

import UIKit

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
    
    private func setView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: "InfoCell")
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TitleCell")
        collectionView.register(DateTimePickerContainerCell.self, forCellWithReuseIdentifier: "DateTimeContainerCell")
        collectionView.register(DatePickerCollectionViewCell.self, forCellWithReuseIdentifier: "DatePickerCell")
        collectionView.backgroundColor = .white
        self.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
