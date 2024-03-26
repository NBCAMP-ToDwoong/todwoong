//
//  AlertController.swift
//  ToDwoong
//
//  Created by mirae on 3/26/24.
//

import UIKit

class AlertController {
    static func presentDeleteAlert(on viewController: UIViewController,
                                   message: String,
                                   cancelHandler: (() -> Void)?,
                                   confirmHandler: (() -> Void)?) {
        
        let alertController = UIAlertController(title: "항목을 완전히 삭제하시겠습니까?",
                                                message: message,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            cancelHandler?()
        }
        
        let confirmAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            confirmHandler?()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        viewController.present(alertController, animated: true)
    }
}
