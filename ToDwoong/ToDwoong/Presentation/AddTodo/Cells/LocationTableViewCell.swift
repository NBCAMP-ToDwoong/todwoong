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
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(30)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    func configure(with selectedPlace: String?) {
        chipView?.removeFromSuperview() // 기존 칩뷰 제거
        chipView = nil // 참조 초기화
        hasLocationChip = false
        
        if let place = selectedPlace, !place.isEmpty {
            let newChipView = InfoChipView(text: place, color: TDStyle.color.lightGray, showDeleteButton: true)
            hasLocationChip = true
            newChipView.delegate = self
            contentView.addSubview(newChipView)
            chipView = newChipView
            // 칩뷰의 위치를 타이틀 라벨 바로 아래로 설정
            chipView?.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(4) // 타이틀 라벨 아래에 4pt 간격
                make.leading.equalTo(titleLabel.snp.leading) // 타이틀 라벨과 좌측 정렬
                make.trailing.lessThanOrEqualToSuperview().offset(-30) // 오른쪽 여백 유지
                make.height.equalTo(30) // 칩뷰의 높이 설정
            }
            
            accessoryType = .none // 액세서리 타입을 none으로 설정
        } else {
            accessoryType = .disclosureIndicator // 액세서리 타입을 disclosureIndicator로 설정
        }
    }
}

extension LocationTableViewCell: InfoChipViewDelegate {
    func didTapDeleteButton(in chipView: InfoChipView) {
        chipView.removeFromSuperview() // 칩뷰 제거
        accessoryType = .disclosureIndicator // 액세서리 타입 복원
        onDeleteButtonTapped?() // 삭제 버튼 탭 콜백 호출
    }
}
