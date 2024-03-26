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
        // FIXME: #120 스쿼시 이후 구현
    }
}
