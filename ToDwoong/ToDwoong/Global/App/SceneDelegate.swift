//
//  SceneDelegate.swift
//  ToDwoong
//
//  Created by yen on 2/23/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, 
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let launchScreenViewController = LaunchScreenViewController()
        window?.rootViewController = launchScreenViewController
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.firstAccessCheck()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

// MARK: - extension

extension SceneDelegate {
    private func firstAccessCheck() {
        if UserDefaults.standard.object(forKey: "first") is Bool {
            let rootViewController = UINavigationController(rootViewController: TabBarController())

            self.window?.rootViewController = rootViewController
        } else {
            createGestureGuide()
            
            let rootViewController = UINavigationController(rootViewController: OnboardingViewController())
            
            self.window?.rootViewController = rootViewController
        }
    }
    
    private func createGestureGuide() {
        let dataManager = CoreDataManager.shared
        
        dataManager.createTodo(title: "더블탭으로 완료해요 ✅", dueTime: Date(),
                               placeName: nil, group: nil, timeAlarm: nil, placeAlarm: nil)
        dataManager.createTodo(title: "스와이프로 편집해요 ✏️", dueTime: Date(),
                               placeName: nil, group: nil, timeAlarm: nil, placeAlarm: nil)
        dataManager.createTodo(title: "플로팅 버튼을 눌러서 투두를 추가해요 📘", dueTime: Date(),
                               placeName: nil, group: nil, timeAlarm: nil, placeAlarm: nil)
        dataManager.createTodo(title: "상단 지도 메뉴에서 저장된 투두를 확인할 수 있어요 🗺️", dueTime: Date(),
                               placeName: nil, group: nil, timeAlarm: nil, placeAlarm: nil)
        
        // FIXME: - 위치 탭 시 지도로 이동 구현 이후 수정
        
    }
}
