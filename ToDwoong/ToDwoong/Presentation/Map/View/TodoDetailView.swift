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
    
    // MARK: - UI Properties
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(TDTableViewCell.self, forCellReuseIdentifier: TDTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var emptyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
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
        label.textAlignment = .center
            
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = TDStyle.color.lightGray
        tableView.backgroundColor = TDStyle.color.lightGray
        setTableView()
        setTodwoongUI()
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
    
    private func setTodwoongUI() {
        addSubview(emptyStackView)
        emptyStackView.addArrangedSubview(emptyImageView)
        emptyStackView.addArrangedSubview(emptyLabel)
        
        emptyStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).dividedBy(3)
            make.height.equalTo(emptyImageView.snp.width)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
}
