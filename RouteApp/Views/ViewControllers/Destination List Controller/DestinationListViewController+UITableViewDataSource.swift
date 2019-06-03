//
//  DestinationListViewController+UITableViewDataSource.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/27/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit

extension DestinationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinationListViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row < destinationListViewModel.destinationList.count, let locationCell = tableView.dequeueReusableCell(withIdentifier: String(describing: LocationCell.self)) as? LocationCell {
            locationCell.configureUI(location: destinationListViewModel.getDestination(index: indexPath.row))
            cell = locationCell
        } else if let loaderCell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoaderCell.self)) as? LoaderCell {
            cell = loaderCell
        }
        return cell
    }
}
