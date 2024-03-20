//
//  GroupSelectModal.swift
//  ToDwoong
//
//  Created by mirae on 3/5/24.
//

import UIKit

import SnapKit
import TodwoongDesign

final class GroupSelectModal: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: GroupSelectModalDelegate?
    var groupList: [Category] = []
    var selectedCategory: Category?
    let addGroupButton = AddGroupButton(type: .system)
    
    // MARK: - UI Properties
    
    private lazy var timeNotificationButton: UIButton = {
        var config = UIButton.Configuration.plain()
        
        config.title = "그룹"
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .clear
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: TDStyle.font.body(style: .bold)
        ]
        config.attributedTitle = AttributedString("그룹", attributes: AttributeContainer(attributes))
        
        let button = UIButton(configuration: config, primaryAction: nil)
        
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        createNotificationButton(title: "닫기", method: #selector(closeModal), color: TDStyle.color.mainDarkTheme)
    }()
    
    private func createNotificationButton(title: String,
                                          method: Selector,
                                          color: UIColor? = TDStyle.color.primaryLabel
    ) -> UIButton {
        var config = UIButton.Configuration.plain()
        
        config.title = title
        config.baseForegroundColor = color
        config.baseBackgroundColor = .clear
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: TDStyle.font.body(style: .regular)
        ]
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer(attributes))
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.addTarget(self, action: method, for: .touchUpInside)
        
        return button
    }
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        tableView.register(GroupSelectModalTableViewCell.self, forCellReuseIdentifier: "GroupSelectModalTableViewCell")
        return tableView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupList = CoreDataManager.shared.readCategories()
        setUI()
        setLayout()
        setTableView()
        setAddGroupButton()
        configureModalStyle()
    }
    
    private func configureModalStyle() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium(), .large()]
            presentationController.prefersGrabberVisible = true
        }
    }
    
    private func updateSaveButtonAction() {
        if selectedCategory != nil {
            saveButton.setTitle("저장", for: .normal)
            saveButton.removeTarget(nil, action: nil, for: .allEvents)
            saveButton.addTarget(self, action: #selector(saveGroup), for: .touchUpInside)
        } else {
            saveButton.setTitle("닫기", for: .normal)
            saveButton.removeTarget(nil, action: nil, for: .allEvents)
            saveButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        }
    }
}

// MARK: - @objc Method

extension GroupSelectModal {
    @objc func saveGroup() {
        if let selectedCategory = selectedCategory {
            delegate?.groupSelectController(self, didSelectGroup: selectedCategory)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func addGroupAction() {
        let addGroupViewController = AddGroupViewController()
        addGroupViewController.modalPresentationStyle = .fullScreen
        self.present(addGroupViewController, animated: true, completion: nil)
    }
    
    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UI Method

extension GroupSelectModal {
    private func setUI() {
        [timeNotificationButton, addGroupButton, separatorLine, tableView, saveButton].forEach { view.addSubview($0) }
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        timeNotificationButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(10)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(15)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(0.5)
        }
        
        addGroupButton.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(5)
            make.height.equalTo(36)
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(addGroupButton.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    private func setAddGroupButton() {
        addGroupButton.addTarget(self, action: #selector(addGroupAction), for: .touchUpInside)
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "groupTableViewCellIdentifier")
    }
}

// MARK: - UITableViewDataSource

extension GroupSelectModal: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSelectModalTableViewCell",
                                                       for: indexPath) as? GroupSelectModalTableViewCell else {
            fatalError("Unable to dequeue a CategoryTableViewCell.")
        }
        
        let category = groupList[indexPath.row]
        let isSelected = category == selectedCategory
        cell.configure(with: category, isSelected: isSelected)
        updateSaveButtonAction()
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension GroupSelectModal: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = .none
            }
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            cell.tintColor = TDStyle.color.mainDarkTheme
            selectedCategory = groupList[indexPath.row]
            updateSaveButtonAction()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            updateSaveButtonAction()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

class GroupSelectModalTableViewCell: UITableViewCell {
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(iconImageView)
        iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15).isActive = true
        textLabel?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func configure(with category: Category, isSelected: Bool) {
        textLabel?.text = category.title
        if let colorString = category.color {
            let color = UIColor(hex: colorString)
            let imageSize = CGSize(width: 30, height: 30)
            let roundedImage = UIImage.roundedImage(color: color, size: imageSize)
            iconImageView.image = roundedImage
        }
        accessoryType = isSelected ? .checkmark : .none
    }
    
    private func createCircularImage(with color: UIColor, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.addEllipse(in: CGRect(origin: .zero, size: size))
            context.cgContext.drawPath(using: .fill)
        }
    }
}
