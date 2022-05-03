//
//  HomeCoordinator.swift
//  currency-converter
//
//  Created by AGM Tazim on 3/26/22.
//

import UIKit

class HomeCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    public func start(window: UIWindow) {
        window.rootViewController = navigationController
    }
    
    public func showHomeScreen(window: UIWindow) {
        let repository = SearchRepository(apiClient: APIClient.shared)
        let usecase = SearchUsecase(repository: repository)
        let viewModel = SearchViewModel(usecase: usecase)
        let vc = SearchViewController(viewModel: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
        self.start(window: window)
    }
}
