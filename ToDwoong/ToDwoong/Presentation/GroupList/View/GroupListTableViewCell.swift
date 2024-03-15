//
//  GroupListTableViewCell.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/4/24.
//

import UIKit

import SnapKit
import TodwoongDesign

final class NormalGroupListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = TDStyle.color.primaryLabel
        label.font = TDStyle.font.body(style: .regular)
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = TDStyle.color.bgGray
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("초기화가 구현되지 않았습니다.")
    }
    
    // MARK: - Helpers
    
    private func setLayout() {
        let views: [UIView] = [iconImageView, titleLabel, arrowImageView]
        views.forEach { view in
            addSubview(view)
            view.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                if view == iconImageView {
                    make.leading.equalToSuperview().offset(16)
                    make.width.height.equalTo(30)
                } else if view == titleLabel {
                    make.leading.equalTo(iconImageView.snp.trailing).offset(16)
                } else if view == arrowImageView {
                    make.trailing.equalToSuperview().offset(-16)
                    make.width.equalTo(10)
                    make.height.equalTo(15)
                }
            }
        }
    }
    
    func configureWithCategory(_ category: Category) {
        if let colorString = category.color {
            let color = UIColor(hex: colorString)
            let imageSize = CGSize(width: 30, height: 30)
            let roundedImage = UIImage.roundedImage(color: color, size: imageSize)
            iconImageView.image = roundedImage
        }
        titleLabel.text = category.title
    }
}

final class EditGroupListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    let deleteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "minus.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = TDStyle.color.bgRed
        button.addTarget(EditGroupListTableViewCell.self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = TDStyle.color.primaryLabel
        label.font = TDStyle.font.body(style: .regular)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("초기화가 구현되지 않았습니다.")
    }
    
    // MARK: - Actions
    
    @objc func deleteButtonTapped() {
        guard let tableView = superview as? ContentSizedTableView,
              let indexPath = tableView.indexPath(for: self) else {
                return
            }
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Helpers
    
    private func setLayout() {
        let views: [UIView] = [deleteButton, titleLabel]
        views.forEach { view in
            addSubview(view)
            view.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                if view == deleteButton {
                    make.leading.equalToSuperview().offset(16)
                    make.width.height.equalTo(30)
                } else if view == titleLabel {
                    make.leading.equalTo(deleteButton.snp.trailing).offset(16)
                }
            }
        }
    }
}
