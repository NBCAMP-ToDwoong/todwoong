//
//  TodoView.swift
//  ToDwoong
//
//  Created by 홍희곤 on 2/29/24.
//

import UIKit

import TodwoongDesign

final class TodoView: UIView {
    
    // MARK: Properties
    let buttonHeight = "Test".size(withAttributes: [NSAttributedString.Key.font : TDStyle.font.body(style: .regular)]).height
    
    // MARK: UI Properties
    
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    lazy var todoTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TDTableViewCell.self, forCellReuseIdentifier: TDTableViewCell.identifier)

        tableView.backgroundColor = .red
        return tableView
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        print(categoryCollectionView.collectionViewLayout.collectionViewContentSize.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

// MARK: Extensions

extension TodoView {
    func setUI() {
        self.backgroundColor = .white

        [
            categoryCollectionView,
            todoTableView
        ].forEach{self.addSubview($0)}
    
        categoryCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
            make.height.equalTo(30.33)
            make.trailing.leading.equalToSuperview()
        }
        todoTableView.snp.makeConstraints{ make in
            make.top.equalTo(categoryCollectionView.snp_bottomMargin).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
