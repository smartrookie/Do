//
//  DoLoopScroller.swift
//  Do
//
//  Created by rookie on 2017/2/28.
//  Copyright © 2017年 rookie. All rights reserved.
//

import UIKit

class DoLoopScroller: UIScrollView {
    
    var visibleViews : [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentSize = CGSize(width: 3000, height: frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        recenterIfNecessary()
        
        var visibleBounds = self.bounds
        visibleBounds.origin.x = contentOffset.x
        
        tileLabelsFromMinX(visibleBounds.minX, toMaxX: visibleBounds.maxX)
    }
    
    
    func recenterIfNecessary() {
        
        let currentOffset = self.contentOffset
        let contentWidth = self.contentSize.width
        
        let centerOffsetX = (contentWidth - frame.width) / 2.0
        let distanceFromCenter = fabs(currentOffset.x - centerOffsetX)
        
        if distanceFromCenter > (contentWidth / 4.0) {
            contentOffset = CGPoint(x: centerOffsetX, y: currentOffset.y)
            
            for view in visibleViews {
                var center = view.center
                center.x = center.x + (centerOffsetX - currentOffset.x)
                view.center = center
            }
        }
    }
    
    func insertLabel() -> UILabel {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 80))
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.red.cgColor
        label.text = "1"
        
        addSubview(label)
        return label
    }
    
    func placeNewLabelOnRight(rightEdge: CGFloat) -> CGFloat {
        let label = insertLabel()
        visibleViews.append(label)
        
        var frame = label.frame
        frame.origin.x = rightEdge
        frame.origin.y = 0
        
        label.frame = frame
        return frame.maxX
    }
    
    func placeNewLabelOnLeft(leftEdge: CGFloat) -> CGFloat {
        let label = insertLabel()
        visibleViews.insert(label, at: 0)
        
        var frame = label.frame
        frame.origin.x = leftEdge - frame.width
        frame.origin.y = 0
        
        label.frame = frame
        return frame.minX
    }
    
    func tileLabelsFromMinX(_ minimunVisibleX: CGFloat , toMaxX maximumVisibleX: CGFloat) {
        if visibleViews.count == 0 {
            _ = placeNewLabelOnRight(rightEdge: minimunVisibleX)
            return
        }
        
        // add labels that are missing on right side
        var lastLabel = visibleViews.last
        var rightEdge = lastLabel!.frame.maxX
        while rightEdge < maximumVisibleX {
            rightEdge = placeNewLabelOnRight(rightEdge: rightEdge)
        }
        
        // add labels that are missing on left side
        var firstLabel = visibleViews.first
        var leftEdge = firstLabel!.frame.minX
        while leftEdge > minimunVisibleX {
            leftEdge = placeNewLabelOnLeft(leftEdge: leftEdge)
        }
        
        // remove labels that have fallen off right edge
        lastLabel = visibleViews.last
        while lastLabel!.frame.origin.x > maximumVisibleX {
            lastLabel!.removeFromSuperview()
            visibleViews.removeLast()
            lastLabel = visibleViews.last
        }
        
        // remove labels that have fallen off left edge
        firstLabel = visibleViews.first
        while firstLabel!.frame.maxX < minimunVisibleX {
            firstLabel!.removeFromSuperview()
            visibleViews.removeFirst()
            firstLabel = visibleViews.first
        }
    }
    
    

}


















