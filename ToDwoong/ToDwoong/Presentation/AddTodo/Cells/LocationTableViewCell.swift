//
//  LocationTableViewCell.swift
//  ToDwoong
//
//  Created by mirae on 3/15/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class LocationTableViewCell: UITableViewCell {
    static let identifier = "LocationCell"
    
    let titleLabel = UILabel()
    var chipView: InfoChipView?
    var hasLocationChip: Bool = false
    
    public var onDeleteButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.text = "위치"
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.equalToSuperview().offset(30)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    func configure(with selectedPlace: String?) {
        chipView?.removeFromSuperview()
        chipView = nil
        hasLocationChip = false

        if let place = selectedPlace, !place.isEmpty {
            let newChipView = InfoChipView(text: place, color: TDStyle.color.lightGray, showDeleteButton: true)
            hasLocationChip = true
            newChipView.delegate = self
            contentView.addSubview(newChipView)
            chipView = newChipView
            chipView?.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(6)
                make.trailing.equalToSuperview().offset(-30)
                make.height.equalTo(30)
            }

            accessoryType = .none
        } else {
            accessoryType = .disclosureIndicator
        }
    }

}

extension LocationTableViewCell: InfoChipViewDelegate {
    func didTapDeleteButton(in chipView: InfoChipView) {
        chipView.removeFromSuperview()
        accessoryType = .disclosureIndicator
        onDeleteButtonTapped?()
    }
}
