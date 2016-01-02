//
//  MainViewController.swift
//  HotSeats
//
//  Created by RPK on 12/21/15.
//  Copyright © 2015 Robert King. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var stadiumView: StadiumView?

    let DATA_FILE_NAME = "fenway_test"
    var flip: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /**
        * TODO: This should check if a stadium has already been selected,
        * otherwise prompt the user to select one.
        */
        let stadiumFilePath = NSBundle.mainBundle().pathForResource(DATA_FILE_NAME, ofType: "csv")
        
        // Offset the view's frame by 20 to avoid drawing in the status bar
        let stadiumFrame = CGRectMake(0.0, self.view.frame.origin.y + 20.0,
            self.view.frame.size.width, self.view.frame.size.height - 20.0)
        
        self.stadiumView = StadiumView(frame: stadiumFrame)
        
        // TODO: Put this code back here and outside the init for the stadiumView
        // This was just an issue when converting from Obj-c to Swift
        
        self.stadiumView!.stadium = StadiumCoordinateParser.parseStadium(stadiumFilePath!)
        self.stadiumView!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.stadiumView!.backgroundColor = UIColor.clearColor()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "stadiumTapped:")
        
        self.stadiumView!.addGestureRecognizer(tapGesture)
        self.view.addSubview(self.stadiumView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }

    func stadiumTapped(sender: UITapGestureRecognizer) {

        NSLog("Tapped the stadium")
        
        let tapLoc = sender.locationInView(self.stadiumView)
        NSLog("Sublayer count: \(self.stadiumView!.layer.sublayers!.count)")
        NSLog("Parent layer contains point: \(self.stadiumView!.layer.containsPoint(tapLoc))")
        
        let tappedLayer = self.stadiumView!.layer.hitTest(tapLoc)
        NSLog("Found layer via hitTest: \(tappedLayer != nil)")
    
        for (_, layer) in self.stadiumView!.layer.sublayers!.enumerate() {
            let hitLayer = layer.hitTest(tapLoc)
            
            if hitLayer == nil {
                continue
            }
            else if !(hitLayer is HSSectLayer) {
                continue
            }
            
            NSLog("Does hitTest layer == hitLayer? \(hitLayer == tappedLayer)")
            let hitFrame = hitLayer!.frame
            NSLog("Frame: \(hitFrame.origin.x), \(hitFrame.origin.y), \(hitFrame.size.width), \(hitFrame.size.height)")

            if !flip {
                // SELECT (Scale up)
                // Scale and translate the selected stadium section layer
                hitLayer!.anchorPoint = CGPointMake(0.5, 0.0)
                hitLayer!.transform = CATransform3DTranslate(hitLayer!.transform, -hitLayer!.frame.origin.x + ((self.stadiumView!.layer.bounds.size.width/2.0) - (hitLayer!.bounds.size.width / 2.0)), -hitLayer!.frame.origin.y, 0.0)
                hitLayer!.transform = CATransform3DScale(hitLayer!.transform, 5.0, 5.0, 5.0)
                NSLog("Frame: \(hitLayer!.frame.origin.x), \(hitLayer!.frame.origin.y), \(hitLayer!.frame.size.width), \(hitLayer!.frame.size.height)")
                
                hitLayer!.backgroundColor = UIColor.orangeColor().CGColor
                
                let detailView = SectionDetailView.fromNib((hitLayer as! HSSectLayer).section)
                detailView.frame = CGRectMake(0, self.view.bounds.size.height / 2.0,
                    self.view.bounds.size.width, self.view.bounds.size.height / 2.0)
                detailView.tag = 30
                self.view.addSubview(detailView)
            }
            else {
                // DESELECT
                hitLayer!.anchorPoint = CGPointMake(0.5, 0.5)
                hitLayer!.transform = CATransform3DIdentity
                hitLayer!.backgroundColor = UIColor.clearColor().CGColor
                
                self.view.viewWithTag(30)?.removeFromSuperview()
            }
            
            break
        }
        
        flip = !flip
    }
}
