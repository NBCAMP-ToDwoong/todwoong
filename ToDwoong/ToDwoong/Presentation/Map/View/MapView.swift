//
//  MapView.swift
//  ToDwoong
//
//  Created by yen on 3/6/24.
//

import MapKit
import UIKit

import TodwoongDesign

class MapView: UIView {
    
    // MARK: - UI Properties
    
    lazy var groupListButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    lazy var allGroupButton = TDButton.chip(title: "전체", backgroundColor: TDStyle.color.mainTheme)
    
    lazy var groupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GroupCollectionViewCell.self,
                                forCellWithReuseIdentifier: GroupCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    let mapView = MKMapView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setMapView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapView {
    
    private func setUI() {
        [
            groupListButton,
            allGroupButton,
            groupCollectionView
        ].forEach { self.addSubview($0) }
        
        groupListButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(groupCollectionView)
            make.height.equalTo(allGroupButton)
            make.width.equalTo(groupListButton.snp.height)
        }
        allGroupButton.snp.makeConstraints { make in
            make.leading.equalTo(groupListButton.snp.trailing).offset(8)
            make.centerY.equalTo(groupCollectionView)
        }
        groupCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.height.equalTo(30.33)
            make.leading.equalTo(allGroupButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
    }
    
    private func setMapView() {
        addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(groupCollectionView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
