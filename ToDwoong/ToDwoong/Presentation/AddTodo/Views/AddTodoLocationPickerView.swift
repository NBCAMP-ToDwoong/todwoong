//
//  AddTodoLocationPickerView.swift
//  ToDwoong
//
//  Created by mirae on 3/4/24.
//

import MapKit
import UIKit

import SnapKit
import TodwoongDesign

final class AddTodoLocationPickerView: UIView {
    
    // MARK: - UI Properties
    
    private var addressContainerView: UIStackView!
    private var topContainerView: UIView!
    
    var onSaveTapped: (() -> Void)?
    var onCloseTapped: (() -> Void)?
    var onSearchTapped: (() -> Void)?
    var onCenterLocationTapped: (() -> Void)?
    
    let mapView = MKMapView()
    let centerPinImageView = UIImageView(image: UIImage(named: "AddTodoMapPin"))
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = TDStyle.color.mainTheme
        return button
    }()
    
    let searchButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass.circle.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = TDStyle.font.body(style: .regular)
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = TDStyle.color.mainTheme
        return button
    }()
    
    let closeButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "multiply")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let currentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "currentLocationIcon"), for: .normal)
        button.tintColor = TDStyle.color.mainTheme
        return button
    }()
    
    let currentLocationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4

        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(mapView)
        mapView.addSubview(currentLocationView)
        mapView.addSubview(centerPinImageView)
        currentLocationView.addSubview(currentLocationButton)
        
        topContainerView = UIView()
        topContainerView.backgroundColor = .white
        addSubview(topContainerView)
        
        topContainerView.addSubview(closeButton)
        topContainerView.addSubview(searchButton)
        searchButton.addSubview(searchButtonImageView)
        closeButton.addSubview(closeButtonImageView)
        
        setAddressContainerView()
        
        bringSubviewToFront(topContainerView)
        
        setConstraints()
    }
    
}

// MARK: - setConstraints

extension AddTodoLocationPickerView {
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topContainerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(88)
        }
        
        centerPinImageView.contentMode = .scaleAspectFit
            centerPinImageView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-30)
                make.width.equalTo(30)
                make.height.equalTo(60)
            }
        
        closeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.bottom.equalTo(topContainerView.snp.bottom).inset(8)
            make.size.equalTo(26)
        }
        
        closeButtonImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(topContainerView.snp.bottom).inset(8)
            make.size.equalTo(30)
        }
        
        searchButtonImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addressContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(5)
        }
        
        currentLocationView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16) // 오른쪽에서 16포인트 떨어진 곳에 위치
            make.bottom.equalTo(addressContainerView.snp.top).offset(-8)
            make.width.height.equalTo(40) // currentLocationView의 크기를 80x80으로 설정
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.center.equalTo(currentLocationView.snp.center) // currentLocationView의 중앙에 위치
            make.width.height.equalTo(30) // currentLocationButton의 크기를 30x30으로 설정
        }
        
        mapView.bringSubviewToFront(currentLocationButton)
    }

}

// MARK: - setAddressContainerView

extension AddTodoLocationPickerView {
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
            make.height.greaterThanOrEqualTo(80)
        }
        
        let confirmAddressButton = TDButton.full(title: "저장", backgroundColor: TDStyle.color.mainTheme)
        confirmAddressButton.setTitleColor(UIColor.white, for: .normal)
        confirmAddressButton.addTarget(self, action: #selector(didTapConfirmAddressButton), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        currentLocationButton.addTarget(self, action: #selector(didCurrentLocationButton), for: .touchUpInside)
        
        let buttonContainerView = UIView()
        buttonContainerView.addSubview(confirmAddressButton)
        stackView.addArrangedSubview(buttonContainerView)
        
        confirmAddressButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
            make.height.equalTo(44)
        }
        
        let spacerView = UIView()
        spacerView.backgroundColor = .white
        addSubview(spacerView)
        spacerView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - @objc methode

extension AddTodoLocationPickerView {
    @objc private func didTapConfirmAddressButton() {
        onSaveTapped?()
    }
    
    @objc private func didTapSearchButton() {
        onSearchTapped?()
    }
    
    @objc private func didTapCloseButton() {
        onCloseTapped?()
    }
    
    @objc private func didCurrentLocationButton() {
        onCenterLocationTapped?()
    }
    
}
