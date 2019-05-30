//
//  DestinationListViewController+Stub.swift
//  RouteAppTests
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

@testable import RouteApp
import UIKit

extension DestinationListViewController {
    static func stub() -> DestinationListViewController {
        let viewController = DestinationListViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        _ = viewController.view

        return viewController
    }
}
