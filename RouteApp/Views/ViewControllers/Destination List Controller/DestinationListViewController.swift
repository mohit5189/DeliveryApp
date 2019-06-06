//
//  DestinationListViewController.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit
import MBProgressHUD

class DestinationListViewController: UIViewController {
    var tableView: UITableView!
    var destinationListViewModel:DestinationListControllerViewModel = DestinationListControllerViewModel()
    let refreshControl = UIRefreshControl()
    var reachabilityManager: ReachabilityAdapter = ReachabilityManager.sharedInstance
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if reachabilityManager.isReachableToInternet() || DBManager.sharedInstance.cacheAvailable() {
            destinationListViewModel.getDestinationList()
        } else {
            showAlert(title: StringConstants.errorTitle, message: StringConstants.internetErrorMessage)
        }
        
        title = StringConstants.destinationListScreenTitle
        destinationListViewModel.completionHandler = {
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
        
        destinationListViewModel.errorHandler = { [weak self] error in
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
                self?.showAlert(title: StringConstants.errorTitle, message: StringConstants.errorMessage)
            }
        }

    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: StringConstants.okButtonTitle, style: .default) { action in
            self.refreshControl.endRefreshing()
            
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func setupUI() {
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.register(LocationCell.self, forCellReuseIdentifier: String(describing: LocationCell.self))
        tableView.register(LoaderCell.self, forCellReuseIdentifier: String(describing: LoaderCell.self))

        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true

        addRefreshControl()
    }
    
    func addRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action:  #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc
    private func refreshData(_ sender: Any) {
        if ReachabilityManager.sharedInstance.isReachableToInternet() {
            destinationListViewModel.handlePullToRefresh()
        } else {
            showAlert(title: StringConstants.errorTitle, message: StringConstants.internetErrorMessage)
        }
    }
}
