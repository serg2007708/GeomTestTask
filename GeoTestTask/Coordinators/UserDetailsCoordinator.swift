//
//  UserDetailsCoordinator.swift
//  GeoTestTask
//
//  Created by Sergiy Sobol on 26.11.2021.
//
import UIKit

final class UserDetailsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private let user: User
    
    init(user: User,
        navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.user = user
    }
    
    func start() {
        let viewModel = UserDetailsViewModel(with: user)
        let detailedUserInfoViewController = DetailedUserInfoViewController(viewModel: viewModel)
        navigationController.pushViewController(detailedUserInfoViewController, animated: true)
    }
}
