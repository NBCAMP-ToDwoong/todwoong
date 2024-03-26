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
    
    // MARK: - Properties
    
    var hasLocationChip: Bool = false
    
    // MARK: - UI Properties
    
    static let identifier = "LocationCell"
    
    let titleLabel = UILabel()
    var chipView: InfoChipView?
    
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
        titleLabel.font = TDStyle.font.body(style: .regular)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(30)
            make.trailing.lessThanOrEqualToSuperview().offset(-30)
        }
    }
    
    func configure(with selectedPlace: String?) {
        chipView?.removeFromSuperview()
        chipView = nil
        hasLocationChip = false

        if let place = selectedPlace, !place.isEmpty {
            let maxCharacters = 15
            let trimmedPlace: String
            if place.count > maxCharacters {
                let endIndex = place.index(place.startIndex, offsetBy: maxCharacters)
                trimmedPlace = place[..<endIndex] + ".."
            } else {
                trimmedPlace = place
            }
            
            let newChipView = InfoChipView(text: trimmedPlace, color: TDStyle.color.lightGray, showDeleteButton: true)
            hasLocationChip = true
            newChipView.delegate = self
            contentView.addSubview(newChipView)
            chipView = newChipView
            chipView?.snp.makeConstraints { make in
                make.centerY.equalTo(titleLabel.snp.centerY)
                make.trailing.equalToSuperview().offset(-30)
                make.height.equalTo(30)
            }

            if let chipView = chipView {
                titleLabel.snp.makeConstraints { make in
                    make.trailing.lessThanOrEqualTo(chipView.snp.leading).offset(-10).priority(.high)
                }
            }

            accessoryType = .none
        } else {
            titleLabel.snp.makeConstraints { make in
                make.trailing.lessThanOrEqualToSuperview().offset(-30)
            }
            accessoryType = .disclosureIndicator
        }
    }

}

// MARK: - InfoChipViewDelegate

extension LocationTableViewCell: InfoChipViewDelegate {
    func didTapDeleteButton(in chipView: InfoChipView) {
        chipView.removeFromSuperview()
        accessoryType = .disclosureIndicator
        onDeleteButtonTapped?()
    }
}
