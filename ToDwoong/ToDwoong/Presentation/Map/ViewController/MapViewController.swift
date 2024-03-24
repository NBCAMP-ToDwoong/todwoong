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

protocol TodoDetailViewControllerDelegate: AnyObject {
    func didSelectLocation(latitude: Double, longitude: Double)
}

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    private let regionRadius: CLLocationDistance = 1000 // 지도 확대/축소를 위한 범위 설정
    private lazy var allTodoList: [TodoType] = [] {
        didSet { addPinsToMap() }
    }
    private lazy var groupList: [Group] = []
    private lazy var pins: [ColoredAnnotation] = []
    private var selectedGroup: Int?
    
    // MARK: - UI Properties
    
    private var todoDetailViewController: TodoDetailViewController?
    private let mapView = MapView()
    private let locationManager = CLLocationManager()
    
    lazy var buttonAction: ((UIButton) -> Void) = { button in
        self.selectedGroup = button.tag
        self.mapView.allGroupButton.alpha = 0.3
        
        self.mapView.groupCollectionView.reloadData()
        self.openTodoListModal(name: button.titleLabel?.text!)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setNavigationItem()
        setUI()
        setAction()
        
        setMapSetting()
        setLocationManager()
    }
    
    private func fetchData() {
        allTodoList = CoreDataManager.shared.readAllTodos()
        groupList = CoreDataManager.shared.readGroups()
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
}

    // MARK: - Objc Method

extension MapViewController {
    @objc
    private func groupListButtonTapped() {
        self.navigationController?.pushViewController(GroupListViewController(), animated: true)
    }
    
    @objc
    private func allGroupButtonTapped(sender: UIButton) {
        openTodoListModal()
        selectedGroup = nil
        mapView.allGroupButton.alpha = 1
        mapView.groupCollectionView.reloadData()
    }
    
    @objc
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
    private func addPinsToMap() {
        
        // FIXME: 저장 데이터 완료되면 재작업 (현재 임시)
        // TODO: - 핀 컬러 그룹에 따라 변경되도록, 그룹이 없으면 메인테마 사용
        // TODO: - 위치정보가 없는 투두는 보여주지 않음
        
        for todo in allTodoList {
            if let latitude = todo.placeAlarm?.latitude,
               let longitude = todo.placeAlarm?.longitude {
                let pin = createAnnotation(title: todo.title,
                                           latitude: latitude,
                                           longitude: longitude,
                                           pinColor: TDStyle.color.mainTheme)
                
                mapView.mapView.addAnnotation(pin)
                pins.append(pin)
            } else {
                if todo.title == "학교"{
                    let pin = createAnnotation(title: todo.title,
                                               latitude: 37.5665,
                                               longitude: 126.9780,
                                               pinColor: TDStyle.color.mainDarkTheme)
                    
                    mapView.mapView.addAnnotation(pin)
                    pins.append(pin)
                } else if todo.title == "서울시청"{
                    let pin = createAnnotation(title: todo.title,
                                               latitude: 36.3504,
                                               longitude: 127.3845,
                                               pinColor: TDStyle.color.mainDarkTheme)
                    
                    mapView.mapView.addAnnotation(pin)
                    pins.append(pin)
                }
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
    // 핀 클릭 시 확대
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        let offset = -0.005
        let newCenterLatitude = annotation.coordinate.latitude + offset
        let newCenter = CLLocationCoordinate2D(latitude: newCenterLatitude,
                                               longitude: annotation.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: newCenter,
                                        latitudinalMeters: regionRadius,
                                        longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        
        // FIXME: 추가로직 완료 후 마무리 예정
        todoDetailViewController = TodoDetailViewController(todos: [])
        todoDetailViewController!.delegate = self
        if let sheet = todoDetailViewController?.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(todoDetailViewController!, animated: true, completion: nil)
    }
    
    func openTodoListModal(name: String? = nil) {
        // FIXME: 추가로직 완료 후 마무리 예정
        
        if let groupIndex = selectedGroup {
            allTodoList = CoreDataManager.shared.readAllTodos().filter {
                $0.group?.title == groupList[groupIndex].title
            }
        } else {
            allTodoList = CoreDataManager.shared.readAllTodos()
        }
//        if name == nil {
//            allTodoList = CoreDataManager.shared.readAllTodos()
//        } else {
//            let groupTitle = name!
//            print(groupTitle)
//            allTodoList = CoreDataManager.shared.readAllTodos().filter { $0.group?.title == groupTitle }
//        }
//        
        print(allTodoList)
        
        var data: [TodoDTO] = []
        for todo in allTodoList {
            data.append(TodoDTO(id: todo.id,
                                title: todo.title,
                                isCompleted: todo.isCompleted,
                                dueTime: todo.dueTime,
                                placeName: todo.placeName,
                                group: convertGroupTypeToGroup(groupType: todo.group)))
        }
                
        todoDetailViewController = TodoDetailViewController(todos: data)
        todoDetailViewController!.delegate = self
        if let sheet = todoDetailViewController?.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(todoDetailViewController!, animated: true, completion: nil)
    }
    
    func convertGroupTypeToGroup(groupType: GroupType?) -> Group? {
        guard let groupType = groupType else {
            return nil
        }
        
        let group = Group()
        group.id = groupType.id
        group.title = groupType.title
        group.color = groupType.color
        group.indexNumber = Int32(groupType.indexNumber ?? 0)
//        group.todo = groupType.todo
        
        return group
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let coloredAnnotation = annotation as? ColoredAnnotation else {
            return nil
        }

        let reuseId = "customPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
        } else {
            pinView?.annotation = annotation
        }
        
        if let customImage = UIImage(named: "AddTodoMapPin")?.withRenderingMode(.alwaysTemplate) {
            let resizedImage = resizeImage(image: customImage, targetSize: CGSize(width: 26, height: 26))
            let coloredAndResizedImage = resizedImage.withTintColor(
                coloredAnnotation.pinColor ?? TDStyle.color.mainTheme)
            pinView?.image = coloredAndResizedImage
            
            pinView?.layer.shadowColor = UIColor.black.cgColor
            pinView?.layer.shadowOpacity = 0.8
            pinView?.layer.shadowOffset = CGSize(width: 0, height: 1)
            pinView?.layer.shadowRadius = 2
        }

        return pinView
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }

}

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

extension MapViewController: TodoDetailViewControllerDelegate {
    func didSelectLocation(latitude: Double, longitude: Double) {
        navigationController?.dismiss(animated: true)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude,
                                                                       longitude: longitude),
                                        latitudinalMeters: regionRadius,
                                        longitudinalMeters: regionRadius)
        mapView.mapView.setRegion(region, animated: true)
    }
}
