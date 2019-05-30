//
//  DestinationListViewController+UITableViewDelegate.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/27/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit

extension DestinationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapVC = MapViewController()
        mapVC.viewModel = MapControllerViewModel()
        mapVC.viewModel.selectedLocation = destinationListViewModel.getDestination(index: indexPath.row)
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == destinationListViewModel.offset + destinationListViewModel.limit - 1 { // call api for next page before 1 rows to visible
            destinationListViewModel.makeNextPageCall()
        }
    }
}
