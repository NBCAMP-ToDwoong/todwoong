//
//  ContentSizedViewCell.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/4/24.
//

import UIKit
 
class ContentSizedTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
