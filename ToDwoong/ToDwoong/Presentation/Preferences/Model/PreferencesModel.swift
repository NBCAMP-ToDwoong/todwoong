//
//  Preferences.swift
//  ToDwoong
//
//  Created by 홍희곤 on 3/8/24.
//

import Foundation

final class PreferencesModel {
    let title: String
    var action: (() -> Void)?
    
    init(title: String) {
        self.title = title
    }
}
