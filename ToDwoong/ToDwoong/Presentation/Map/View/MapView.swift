//
//  MapView.swift
//  ToDwoong
//
//  Created by yen on 3/6/24.
//

import MapKit
import UIKit

import SnapKit
import TodwoongDesign

class MapView: UIView {
    
    // MARK: - UI Properties
    
    let mapView: MKMapView = MKMapView()
    let groupChipsView = GroupChipsView()
    
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
    
    private func setCategoryChipsView() {
        addSubview(groupChipsView)

        groupChipsView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }

        groupChipsView.onAllGroupButtonTapped = { [weak self] in
            guard let self = self, let viewController = self.next as? MapViewController else { return }
            viewController.allGroupButtonTapped(viewController.customMapView.groupChipsView.allGroupButton)
        }
    }
    
    func addCategoryChip(category: CategoryModel, action: Selector, target: Any?) {
        groupChipsView.addCategoryChip(category: category, action: action, target: target)
    }
    
    func selectCategoryButton(_ button: TDCustomButton) {
        groupChipsView.selectCategoryButton(button)
    }
}
