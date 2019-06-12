//
//  DeliveryListViewController.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit
import MBProgressHUD

class DeliveryListViewController: UIViewController {
    var tableView: UITableView!
    var deliveryListViewModel: DeliveryListViewModelProtocol = DeliveryListControllerViewModel()
    let refreshControl = UIRefreshControl()
    var reachabilityManager: ReachabilityProtocol = ReachabilityManager.sharedInstance

    override func loadView() {
        super.loadView()
        setupUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizeStrings.DeliveryListScreen.deliveryListScreenTitle
        setupEventHandlers()
        deliveryListViewModel.fetchDeliveryList()
    }

    private func setupEventHandlers() {
        deliveryListViewModel.completionHandler = {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }

        deliveryListViewModel.errorHandler = { [weak self] errorMessage in
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: LocalizeStrings.ErrorMessage.errorTitle, message: errorMessage)
            }
        }

        deliveryListViewModel.loadMoreCompletionHandler = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.hideBottomLoader()
            }
        }

        deliveryListViewModel.loaderHandler = { [weak self] showLoader in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {
                    return
                }

                guard showLoader else {
                    MBProgressHUD.hide(for: weakSelf.view, animated: true)
                    return
                }

                MBProgressHUD.showAdded(to: weakSelf.view, animated: true)
            }
        }

        deliveryListViewModel.pullToRefreshCompletionHandler = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
            }
        }
    }

    func hideBottomLoader() {
        if let cell = tableView.cellForRow(at: IndexPath(row: deliveryListViewModel.numberOfRows() - 1, section: 0)) as? LoaderCell {
            cell.stopSpinner()
        }
    }

    func setupUI() {
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.register(DeliveryCell.self, forCellReuseIdentifier: String(describing: DeliveryCell.self))
        tableView.register(LoaderCell.self, forCellReuseIdentifier: String(describing: LoaderCell.self))

        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        addRefreshControl()
    }

    func addRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh(_:)), for: .valueChanged)
    }

    @objc
    func handlePullToRefresh(_ sender: Any) {
        deliveryListViewModel.handlePullToRefresh()
    }
}
