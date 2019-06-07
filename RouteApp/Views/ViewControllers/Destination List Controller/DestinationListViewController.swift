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
        title = LocalizeStrings.destinationListScreenTitle
        setupEventHandlers()
        destinationListViewModel.getDestinationList()
    }
    
    private func setupEventHandlers() {
        destinationListViewModel.completionHandler = {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
        destinationListViewModel.errorHandler = { [weak self] error in
            DispatchQueue.main.async { [weak self] in
                let errorMessage = error._code == Constants.internetErrorCode ? LocalizeStrings.internetErrorMessage : LocalizeStrings.genericErrorMessage
                self?.showAlert(title: LocalizeStrings.errorTitle, message: errorMessage)
            }
        }
        
        destinationListViewModel.loadMoreCompletionHandler = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.hideBottomLoader()
            }
        }
        
        destinationListViewModel.loaderHandler = { [weak self] showLoader in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                if showLoader {
                    MBProgressHUD.showAdded(to: weakSelf.view, animated: true)
                } else {
                    MBProgressHUD.hide(for: weakSelf.view, animated: true)
                }
            }
        }
        
        destinationListViewModel.pullToRefreshCompletionHandler = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    func hideBottomLoader() {
        if let cell = tableView.cellForRow(at: IndexPath(row: destinationListViewModel.numberOfRows() - 1, section: 0)) as? LoaderCell {
            cell.stopSpinner()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizeStrings.okButtonTitle, style: .default, handler: nil)
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
        refreshControl.addTarget(self, action:  #selector(handlePullToRefresh(_:)), for: .valueChanged)
    }
    
    @objc
    private func handlePullToRefresh(_ sender: Any) {
        destinationListViewModel.handlePullToRefresh()
    }
}
