//
//  FlowLayout.swift
//  Flow
//
//  Created by Kamil Czerniak on 26/03/2019.
//  Copyright © 2019 Kamil Czerniak. All rights reserved.
//

import UIKit

class FlowLayout : UICollectionViewFlowLayout{
    var itemAttributes = Dictionary<IndexPath, FlowLayoutAttributes>()
    var offsetChange = CGFloat(0.0)
    
    override var collectionViewContentSize: CGSize{
        get{
            return CGSize(width: (itemSize.width * 1.5) * 100 + (collectionView!.bounds.width - itemSize.width), height: collectionView!.bounds.height)
        }
    }
    
    override open func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        collectionView.backgroundColor = .white
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        for item in 0..<itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = FlowLayoutAttributes(forCellWith: indexPath)
            attributes.frame.size = itemSize
            attributes.frame.origin.y = (collectionView.bounds.height - itemSize.height) / 2
            attributes.frame.origin.x = CGFloat(indexPath.item) * (itemSize.width * 1.5) + (collectionView.bounds.width - itemSize.width) / 2
            itemAttributes[indexPath] = attributes
        }
        scrollDirection = .horizontal
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let center = collectionView!.bounds.midX
        let midSize = collectionView!.frame.size.width / 2
        let result = itemAttributes
            .map { $0.value }
            .filter { $0.frame.intersects(rect) }
        for i in result{
            i.awayFromCentre = CGFloat(min(abs(i.center.x - center), abs(center)))/(midSize)
        }
        return result
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = itemAttributes[indexPath] else { fatalError("No attributes cached") }
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        offsetChange = newBounds.size.width - collectionView!.bounds.size.width
        return true
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        collectionView?.contentOffset.x += offsetChange / 2
    }
    
    
}
