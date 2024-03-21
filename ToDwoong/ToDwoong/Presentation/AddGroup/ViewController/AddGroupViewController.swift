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
    
    private var editMode = false
    private var editGroup: Group?
    
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
        hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkEditMode()
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
                self.addGroupView.addButton.isEnabled = false
                addGroupView.validationGuideLabel.isHidden = false
            } else {
                self.addGroupView.addButton.isEnabled = true
                addGroupView.validationGuideLabel.isHidden = true
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let maxLength = 5
        
        let currentLength = textField.text?.count ?? 0
        let newLength = currentLength + string.count - range.length
        
        if newLength > maxLength {
            addGroupView.restrictionLabel.isHidden = false
        } else {
            addGroupView.restrictionLabel.isHidden = true
        }
        
        return newLength <= maxLength
    }
}

// MARK: - Keyboard Hide Method

extension AddGroupViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Set Button Method

extension AddGroupViewController {
    private func setButtonMethod() {
        
        addGroupView.palleteButtonTapped = { button in
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
        
        addGroupView.addButtonTapped = {
            if let title = self.addGroupView.groupTextField.text {
                CoreDataManager.shared.createGroup(title: title, color: self.selectedColor)
                NotificationCenter.default.post(name: .GroupDataUpdatedNotification, object: nil)
                self.dismiss(animated: true)
            }
        }
        
        addGroupView.cancelButtonTapped = {
            self.dismiss(animated: true)
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

// MARK: - EditMode Method

extension AddGroupViewController {
    func editModeOn(group: Group) {
        editMode = true
        editGroup = group
    }
    
    private func checkEditMode() {
        if editMode {
            setEditMode()
        }
    }
    
    private func setEditMode() {
        addGroupView.validationGuideLabel.isHidden = true
        
        let buttons = [addGroupView.palleteButton1,
                       addGroupView.palleteButton2, addGroupView.palleteButton3,
                       addGroupView.palleteButton4, addGroupView.palleteButton5,
                       addGroupView.palleteButton6, addGroupView.palleteButton7]
        
        if let category = editGroup {
            addGroupView.groupTextField.text = category.title
            
            if UIColor(hex: category.color!) == TDStyle.color.mainTheme {
                addGroupView.palleteButtonAction(sender: addGroupView.palleteButton)
            } else {
                for button in buttons {
                    if UIColor(hex: category.color!) == button.tintColor {
                        addGroupView.palleteButtonAction(sender: button)
                    }
                }
            }
        }
        
        addGroupView.addButton.setTitle("편집", for: .normal)
        addGroupView.addButton.isEnabled = true
        addGroupView.addButtonTapped = {
            guard let group = self.editGroup else { return }
            
            if let title = self.addGroupView.groupTextField.text {
                
                //FIXME: - CoreDataManager 수정 이후 변경사항 적용 현재는 업데이트 메서드가 별개의 type으로 인자를 받음
                
//                CoreDataManager.shared.updateCategory(category: group,
//                                                      newTitle: title,
//                                                      newColor: self.selectedColor)

                NotificationCenter.default.post(name: .GroupDataUpdatedNotification, object: nil)
                self.dismiss(animated: true)
            }
        }
        
    }
}
