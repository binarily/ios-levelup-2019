//
//  InfiniteScrollView.swift
//  StreetView
//
//  Created by Kamil Czerniak on 21/03/2019.
//  Copyright © 2019 Kamil Czerniak. All rights reserved.
//

import UIKit

class InfiniteScrollView: UIScrollView {
    
    private let buildingContainerView = UIView()
    
    private var visibleBuildings: [BuildingView] = []
    
    private let moon = UIView()
    private var moonPosition = CGPoint()
        
    init() {
        super.init(frame: .zero)
        addSubview(buildingContainerView)
    }
    
    override var frame: CGRect {
        didSet {
            setup(size: bounds.size)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(size: CGSize) {
        contentSize = CGSize(width: size.width * 3, height: BuildingView.maxBuildingHeight)
        buildingContainerView.frame = CGRect(origin: .zero, size: contentSize)
        indicatorStyle = .white
        backgroundColor = UIColor(red: 0, green: 0, blue: CGFloat(139.0/255.0), alpha: 1)
        
        visibleBuildings.forEach { $0.removeFromSuperview() }
        visibleBuildings.removeAll()
        contentOffset.x = (contentSize.width - bounds.width) / 2.0
        
        createMoon(size: size)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        recenterIfNecessary()
        let visibleBounds = convert(bounds, to: buildingContainerView)
        tileBuildings(from: visibleBounds.minX, to: visibleBounds.maxX)
        updateMoonPosition()
    }
    
    private func getBuilding() -> BuildingView {
        return BuildingView.randomBuilding()
    }
    
    private func placeNewBuldingOnTheRight(edge: CGFloat) -> BuildingView {
        let building = getBuilding()
        building.frame.origin.x = edge
        building.frame.origin.y = buildingContainerView.bounds.maxY - building.frame.height
        visibleBuildings.append(building)
        buildingContainerView.addSubview(building)
        return building
    }
    
    private func placeNewBuldingOnTheLeft(edge: CGFloat) -> BuildingView {
        let building = getBuilding()
        building.frame.origin.x = edge - building.frame.width
        building.frame.origin.y = buildingContainerView.bounds.maxY - building.frame.height
        visibleBuildings.insert(building, at: 0)
        buildingContainerView.addSubview(building)
        return building
    }
    
    private func recenterIfNecessary() {
        let currentOffset = contentOffset
        let contentWidth = contentSize.width
        let centerOffsetX = (contentWidth - bounds.width) / 2.0
        let distanceFromCenter = abs(currentOffset.x - centerOffsetX)
        
        if distanceFromCenter >= bounds.width {
            let moveBy = floor((currentOffset.x - centerOffsetX) / bounds.width) * bounds.width
            contentOffset.x -= moveBy
            for building in visibleBuildings {
                var center = buildingContainerView.convert(building.center, to: self)
                center.x -= moveBy
                building.center = convert(center, to: buildingContainerView)
            }
        }
    }
    
    private func tileBuildings(from minX: CGFloat, to maxX: CGFloat) {
        if visibleBuildings.count == 0 {
            _ = placeNewBuldingOnTheRight(edge: minX);
            tileBuildings(from: minX, to: maxX)
        }
        
        var lastVisibleBuilding = visibleBuildings.last!
        while lastVisibleBuilding.frame.maxX < maxX {
            lastVisibleBuilding = placeNewBuldingOnTheRight(edge: lastVisibleBuilding.frame.maxX)
        }
        
        var firstVisibleBuilding = visibleBuildings.first!
        while firstVisibleBuilding.frame.minX > minX {
            firstVisibleBuilding = placeNewBuldingOnTheLeft(edge: firstVisibleBuilding.frame.minX)
        }
        
        var indicesToRemove: [Int] = []
        for (index, building) in visibleBuildings.enumerated() {
            if building.frame.maxX <= minX || building.frame.minX >= maxX {
                indicesToRemove.append(index)
                building.removeFromSuperview()
            }
        }
        for index in indicesToRemove.reversed() {
            visibleBuildings.remove(at: index)
        }
    }
    
    func createMoon(size: CGSize){
        let moonSize: CGFloat = 100
        moonPosition = CGPoint(x: bounds.width - 70, y: 70)
        moon.frame = CGRect(origin: .zero, size: CGSize(width: moonSize, height: moonSize))
        moon.backgroundColor = .white
        moon.layer.cornerRadius = moonSize * 0.5
        moon.alpha = 1
        
        let longPress = UILongPressGestureRecognizer(target: self, action:
            #selector(moveMoon(_:)))
        moon.addGestureRecognizer(longPress)
        
        buildingContainerView.addSubview(moon)
        updateMoonPosition()
    }
    
    @objc func moveMoon(_ tap: UITapGestureRecognizer){
        let currentView = tap.view!
        
        switch tap.state {
        case .began:
            moonPosition = tap.location(in: currentView)
            
            buildingContainerView.bringSubviewToFront(currentView)
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut], animations: {
                currentView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                currentView.alpha = 0.8
            })
            break
        case .changed:
            let offsetX = tap.location(in: currentView).x - moonPosition.x
            let offsetY = tap.location(in: currentView).y - moonPosition.y
            currentView.frame = currentView.frame.offsetBy(dx: offsetX, dy: offsetY)
            break
        default:
            buildingContainerView.sendSubviewToBack(currentView)
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut],  animations: {
                currentView.transform = .identity
                currentView.alpha = 1
            })
            
            moonPosition = moon.center
            moonPosition.x = moonPosition.x - bounds.minX
            moonPosition.y = moonPosition.y - 0.8*bounds.minY
            break
        }
    }
    
    private func updateMoonPosition() {
        moon.center = CGPoint(x: bounds.minX + moonPosition.x, y: moonPosition.y + 0.8 * bounds.minY)
    }
}
