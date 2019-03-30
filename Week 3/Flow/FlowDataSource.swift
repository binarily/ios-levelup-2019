//
//  FlowDataSource.swift
//  Flow
//
//  Created by Kamil Czerniak on 28/03/2019.
//  Copyright © 2019 Kamil Czerniak. All rights reserved.
//

import UIKit

class FlowDataSource : NSObject, UICollectionViewDataSource {
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FlowCell
        cell.textLabel.text = String(indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 100 : 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
