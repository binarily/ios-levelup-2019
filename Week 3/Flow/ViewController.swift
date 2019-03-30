//
//  ViewController.swift
//  Flow
//
//  Created by Kamil Czerniak on 26/03/2019.
//  Copyright © 2019 Kamil Czerniak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    let dataSource = FlowDataSource()
    let layout = FlowLayout()
    var collectionView: UICollectionView { get{return view as! UICollectionView}}
    var viewToScroll = IndexPath(row: -1, section: 0)
    var scrollNow = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        layout.itemSize = CGSize(width: 150, height: 150)
        view = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.register(FlowCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = dataSource
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layoutAttributes = layout.layoutAttributesForElements(in: scrollView.bounds)
        
        let centerOffset = scrollView.frame.size.width / 2
        let offsetWithCenter = scrollView.contentOffset.x + centerOffset
        
        let closestAttribute = layoutAttributes!
            .sorted { abs($0.center.x - offsetWithCenter) < abs($1.center.x - offsetWithCenter) }
            .first
        
        viewToScroll = closestAttribute!.indexPath
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollNow = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(viewToScroll.row != -1 && scrollNow){
            scrollNow = false
            collectionView.scrollToItem(at: viewToScroll, at: .centeredHorizontally, animated: true)
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}

