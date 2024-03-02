//
//  ViewController.swift
//  ToDwoong
//
//  Created by yen on 2/23/24.
//

import UIKit

import TodwoongDesign

class TodoViewController: UIViewController {
    
    // MARK: Properties
    
    var test = TodoModel(id: "1", title: "친구와 약속", isCompleted: false, placeAlarm: false, timeAlarm: false)

    // MARK: UI Properties
    
    var todoView = TodoView()
    
    // MARK: Life Cycle
    
    override func loadView() {
        view = todoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
}

// MARK: Extensions

extension TodoViewController {
    
    private func setDelegates() {
        setCollectionView()
        setTableView()
    }
    
    private func setCollectionView() {
        todoView.categoryCollectionView.dataSource = self
        todoView.categoryCollectionView.delegate = self
    }
    
    private func setTableView() {
        todoView.todoTableView.dataSource = self
        todoView.todoTableView.delegate = self
    }
}

extension TodoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        return cell
    }
}

extension TodoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension TodoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let buttonText = "Test"
        let buttonSize = buttonText.size(withAttributes: [NSAttributedString.Key.font : TDStyle.font.body(style: .regular)])
        let buttonWidth = buttonSize.width
        let buttonHeight = buttonSize.height
        
        return CGSize(width: buttonWidth + 24, height: buttonHeight + 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension TodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TDTableViewCell.identifier, for: indexPath) as? TDTableViewCell else { return UITableViewCell() }
        if indexPath.row == 0 {
            cell.configure(data: test)
        }
        
        return cell
    }
    
    
}

extension TodoViewController: UITableViewDelegate {
    
}
