//
//  AddGroupButton.swift
//  ToDwoong
//
//  Created by t2023-m0041 on 3/15/24.
//

import UIKit

import SnapKit
import TodwoongDesign

class AddGroupButton: UIButton {
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureButton()
    }
    
    // MARK: - Helpers
    
    private func configureButton() {
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.title = "그룹 추가"
            config.baseBackgroundColor = .white
            config.baseForegroundColor = UIColor.systemGray3
            config.cornerStyle = .medium
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
            config.imagePlacement = .leading
            config.imagePadding = 8
            
            let plusIcon = UIImage(systemName: "plus")?.withTintColor(.gray.withAlphaComponent(0.5),
                                                                      renderingMode: .alwaysOriginal)
            config.image = plusIcon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 14))
            
            self.configuration = config
            self.contentHorizontalAlignment = .leading
        } else {
            self.setTitle("그룹 추가", for: .normal)
            self.backgroundColor = .white
            self.setTitleColor(UIColor.systemGray3, for: .normal)
            self.layer.cornerRadius = 8
            self.contentHorizontalAlignment = .left
            
            let plusIcon = UIImage(systemName: "plus")?.withTintColor(.gray.withAlphaComponent(0.5),
                                                                      renderingMode: .alwaysOriginal)
            let resizedIcon = resizeImage(image: plusIcon, targetSize: CGSize(width: 12, height: 12))
            self.setImage(resizedIcon, for: .normal)
            
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        }
        
        self.titleLabel?.font = TDStyle.font.body(style: .regular)
    }
    
    private func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage? {
        guard let image = image else { return nil }
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        return resizedImage
    }
}
