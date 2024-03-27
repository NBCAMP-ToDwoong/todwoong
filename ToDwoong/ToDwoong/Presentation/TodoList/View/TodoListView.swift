//
//  TodoView.swift
//  ToDwoong
//
//  Created by 홍희곤 on 2/29/24.
//

import UIKit

import TodwoongDesign

final class TodoListView: UIView {
    
    // MARK: - UI Properties
    
    lazy var groupListButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    lazy var allGroupButton = TDButton.chip(title: "전체", backgroundColor: TDStyle.color.mainTheme)
    
    lazy var groupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GroupCollectionViewCell.self,
                                forCellWithReuseIdentifier: GroupCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private lazy var todoListFrameView: UIView = {
        let view = UIView()
        view.backgroundColor = TDStyle.color.lightGray
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    lazy var todoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: TodoListTableViewCell.identifier)
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "dwoong")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘은 어떤 일을 할까요?"
        label.textColor = TDStyle.color.mainTheme
        label.font = TDStyle.font.body(style: .bold)
        
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

// MARK: - Extensions

extension TodoListView {
    private func setUI() {
        self.backgroundColor = .white

        [
            groupListButton,
            allGroupButton,
            groupCollectionView,
            todoListFrameView,
            emptyImageView,
            emptyLabel
        ].forEach { self.addSubview($0) }
        
        todoListFrameView.addSubview(todoTableView)
    
        groupListButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(groupCollectionView)
            make.height.equalTo(allGroupButton)
            make.width.equalTo(groupListButton.snp.height)
        }
        allGroupButton.snp.makeConstraints { make in
            make.leading.equalTo(groupListButton.snp.trailing).offset(8)
            make.centerY.equalTo(groupCollectionView)
        }
        groupCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.height.equalTo(30.33)
            make.leading.equalTo(allGroupButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
        todoListFrameView.snp.makeConstraints { make in
            make.top.equalTo(groupCollectionView.snp.bottom).offset(10)
            make.trailing.leading.bottom.equalToSuperview()
        }
        todoTableView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
        emptyImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(self.snp.width).dividedBy(3)
            make.height.equalTo(emptyImageView.snp.width)
        }
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
}
