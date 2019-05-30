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

    var destinationListViewModel:DestinationListViewModel = DestinationListViewModel()

    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        destinationListViewModel.getDestinationList()
        
        destinationListViewModel.completionHandler = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        destinationListViewModel.errorHandler = { [weak self] error in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Error", message: "Something went wrong, Please try again!", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                self?.present(alertController, animated: true)
            }
        }

    }
    
    func setupUI() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        view.addSubview(tableView)
        
        tableView.register(LocationCell.self, forCellReuseIdentifier: String(describing: LocationCell.self))
    }
    
}
