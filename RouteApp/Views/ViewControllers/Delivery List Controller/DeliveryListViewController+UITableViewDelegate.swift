//
//  DeliveryListViewController+UITableViewDelegate.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/27/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit

extension DeliveryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapViewModel = MapControllerViewModel(selectedDelivery: deliveryListViewModel.getDelivery(index: indexPath.row))
        let mapVC = MapViewController(viewModel: mapViewModel)
        navigationController?.pushViewController(mapVC, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == deliveryListViewModel.numberOfRows() - 1 { // call api for next page before 1 rows to visible
            deliveryListViewModel.makeNextPageCall()
        }
    }
}
