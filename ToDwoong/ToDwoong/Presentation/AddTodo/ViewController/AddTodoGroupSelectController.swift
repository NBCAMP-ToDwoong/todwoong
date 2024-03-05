//
//  AddTodoGroupSelectController.swift
//  ToDwoong
//
//  Created by mirae on 3/5/24.
//

import UIKit

import SnapKit

class AddTodoGroupSelectController: UIViewController {
    
    // MARK: UI Properties
    
    weak var delegate: AddTodoGroupSelectControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
}
