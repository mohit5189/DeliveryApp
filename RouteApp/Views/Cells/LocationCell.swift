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
        
        destinationImageView = UIImageView(frame: .zero)
        destinationImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(destinationImageView)
        
        destinationLabel = UILabel(frame: .zero)
        destinationLabel.numberOfLines = 0
        selectionStyle = .none
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(destinationLabel)
        
        addConstraints()
    }
    
    func addConstraints() {
        let views: [String: Any] = [
            "destinationImageView": destinationImageView,
            "destinationLabel": destinationLabel,
            "superview": contentView]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        let horizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[destinationImageView(80)]-10-[destinationLabel]-10-|",
            metrics: nil,
            views: views)
        allConstraints += horizontalConstraint
        
        let imageVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(>=10)-[destinationImageView(80)]-(>=10)-|",
            metrics: nil,
            views: views)
        allConstraints += imageVerticalConstraint
        
        let labelVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[destinationLabel]-10-|",
            metrics: nil,
            views: views)
        allConstraints += labelVerticalConstraint
        
        destinationImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addConstraints(allConstraints)
    }
    
    
    func configureUI(location: DestinationModel) {
        destinationLabel.text = String(format: "%@ at %@", location.description, location.location.address)
        destinationImageView.sd_setImage(with: URL(string: location.imageUrl), placeholderImage: nil)
    }
}
