//
//  DeliveryListViewController+Stub.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

@testable import RouteApp
import UIKit

extension DeliveryListViewController {
    static func stub(reachabilityManager: ReachabilityManagerMock = ReachabilityManagerMock(isReachable: true), viewModel: DeliveryListControllerViewModelMock) -> DeliveryListViewController {
        let viewController = DeliveryListViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        viewController.reachabilityManager = reachabilityManager
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        viewController.deliveryListViewModel = viewModel
        _ = viewController.view

        return viewController
    }
}
