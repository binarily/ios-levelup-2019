//
//  FlowLayoutAttributes.swift
//  Flow
//
//  Created by Kamil Czerniak on 26/03/2019.
//  Copyright © 2019 Kamil Czerniak. All rights reserved.
//

import UIKit

class FlowLayoutAttributes : UICollectionViewLayoutAttributes{
    var awayFromCentre = CGFloat()
    
    override func copy() -> Any {
        let result = super.copy() as! FlowLayoutAttributes
        result.awayFromCentre = self.awayFromCentre
        return result
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        let comparedTo = object as! FlowLayoutAttributes
        return super.isEqual(object) && (comparedTo.awayFromCentre == self.awayFromCentre)
    }
}
