//
//  DeliveryCell.swift
//  RouteApp
//
//  Created by Mohit Kumar on 5/26/19.
//  Copyright © 2019 Mohit Kumar. All rights reserved.
//

import UIKit
import SDWebImage
class DeliveryCell: UITableViewCell {
    var deliveryLabel: UILabel!
    var deliveryImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        deliveryImageView = UIImageView(frame: .zero)
        deliveryImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deliveryImageView)
        
        deliveryLabel = UILabel(frame: .zero)
        deliveryLabel.numberOfLines = 0
        selectionStyle = .none
        deliveryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deliveryLabel)
        
        addConstraints()
    }
    
    func addConstraints() {
        let views: [String: Any] = [
            "deliveryImageView": deliveryImageView,
            "deliveryLabel": deliveryLabel,
            "superview": contentView]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        let horizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[deliveryImageView(80)]-10-[deliveryLabel]-10-|",
            metrics: nil,
            views: views)
        allConstraints += horizontalConstraint
        
        let imageVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(>=10)-[deliveryImageView(80)]-(>=10)-|",
            metrics: nil,
            views: views)
        allConstraints += imageVerticalConstraint
        
        let labelVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[deliveryLabel]-10-|",
            metrics: nil,
            views: views)
        allConstraints += labelVerticalConstraint
        
        deliveryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addConstraints(allConstraints)
    }
    
    
    func configureUI(deliveryModel: DeliveryListViewModelProtocol, indexPath: IndexPath) {
        deliveryLabel.text = deliveryModel.getDeliveryText(index: indexPath.row)
        deliveryImageView.sd_setImage(with: deliveryModel.getImageUrl(index: indexPath.row), placeholderImage: nil)
    }
}
