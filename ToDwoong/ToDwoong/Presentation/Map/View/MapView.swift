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
    
    // MARK: - UI Properties
    
    let mapView: MKMapView = MKMapView()
    private let scrollView: UIScrollView = UIScrollView()
    let stackView: UIStackView = UIStackView()
    var selectedCategoryButton: CategoryChipButton?
    
    lazy var groupListButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        let configuration = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "line.3.horizontal", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    lazy var allGroupButton: CategoryChipButton = {
        let button = CategoryChipButton(title: "전체", color: TDStyle.color.mainTheme)
        button.addTarget(self, action: #selector(allGroupButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = TDStyle.font.body(style: .regular)
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8) 
        return button
    }()

    // MARK: - Lifecycle
    
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
    
    // MARK: - UI Method
    
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
        scrollView.addSubview(groupListButton)
        scrollView.addSubview(allGroupButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(30)
        }
        
        groupListButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(stackView)
        }

        allGroupButton.snp.makeConstraints { make in
            make.leading.equalTo(groupListButton.snp.trailing).offset(8)
            make.centerY.equalTo(stackView)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.equalTo(allGroupButton.snp.trailing).offset(8)
            make.trailing.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(scrollView)
        }
    }
    
    func addCategoryChip(category: CategoryModel, action: Selector, target: Any?) {
        let chipButton = CategoryChipButton(title: category.title, color: TDStyle.color.colorFromString(category.color ?? "#D1FADF") ?? TDStyle.color.bgGreen)
        chipButton.addTarget(target, action: action, for: .touchUpInside)
        stackView.addArrangedSubview(chipButton)
    }
    
    func selectCategoryButton(_ button: CategoryChipButton) {
        selectedCategoryButton?.isSelectedButton = false
        selectedCategoryButton = button
        selectedCategoryButton?.isSelectedButton = true
    }
    
    // MARK: - Objc
    
    @objc func allGroupButtonTapped() {
        if let viewController = next as? MapViewController {
            viewController.allGroupButtonTapped(allGroupButton)
        }
    }
}
