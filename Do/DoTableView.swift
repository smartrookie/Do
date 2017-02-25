//
//  DoTableView.swift
//  Do
//
//  Created by rookie on 2017/2/17.
//  Copyright © 2017年 rookie. All rights reserved.
//

import UIKit

protocol DoTableViewDataSource: NSObjectProtocol {
    
    func tableView(_ tableView: DoTableView, numberOfRowsInSection section: Int) -> Int
    
    func tableView(_ tableView: DoTableView, cellForRowAt indexPath: IndexPath) -> DoTableViewCell
    
    func numberOfSections(in tableView: DoTableView) -> Int
    
    func tableView(_ tableView: DoTableView, heightForRowAt indexPath: IndexPath) -> CGFloat
}


class DoTableView: UIScrollView {
    
    weak var dataSource : DoTableViewDataSource? {
        didSet {
            performSelector(onMainThread: #selector(reloadData), with: nil, waitUntilDone: true)
        }
    }
    
    var cacheCells = NSMutableSet()
    var visibleCells : [NSInteger:DoTableViewCell] = [:]
    
    var cellHeights : [CGFloat] = []
    var cellYOffsets : [CGFloat] = []
    var _contentSize : CGSize = CGSize.zero
    
    var numberOfSections = 1
    var numberOfRowsInSection = 0
    
    
    func resizeContent() {
        cellHeights = []
        cellYOffsets = []
        
        var height : CGFloat = 0
        for i in 0 ..< numberOfRowsInSection {
            let cellHeight = dataSource?.tableView(self, heightForRowAt: IndexPath(index: i)) ?? 44
            cellYOffsets.append(height)
            height = height + cellHeight
            cellHeights.append(cellHeight)
        }
        height = max(height, frame.height)
        _contentSize = CGSize(width: frame.width, height: height)
        self.contentSize = _contentSize
    }
    
    public func reloadData() {
        visibleCells.removeAll()
        numberOfRowsInSection = dataSource?.tableView(self, numberOfRowsInSection: 0) ?? 0
        resizeContent()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        alwaysBounceVertical = true
    }
    
    func dequeueReusableCell(withIdentifier identifier: String) -> DoTableViewCell? {
        
        var cell : DoTableViewCell?
        for _cell in cacheCells {
            if (_cell as! DoTableViewCell).reuseIdentifier == identifier {
                cell = (_cell as! DoTableViewCell)
                cacheCells .remove(_cell)
                break
            }
        }
        
        return cell
    }
    
    func _cleanUnusedCells(_ displayRange: NSRange)  {
        for index in visibleCells.keys {
            if !NSLocationInRange(index, displayRange) {
                let cell = visibleCells[index]!
                cell.removeFromSuperview()
                cacheCells.add(cell)
                visibleCells.removeValue(forKey: index)
            }
        }
    }
    
    func displayRange() -> NSRange {
        
        var location = 0
        var length   = 0
        
        for i in 0 ..< numberOfRowsInSection {
            if  cellYOffsets[i]                  <= contentOffset.y &&
                cellYOffsets[i] + cellHeights[i] >  contentOffset.y {
                location = i
            }
            
            if cellYOffsets[i]                   <= contentOffset.y + frame.height &&
               cellYOffsets[i] + cellHeights[i]  >  contentOffset.y + frame.height{
                length = i - location + 1
            }
        }
        
        if length == 0 && numberOfRowsInSection > 0 {
            length = numberOfRowsInSection - location
        }
    
        return NSRange(location: location, length: length)
    }
    
    func _cellForRowAt(index: NSInteger) -> DoTableViewCell {
        var cell = visibleCells[index]
        if cell == nil {
            cell = dataSource?.tableView(self, cellForRowAt: IndexPath(row: index, section: 0))
        }
        return cell!
    }
    
    override func layoutSubviews() {
        
        self.contentSize = CGSize(width: _contentSize.width - contentInset.left - contentInset.right, height: _contentSize.height)
        
        let displayRange = self.displayRange()
        for i in displayRange.location ..< displayRange.location + displayRange.length {
            let cell = _cellForRowAt(index: i)
            addSubview(cell)
            cell.frame = CGRect(x: 0, y: cellYOffsets[i], width: frame.width, height: cellHeights[i])
            _cleanUnusedCells(displayRange)
            visibleCells[i] = cell
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}























































