//
//  TodoDetailView.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/7/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class TodoDetailView: UIView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(TDTableViewCell.self, forCellReuseIdentifier: TDTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = TDStyle.color.bgGray
        tableView.backgroundColor = TDStyle.color.bgGray
        setTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
}
