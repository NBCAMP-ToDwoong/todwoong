//
//  MapViewProtocols.swift
//  ToDwoong
//
//  Created by yen on 3/27/24.
//

import Foundation

protocol TodoDetailViewControllerDelegate: AnyObject {
    func didSelectLocation(latitude: Double, longitude: Double)
}
