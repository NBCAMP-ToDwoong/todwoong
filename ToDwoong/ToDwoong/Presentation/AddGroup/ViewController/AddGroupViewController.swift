//
//  AddGroupViewController.swift
//  ToDwoong
//
//  Created by 홍희곤 on 3/5/24.
//

import UIKit

import TodwoongDesign

final class AddGroupViewController: UIViewController {
    
    // MARK: - Properties
    
    private var selectedColor: String = {
        if let colorString = TDStyle.color.mainTheme.toHex() {
            return colorString
        }
        return ""
    }()
    
    // MARK: - UI Properties
    
    private var addGroupView = AddGroupView()
    
    // MARK: - Life Cycle

    override func loadView() {
        
        view = addGroupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonMethod()
        setDelegate()
        setNavigationBar()
    }
}

// MARK: - TextFieldDelegate

extension AddGroupViewController: UITextFieldDelegate {
    private func setDelegate() {
        addGroupView.groupTextField.delegate = self
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if let text = textField.text{
            if text.isEmpty {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
}

// MARK: - Set Button Method

extension AddGroupViewController {
    private func setButtonMethod() {
        
        addGroupView.buttonTapped = { button in
            if button.imageView?.image == UIImage(systemName: "xmark.circle") {
                guard let color = TDStyle.color.mainTheme.toHex() else { return }
                self.selectedColor = color
                self.addGroupView.checkMarkImageView.isHidden = true
                button.tintColor = .systemBlue
            } else {
                if let buttonColor = button.tintColor.toHex() {
                    self.selectedColor = buttonColor
                    self.addGroupView.palleteButton.tintColor = TDStyle.color.bgGray
                    self.addGroupView.checkMarkImageView.isHidden = false
                    
                    if let superViewFrame = button.superview?.frame {
                        let width = button.frame.width / 2
                        let gap = button.frame.width / 4
                        
                        self.changeCheckMarkPosition(
                            xAnchor: button.frame.midX + 16 - gap, yAnchor: superViewFrame.midY - gap,
                            width: width, heigth: width
                        )
                    }
                }
            }
        }
    }

    @objc func createGroup() {
        if let title = addGroupView.groupTextField.text {
//            CoreDataManager.shared.createCategory(title: title, color: selectedColor, todo: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Change Checkmark Position Method

extension AddGroupViewController {
    func changeCheckMarkPosition(xAnchor: CGFloat, yAnchor: CGFloat, width: CGFloat, heigth: CGFloat) {
        addGroupView.checkMarkImageView.frame = CGRect(
            x: Int(xAnchor), y: Int(yAnchor), width: Int(width), height: Int(heigth)
        )
    }
}

// MARK: - Set NavigationBar

extension AddGroupViewController {
    private func setNavigationBar() {
        self.title = "그룹 추가"
        let rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(createGroup))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
}
