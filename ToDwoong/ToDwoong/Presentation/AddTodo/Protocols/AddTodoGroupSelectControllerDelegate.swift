//
//  AddTodoGroupSelectControllerDelegate.swift
//  ToDwoong
//
//  Created by mirae on 3/5/24.
//

protocol AddTodoGroupSelectControllerDelegate: AnyObject {
    func groupSelectController(_ controller: AddTodoGroupSelectController, didSelectGroup group: String)
}
