//
//  AppCoordinator.swift
//  GeoTestTask
//
//  Created by Sergiy Sobol on 26.11.2021.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    func start()
}

class AppCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        
        let userListCoordinator = UserListCoordinator(navigationController: navigationController)
        
        childCoordinators.append(userListCoordinator)
        userListCoordinator.start()
        
        navigationController.navigationBar.isTranslucent = false
        self.window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}
