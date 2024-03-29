//
//  HSSectLayer.swift
//  HotSeats
//
//  Created by rking on 7/24/15.
//  Copyright (c) 2015 rking. All rights reserved.
//

import UIKit

class HSSectLayer: CAShapeLayer {

    var selectable = true
    var section: Section!
    
    override func containsPoint(thePoint: CGPoint) -> Bool {
    
        if !self.selectable {
            return false
        }
        
        let bezPath = UIBezierPath(CGPath: self.path!)
        let bezContain: Bool = bezPath.containsPoint(thePoint)
        let rectContain: Bool = CGRectContainsPoint(self.bounds, thePoint)
        if (bezContain || rectContain) {
            NSLog("Found one")
        }
        return CGRectContainsPoint(self.bounds, thePoint) && bezContain
    }
}
