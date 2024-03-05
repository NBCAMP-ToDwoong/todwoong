//
//  ContentSizeTableView.swift
//  ToDwoong
//
//  Created by 홍희곤 on 3/4/24.
//

import UIKit

class ContentSizeTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        let height = self.contentSize.height + self.contentInset.top + self.contentInset.bottom
        return CGSize(width: self.contentSize.width, height: height)
      }
      override func layoutSubviews() {
        self.invalidateIntrinsicContentSize()
        super.layoutSubviews()
      }
}
