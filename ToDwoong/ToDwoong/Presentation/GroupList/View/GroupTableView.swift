//
//  File.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/15/24.
//

import UIKit

import SnapKit

class GroupTableView: ContentSizedTableView {
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureTableView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTableView()
    }
    
    // MARK: - Helper
    
    private func configureTableView() {
        self.backgroundColor = .clear
    }
}
