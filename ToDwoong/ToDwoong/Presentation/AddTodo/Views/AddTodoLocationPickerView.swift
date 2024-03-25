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
    
    let mapView = MKMapView()
    let centerPinImageView = UIImageView(image: UIImage(named: "AddTodoMapPin"))
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = TDStyle.color.mainDarkTheme
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
        button.tintColor = TDStyle.color.mainDarkTheme
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
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.tintColor = TDStyle.color.mainDarkTheme
        return button
    }()
    
    var onSaveTapped: (() -> Void)?
    var onCloseTapped: (() -> Void)?
    var onSearchTapped: (() -> Void)?
    
    private var addressContainerView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        [mapView, centerPinImageView, searchButton, closeButton, currentLocationButton].forEach { addSubview($0) }
        searchButton.addSubview(searchButtonImageView)
        closeButton.addSubview(closeButtonImageView)
        setAddressContainerView()
    }
    
}

// MARK: - setConstraints

extension AddTodoLocationPickerView {
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        centerPinImageView.contentMode = .scaleAspectFit
        centerPinImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.width.equalTo(30)
            make.height.equalTo(60)
        }

        searchButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(10)
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(30)
        }
        
        searchButtonImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(10)
            make.left.equalToSuperview().inset(16)
            make.width.height.equalTo(30)
        }
        
        closeButtonImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        currentLocationButton.snp.makeConstraints { make in
            make.top.equalTo(addressContainerView.snp.top).inset(8)
            make.right.equalTo(addressContainerView.snp.right).inset(8)
            make.width.height.equalTo(30)
        }
        
        addressContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(5)
        }
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
        confirmAddressButton.addTarget(self, action: #selector(didTapConfirmAddressButton), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
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
}
