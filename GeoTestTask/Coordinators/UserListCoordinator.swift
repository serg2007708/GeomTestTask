//
//  UserListCoordinator.swift
//  GeoTestTask
//
//  Created by Sergiy Sobol on 26.11.2021.
//

import UIKit

final class UserListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = UsersListViewModel()
        viewModel.coordinator = self
        let userListViewController = HomeViewController(viewModel: viewModel)
        navigationController.setViewControllers([userListViewController], animated: false)
    }
    
    func onSelect(user: User) {
        let userDetailsCoordinator = UserDetailsCoordinator(user: user, navigationController: navigationController)
        childCoordinators.append(userDetailsCoordinator)
        userDetailsCoordinator.start()
    }
}
