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
    
    let tableView = UITableView()
    var groups: [String] = ["학교", "병원", "살려주세요"] // 예시 그룹 데이터
    
    weak var delegate: AddTodoGroupSelectControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupModalPresentationStyle()
    }
    
    func setupModalPresentationStyle() {
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
    }
    
    func setupTableView() {
        let modalHeight = view.frame.height * 0.8
        let modalWidth = view.frame.width
        let modalYPosition = view.frame.height * (1 - 0.7) / 2
        let modalViewFrame = CGRect(x: 0, y: modalYPosition, width: modalWidth, height: modalHeight)
        let modalView = UIView(frame: modalViewFrame)
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 15
        modalView.clipsToBounds = true
        modalView.backgroundColor = .systemGray6
        
        view.addSubview(modalView)
        modalView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 나머지 뷰 부분에 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        view.addGestureRecognizer(tapGesture)
        
        // 테이블 뷰 설정
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GroupCell")
    }
    
    @objc func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension AddTodoGroupSelectController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        cell.textLabel?.text = groups[indexPath.row]
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGroup = groups[indexPath.row]
        delegate?.groupSelectController(self, didSelectGroup: selectedGroup)
    }
    
    weak var delegate: AddTodoGroupSelectControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
}
