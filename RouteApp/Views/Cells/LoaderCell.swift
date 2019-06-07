//
//  LoaderCell.swift
//  RouteApp
//
//  Created by Mohit Kumar on 02/06/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit

class LoaderCell: UITableViewCell {
    var spinner: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        spinner = UIActivityIndicatorView(style: .gray)
        spinner.hidesWhenStopped = true
        contentView.addSubview(spinner)
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        spinner.center = contentView.center
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
    }
}
