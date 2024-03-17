//
//  PlaceAlarmTableViewCell.swift
//  ToDwoong
//
//  Created by mirae on 3/15/24.
//

import UIKit

import SnapKit

class PlaceAlarmTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "PlaceAlarmCell"
    
    var switchValueChangedHandler: ((Bool) -> Void)?
    
    // MARK: - UI Properties
    
    let titleLabel = UILabel()
    let placeAlarmSwitch = UISwitch()
    let locationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(placeAlarmSwitch)
        contentView.addSubview(locationLabel)
        
        titleLabel.text = "장소 알림"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = UIColor.black
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        
        placeAlarmSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints { make in
            make.trailing.equalTo(placeAlarmSwitch.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }

    }
    
    private func setupActions() {
        placeAlarmSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    @objc private func switchValueChanged() {
        if placeAlarmSwitch.isOn {
            switchValueChangedHandler?(true)
        } else {
            switchValueChangedHandler?(false)
            locationLabel.text = nil
        }
    }
    
}

