//
//  PreferencesView.swift
//  ToDwoong
//
//  Created by 홍희곤 on 3/8/24.
//

import UIKit

import SnapKit
import TodwoongDesign

final class PreferencesView: UIView {
    
    // MARK: - UI Properties
    
    let preferencesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            PreferencesTableViewCell.self,
            forCellReuseIdentifier: PreferencesTableViewCell.identifier
        )
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        return tableView
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

extension PreferencesView {
    private func setUI() {
        backgroundColor = TDStyle.color.lightGray
        
        addSubview(preferencesTableView)
        
        preferencesTableView.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            make.bottom.equalToSuperview()
        }
    }
}
