//
//  LocationCell.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit
import SDWebImage
class LocationCell: UITableViewCell {
    var destinationLabel: UILabel!
    var destinationImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        destinationImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 60, height: 60))
        destinationLabel = UILabel(frame: CGRect(x: destinationImageView.frame.width + destinationImageView.frame.origin.x + 10, y: destinationImageView.frame.origin.y, width: frame.size.width - destinationImageView.frame.width - 30, height: destinationImageView.frame.height))
        addSubview(destinationImageView)
        destinationLabel.numberOfLines = 2
        addSubview(destinationLabel)
        selectionStyle = .none
    }
    
    
    func configureUI(location: DestinationModel) {
        destinationLabel.text = String(format: "%@ at %@", location.description, location.location.address)
        destinationImageView.sd_setImage(with: URL(string: location.imageUrl), placeholderImage: nil)
    }
}
