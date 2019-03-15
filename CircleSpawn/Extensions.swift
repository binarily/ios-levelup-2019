//
//  Extensions.swift
//  CircleSpawn
//
//  Created by Kamil Czerniak on 12/03/2019.
//  Copyright © 2019 Kamil Czerniak. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension CGFloat {
    static func random() -> CGFloat {
        return random(min: 0.0, max: 1.0)
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(max > min)
        return min + ((max - min) * CGFloat(arc4random()) / CGFloat(UInt32.max))
    }
}

extension UIColor {
    static func randomBrightColor() -> UIColor {
        return UIColor(hue: .random(),
                       saturation: .random(min: 0.5, max: 1.0),
                       brightness: .random(min: 0.7, max: 1.0),
                       alpha: 1.0)
    }
}

extension ViewController : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Don't recognize a double tap until a triple-tap fails.
        if (gestureRecognizer as? UITapGestureRecognizer)?.numberOfTapsRequired == 2 &&
            (otherGestureRecognizer as? UITapGestureRecognizer)?.numberOfTapsRequired == 3 {
            return true
        }
        return false
    }
}

class MemorizingUIView : UIView{
    var originalPoint: CGPoint = CGPoint(x:0,y:0)
}
