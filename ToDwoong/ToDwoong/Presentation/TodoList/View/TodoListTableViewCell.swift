//
//  TodoListTableViewCell.swift
//  ToDwoong
//
//  Created by 홍희곤 on 3/21/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class TodoListTableViewCell: UITableViewCell {
    
    // MARK: - Property
    
    public static var identifier = "TodoListTableViewCellIdentifier"
    
    // MARK: - UI Property
    
    var tdCellView = TDTableViewCellView()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        //FIXME: 접근제어자 수정 이후 구현
//        tdCellView.resetData()
    }
}

// MARK: - Configure

extension TodoListTableViewCell {
    func configure(todo: TodoDTO) {
        guard let image = UIImage(named: "AddTodoMapPin") else { return }
        
        tdCellView.configure(
            title: todo.title, group: todo.group?.title,
            groupColor: todo.group?.color, dueTime: todo.dueTime,
            placeName: todo.placeName, iconImage: image
        )
        tdCellView.checkButton.isSelected = todo.isCompleted
    }
    
    private func setUI() {
        contentView.addSubview(tdCellView)
        
        tdCellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}