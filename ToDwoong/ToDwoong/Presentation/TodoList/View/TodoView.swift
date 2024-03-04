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
    
    
    // MARK: UI Properties
    
    lazy var groupListButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        
        return button
    }()
    
    lazy var groupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GroupCollectionViewCell.self, forCellWithReuseIdentifier: GroupCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    lazy var todoListFrameView: UIView = {
        let view = UIView()
        view.backgroundColor = TDStyle.color.lightGray
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    lazy var todoTableView: ContentSizeTableView = {
        let tableView = ContentSizeTableView()
        tableView.register(TDTableViewCell.self, forCellReuseIdentifier: TDTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
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
            groupListButton,
            groupCollectionView,
            todoListFrameView
        ].forEach{self.addSubview($0)}
        
        todoListFrameView.addSubview(todoTableView)
    
        groupListButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(groupCollectionView)
        }
        groupCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
            make.height.equalTo(30.33)
            make.leading.equalTo(groupListButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
        todoListFrameView.snp.makeConstraints { make in
            make.top.equalTo(groupCollectionView.snp.bottom).offset(10)
            make.trailing.leading.bottom.equalToSuperview()
        }
        todoTableView.snp.makeConstraints{ make in
            make.top.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}
