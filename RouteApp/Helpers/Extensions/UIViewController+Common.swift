//
//  UIViewController+Common.swift
//  RouteApp
//
//  Created by Mohit Kumar on 12/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizeStrings.CommonStrings.okButtonTitle, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
