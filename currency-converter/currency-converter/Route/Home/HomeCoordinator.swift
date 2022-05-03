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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(window: UIWindow) {
        let repository = CurrencyRepository(apiClient: APIClient.shared)
        let usecase = CurrencyUsecase(repository: repository)
        let viewModel = MyBalanceViewModel(usecase: usecase)
        let vc = MyBalanceViewController(viewModel: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
}
