//
//  DeliveryListViewController+UITableViewDataSource.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/27/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit

extension DeliveryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryListViewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let deliveryCell = tableView.dequeueReusableCell(withIdentifier: String(describing: DeliveryCell.self)) as? DeliveryCell {
            deliveryCell.configureUI(deliveryModel: deliveryListViewModel, indexPath: indexPath)
            cell = deliveryCell
        }
        return cell
    }
}
