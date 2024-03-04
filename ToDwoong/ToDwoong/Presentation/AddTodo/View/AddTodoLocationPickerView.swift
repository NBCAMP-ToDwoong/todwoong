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
    
    // MARK: UI Properties
    
    let mapView = MKMapView()
    let searchBar = UISearchBar()
    let centerPinImageView = UIImageView(image: UIImage(named: "AddTodoMapPin"))
    let addressLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = TDStyle.font.body(style: .regular)
        return label
    }()
    
    weak var delegate: AddTodoLocationPickerViewDelegate?
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
        [mapView, centerPinImageView, searchBar].forEach { addSubview($0) }
        setAddressContainerView()
    }
    
}

// MARK: setConstraints

extension AddTodoLocationPickerView {
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        centerPinImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(10)
        }
        
        addressContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(5)
        }
    }
}

// MARK: setAddressContainerView

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
            make.height.greaterThanOrEqualTo(70)
        }
        
        let confirmAddressButton = TDButton.full(title: "저장", backgroundColor: TDStyle.color.mainTheme)
        confirmAddressButton.addTarget(self, action: #selector(didTapConfirmAddressButton), for: .touchUpInside)
        stackView.addArrangedSubview(confirmAddressButton)
        confirmAddressButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        let whiteBackgroundView = UIView()
        whiteBackgroundView.backgroundColor = .white
        addSubview(whiteBackgroundView)
        whiteBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: @objc

extension AddTodoLocationPickerView {
    @objc private func didTapConfirmAddressButton() {
        let address = addressLabel.text
        delegate?.didTapConfirmAddress(address ?? "")
    }
}
