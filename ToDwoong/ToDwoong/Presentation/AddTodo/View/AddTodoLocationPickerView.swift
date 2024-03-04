//
//  AddTodoLocationPickerView.swift
//  ToDwoong
//
//  Created by mirae on 3/4/24.
//

import UIKit

import MapKit
import SnapKit
import TodwoongDesign

protocol AddTodoLocationPickerViewDelegate: AnyObject {
    func didConfirmAddress(_ address: String)
}

class AddTodoLocationPickerView: UIView {
    let mapView = MKMapView()
    let centerPinImageView = UIImageView(image: UIImage(named: "AddTodoMapPin"))
    let searchBar = UISearchBar()
    
    weak var delegate: AddTodoLocationPickerViewDelegate?
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private var addressContainerView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setMapView()
        setCenterPinImageView()
        setSearchBar()
        setAddressContainerView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setMapView() {
        addSubview(mapView)
    }

    private func setCenterPinImageView() {
        addSubview(centerPinImageView)
        centerPinImageView.contentMode = .scaleAspectFit
    }

    private func setSearchBar() {
        addSubview(searchBar)
    }

    private func setAddressContainerView() {
        let stackView = UIStackView(arrangedSubviews: [addressLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        addSubview(stackView)
        addressContainerView = stackView
        addressLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(70)
        }
        
        // 버튼 생성 및 설정
        let confirmAddressButton = TDButton.full(title: "저장", backgroundColor: TDStyle.color.mainTheme)
        confirmAddressButton.addTarget(self, action: #selector(confirmAddressButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(confirmAddressButton)
        confirmAddressButton.snp.makeConstraints { make in
            make.height.equalTo(44) // 버튼 높이 유지
        }
        
        // 흰 배경 추가
        let whiteBackgroundView = UIView()
        whiteBackgroundView.backgroundColor = .white
        addSubview(whiteBackgroundView)
        whiteBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        centerPinImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
            make.width.equalTo(30)
            make.height.equalTo(60)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(10)
        }
        
        addressContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview() // 좌우 여백을 0으로 조정
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(5) // 하단 여백을 조정
        }
    }
    
    @objc private func confirmAddressButtonTapped() {
        let address = addressLabel.text
        delegate?.didConfirmAddress(address ?? "") // 'with' 키워드 제거
    }
}
