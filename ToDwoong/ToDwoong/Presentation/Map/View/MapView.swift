//
//  MapView.swift
//  ToDwoong
//
//  Created by yen on 3/6/24.
//

import UIKit
import MapKit

import SnapKit
import TodwoongDesign

class MapView: UIView {
    
    let mapView: MKMapView = MKMapView()
    private let scrollView: UIScrollView = UIScrollView()
    let stackView: UIStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        setMapView()
        setCategoryChipsView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setMapView() {
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setCategoryChipsView() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(44)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(scrollView)
        }
    }
    
    func addCategoryChip(category: CategoryModel, action: Selector, target: Any?) {
        let chipButton = TDCustomButton(frame: .zero, type: .chip, title: category.title, backgroundColor: TDStyle.color.colorFromString(category.color ?? "#D1FADF") ?? TDStyle.color.bgGreen)
        chipButton.addTarget(target, action: action, for: .touchUpInside)
        stackView.addArrangedSubview(chipButton)
    }
}
