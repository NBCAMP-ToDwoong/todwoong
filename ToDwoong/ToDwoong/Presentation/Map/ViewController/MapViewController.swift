//
//  MapViewController2.swift
//  ToDwoong
//
//  Created by yen on 3/21/24.
//

import MapKit
import UIKit

import SnapKit
import TodwoongDesign

final class MapViewController: UIViewController {
    
    // MARK: - Properties
    private let regionRadius: CLLocationDistance = 1000
    private lazy var allTodoList: [TodoType] = [] {
        didSet { updateMapAnnotations() }
    }
    private lazy var groupList: [Group] = []
    private lazy var pins: [ColoredAnnotation] = []
    private var selectedGroup: Int? // 선택된 그룹의 인덱스
    
    // MARK: - UI Properties
    private lazy var dataManager = CoreDataManager.shared
    private var floatingButton: FloatingButton!
    private lazy var mapView = MapView()
    private lazy var locationManager = CLLocationManager()
    private var todoDetailViewController: TodoDetailViewController?
    
    private lazy var buttonAction: ((UIButton) -> Void) = { [weak self] button in
        guard let self = self else { return }
        selectedGroup = button.tag
        mapView.allGroupButton.alpha = 0.3
        openTodoListModal(name: button.titleLabel?.text!)
        updateMapAnnotations()
        mapView.groupCollectionView.reloadData()
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setNavigationItem()
        setUI()
        setFloatingButton()
        setAction()
        
        setMapSetting()
        setLocationManager()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updatePinsAfterDeletion),
                                               name: .todoDeleted,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updatePinsAfterDeletion),
                                               name: .TodoDataUpdatedNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(updateTableView),
                                               name: .TodoDataUpdatedNotification,
                                               object: nil)
    }
    
    private func fetchData() {
        allTodoList = CoreDataManager.shared.readAllTodos()
        groupList = CoreDataManager.shared.readGroups() // 그룹 리스트 패치
    }
    
    @objc func updatePinsAfterDeletion() {
        fetchData()
    }
    
    @objc func updateTableView() {
        fetchData()
        self.todoDetailViewController?.reloadDetailViewTable()
    }
}

// MARK: - Setting Method
extension MapViewController {
    private func setAction() {
        mapView.groupListButton.addTarget(self, action: #selector(groupListButtonTapped), for: .touchUpInside)
        mapView.allGroupButton.addTarget(self, action: #selector(allGroupButtonTapped), for: .touchUpInside)
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        mapView.groupCollectionView.dataSource = self
        mapView.groupCollectionView.delegate = self
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(90)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setMapSetting() {
        mapView.mapView.showsUserLocation = true
        mapView.mapView.delegate = self
        mapView.mapView.isRotateEnabled = false
        mapView.mapView.isPitchEnabled = false
    }
    
    private func setNavigationItem() {
        let locationButton = UIBarButtonItem(
            image: UIImage(systemName: "scope"),
            style: .plain,
            target: self,
            action: #selector(centerToUserLocation))
        navigationItem.rightBarButtonItem = locationButton
        
        navigationController?.navigationBar.tintColor = TDStyle.color.mainTheme
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = .white
        }
    }
    
    private func setLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    private func updateMapAnnotations() {
        DispatchQueue.main.async {
            self.addPinsToMap(todos: self.allTodoList)
        }
    }
}

extension MapViewController {
    @objc
    private func groupListButtonTapped() {
        self.navigationController?.pushViewController(GroupListViewController(), animated: true)
    }

    @objc // 전체 버튼
    private func allGroupButtonTapped(sender: UIButton) {
        allTodoList = CoreDataManager.shared.readAllTodos()

        todoDetailViewController = TodoDetailViewController(todos: allTodoList)
        todoDetailViewController?.delegate = self
        if let sheet = todoDetailViewController?.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(todoDetailViewController!, animated: true, completion: nil)

        selectedGroup = nil
        mapView.allGroupButton.alpha = 1
        mapView.groupCollectionView.reloadData()
    }

    @objc // 내 위치
    private func centerToUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionRadius,
                                            longitudinalMeters: regionRadius)
            mapView.mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: - MapView Pin
extension MapViewController {
    private func addPinsToMap(todos: [TodoType]) {
        self.pins = []
        for todo in todos {
            if let latitude = todo.placeAlarm?.latitude,
               let longitude = todo.placeAlarm?.longitude {
                let pin = createAnnotation(title: todo.title,
                                           latitude: latitude,
                                           longitude: longitude,
                                           pinColor: UIColor.blue) // 예시 색상
                
                mapView.mapView.addAnnotation(pin)
                pins.append(pin)
            }
        }
        
        mapView.mapView.showAnnotations(pins, animated: true)
    }
    
    private func createAnnotation(title: String,
                                  latitude: Double,
                                  longitude: Double,
                                  pinColor: UIColor?) -> ColoredAnnotation {
        let annotation = ColoredAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = title
        annotation.pinColor = pinColor ?? TDStyle.color.mainTheme
        
        return annotation
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { // 핀 클릭 시 확대
        guard let annotation = view.annotation else { return }

        let offset = -0.005
        let newCenterLatitude = annotation.coordinate.latitude + offset
        let newCenter = CLLocationCoordinate2D(latitude: newCenterLatitude,
                                               longitude: annotation.coordinate.longitude)

        let region = MKCoordinateRegion(center: newCenter,
                                        latitudinalMeters: regionRadius,
                                        longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)

        let data = allTodoList.filter { $0.title == annotation.title! }

        todoDetailViewController = TodoDetailViewController(todos: data)
        todoDetailViewController?.delegate = self
        if let sheet = todoDetailViewController?.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(todoDetailViewController!, animated: true, completion: nil)
    }

    private func openTodoListModal(name: String? = nil) {
        if let groupIndex = selectedGroup {
            let todos = CoreDataManager.shared.readAllTodos()
            allTodoList = todos.filter {
                $0.group?.title == groupList[groupIndex].title!
            }

            let todoDetailViewController = TodoDetailViewController(todos: allTodoList)
            todoDetailViewController.delegate = self
            if let sheet = todoDetailViewController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            present(todoDetailViewController, animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCollectionViewCell.identifier,
                                                            for: indexPath) as? GroupCollectionViewCell else
        { return UICollectionViewCell() }

        cell.configure(data: groupList[indexPath.row])
        cell.groupButton.tag = indexPath.row
        cell.buttonAction = buttonAction

        if selectedGroup != cell.groupButton.tag {
            cell.groupButton.alpha = 0.3
        } else {
            cell.groupButton.alpha = 1
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let buttonText = groupList[indexPath.row].title else { return CGSize() }
        let buttonSize = buttonText.size(withAttributes:
                                            [NSAttributedString.Key.font : TDStyle.font.body(style: .regular)])
        let buttonWidth = buttonSize.width
        let buttonHeight = buttonSize.height

        return CGSize(width: buttonWidth + 24, height: buttonHeight + 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - TodoDetailViewControllerDelegate

extension MapViewController: TodoDetailViewControllerDelegate {
    func didSelectLocation(latitude: Double, longitude: Double) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude,
                                                                       longitude: longitude),
                                        latitudinalMeters: regionRadius,
                                        longitudinalMeters: regionRadius)
        mapView.mapView.setRegion(region, animated: true)
    }
}

// Floating Button 설정 및 액션 정의
extension MapViewController {
    
    func setFloatingButton() {
        floatingButton = FloatingButton()
        view.addSubview(floatingButton)
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-30)
            make.width.height.equalTo(60)
        }
        
        floatingButton.floatingButtonTapped = { [weak self] in
            let addTodoVC = AddTodoViewController()
            addTodoVC.modalPresentationStyle = .fullScreen
            self?.present(addTodoVC, animated: true)
        }
    }
    
}
