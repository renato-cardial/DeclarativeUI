//
//  ListCell.swift
//  
//
//  Created by Renato Cardial on 10/3/23.
//

import UIKit

class ListCell: UITableViewCell {
    
    static let identifier = "ListCell"
    
    func setContentView(_ element: ElementView) {
        ElementConstraint(
            view: contentView,
            subview: element.elementView,
            forceAddSubview: true
        ).fill()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.subviews.forEach { subview in subview.removeFromSuperview() }
        contentView.layoutIfNeeded()
    }
}
