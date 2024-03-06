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
        
        return button
    }()
    
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
        let tableView = UITableView()
        tableView.register(TDTableViewCell.self, forCellReuseIdentifier: TDTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "photo")    // FIXME: 이미지 정해지면 수정 예정
        imageView.image = image
        
        return imageView
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 투두를 추가해보세요!"
        label.textColor = TDStyle.color.mainTheme
        label.font = TDStyle.font.body(style: .regular)
        
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
            groupCollectionView,
            todoListFrameView,
            emptyImageView,
            emptyLabel
        ].forEach { self.addSubview($0) }
        
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
            make.bottom.equalToSuperview()
        }
        emptyImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(self.snp.width).dividedBy(2.5)
            make.height.equalTo(emptyImageView.snp.width)
        }
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView)
            make.centerX.equalToSuperview()
        }
    }
}
