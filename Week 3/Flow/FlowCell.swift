//
//  FlowCell.swift
//  Flow
//
//  Created by Kamil Czerniak on 26/03/2019.
//  Copyright © 2019 Kamil Czerniak. All rights reserved.
//

import UIKit

class FlowCell: UICollectionViewCell{
    let textLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(textLabel)
        textLabel.textColor = .white
        textLabel.textAlignment = .center
        textLabel.frame.size = frame.size
        textLabel.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let attributes = layoutAttributes as! FlowLayoutAttributes
        self.backgroundColor = UIColor(red:min(1, -2*attributes.awayFromCentre+2) , green: min(1, 2*attributes.awayFromCentre), blue: 0, alpha: 1)
        self.transform = CGAffineTransform(scaleX: 1.5-0.5*attributes.awayFromCentre, y: 1.5-0.5*attributes.awayFromCentre)
    }
}
