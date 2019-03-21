//
//  ViewController.swift
//  CircleSpawn
//
//  Created by Kamil Czerniak on 12/03/2019.
//  Copyright © 2019 Kamil Czerniak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Double tap: add a circle
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(addCircle(_:)))
        tap2.numberOfTapsRequired = 2
        tap2.delegate = self
        view.addGestureRecognizer(tap2)
    }

    @objc func addCircle(_ tap: UITapGestureRecognizer){
        let size: CGFloat = 100
        let spawnedView = MemorizingUIView(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        spawnedView.center = tap.location(in: view)
        spawnedView.backgroundColor = .randomBrightColor()
        spawnedView.layer.cornerRadius = size * 0.5
        spawnedView.alpha = 0
        spawnedView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        //Triple tap: remove a circle
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(ViewController.removeCircle(_:)))
        tap3.numberOfTapsRequired = 3
        spawnedView.addGestureRecognizer(tap3)
        
        //Long press: move a circle
        let longPress = UILongPressGestureRecognizer(target: self, action:
            #selector(ViewController.moveCircle(_:)))
        spawnedView.addGestureRecognizer(longPress)
        
        view.addSubview(spawnedView)
        UIView.animate(withDuration: 0.1, animations: {
            spawnedView.alpha = 1
            spawnedView.transform = .identity
        })
    }
    
    @objc func removeCircle(_ tap: UITapGestureRecognizer){
        let currentView = tap.view!
        UIView.animate(withDuration: 0.1, animations: {
            currentView.alpha = 0
            currentView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: { completed in
            currentView.removeFromSuperview()
        })
    }
    
    @objc func moveCircle(_ tap: UITapGestureRecognizer){
        let currentView = tap.view! as! MemorizingUIView
        if tap.state == .began{
            currentView.originalPoint = tap.location(in: currentView)
            //Raise the circle
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut], animations: {
                currentView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                currentView.alpha = 0.8
            })
        } else if tap.state == .changed{
            //TODO: correct offset - from frame to right place on finger
            let offsetX = tap.location(in: currentView).x - currentView.originalPoint.x
            let offsetY = tap.location(in: currentView).y  - currentView.originalPoint.y
            currentView.frame = currentView.frame.offsetBy(dx: offsetX, dy: offsetY)
        } else if tap.state == .ended || tap.state == .cancelled{
            //Lower the circle
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut],  animations: {
                currentView.transform = .identity
                currentView.alpha = 1
            })
        }
    }
}

