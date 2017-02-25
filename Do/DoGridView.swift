//
//  DoGridView.swift
//  Do
//
//  Created by rookie on 2017/2/21.
//  Copyright © 2017年 rookie. All rights reserved.
//

import UIKit


protocol DoGridViewDelegate: UIScrollViewDelegate {
    
    //func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    
    //func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?
    
    func gridView(_ gridView: DoGridView, didSelectRowAt indexPath: IndexPath)
    
    //func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
}

protocol DoGridViewDataSource: NSObjectProtocol {
    
    func numberOfRows(in gridView: DoGridView) -> Int
    
    func numberOfColumns(in gridView: DoGridView) -> Int
    
    func gridView(_ gridView: DoGridView, cellForGridAt row: NSInteger, column: NSInteger) -> DoGridViewCell
    
    func gridView(_ gridView: DoGridView, heightForRowAt row: NSInteger) -> CGFloat
    
    func gridView(_ gridView: DoGridView, widthForColumnAt column: NSInteger) -> CGFloat
}

class DoGridView: UIScrollView {

    weak var dataSource : DoGridViewDataSource? {
        didSet {
            self.performSelector(onMainThread: #selector(reloadData), with: nil, waitUntilDone: true)
        }
    }
    
    weak var doDelegate : DoGridViewDelegate?
    
    
    var allowsMultipleSelection : Bool = false
    
    private var _indexPathForSelected : IndexPath? {
        didSet {
            layoutSubviews()
        }
    }
    lazy var indexPathForSelected : IndexPath? = {
        return self._indexPathForSelected
    }()
    
    var cacheCells = NSMutableSet()
    
    // row column
    var visibleCells : [IndexPath:DoGridViewCell] = [:]
    var _cellXOffsets : [CGFloat] = []
    var _cellYOffsets : [CGFloat] = []
    
    var _cellWidths  : [CGFloat] = []
    var _cellHeights : [CGFloat] = []
    var _contentSize : CGSize = CGSize.zero
    
    var numberOfRows = 1
    var numberOfColumns  = 1
    
    
    var _borderWidth : CGFloat = 10 // Default
    var borderColor : UIColor = UIColor.do_separatorColor()
    var borderSelectedColor : UIColor = UIColor.do_destructiveAccentColor()
    
    func resizeContent() {
        
        var width : CGFloat = _borderWidth
        var height : CGFloat = _borderWidth
        
        _cellWidths.removeAll()
        _cellHeights.removeAll()
        _cellXOffsets.removeAll()
        _cellYOffsets.removeAll()
        
        for column in 0 ..< numberOfColumns {
            _cellXOffsets.append(width)
            let cellWidth = (dataSource?.gridView(self, widthForColumnAt: column) ?? 50)
            width = width + cellWidth + _borderWidth
            _cellWidths.append(cellWidth)
        }
        
        for row in 0 ..< numberOfRows {
            _cellYOffsets.append(height)
            let cellHeight = (dataSource?.gridView(self, heightForRowAt: row) ?? 20)
            height = height + cellHeight + _borderWidth
            _cellHeights.append(cellHeight)
        }
    
        height = max(height, frame.height)
        width  = max(width, frame.width)
        _contentSize = CGSize(width: width, height: height)
        self.contentSize = _contentSize
    }
    
    public func reloadData() {
        visibleCells.removeAll()
        numberOfRows = dataSource?.numberOfRows(in: self) ?? 0
        numberOfColumns = dataSource?.numberOfColumns(in: self) ?? 0
        resizeContent()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        alwaysBounceVertical = true
        alwaysBounceHorizontal = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(_tapSelectCellAction(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    func _tapSelectCellAction(gesture:UITapGestureRecognizer) {
        let tapPoint = gesture.location(in: self)
        
        for (index,cell) in visibleCells {
            var cellRect = cell.frame
            if _borderWidth > 1 {
                cellRect = cellRect.insetBy(dx: -_borderWidth/2, dy: -_borderWidth/2)
            }
            if cellRect.contains(tapPoint) {
                doDelegate?.gridView(self, didSelectRowAt: index)
                _indexPathForSelected = index
                break
            }
        }
    }
    
    func dequeueReusableCell(withIdentifier identifier: String) -> DoGridViewCell? {
        
        var cell : DoGridViewCell?
        for _cell in cacheCells {
            if (_cell as! DoGridViewCell).reuseIdentifier == identifier {
                cell = (_cell as! DoGridViewCell)
                cacheCells.remove(_cell)
                break
            }
        }
        
        return cell
    }
    
    func _cleanUnusedCells(_ displayRangeX: NSRange, _ displayRangeY: NSRange)  {
        for index in visibleCells.keys {
            if !NSLocationInRange(index.section, displayRangeX) || !NSLocationInRange(index.row, displayRangeY) {
                let cell = visibleCells[index]!
                cell.removeFromSuperview()
                cacheCells.add(cell)
                visibleCells.removeValue(forKey: index)
            }
        }
    }
    
    func displayRangeX() -> NSRange {
        
        var location = 0
        var length   = 0
        
        for i in 0 ..< numberOfColumns {
            if  _cellXOffsets[i] - _borderWidth                  <= contentOffset.x &&
                _cellXOffsets[i] + _cellWidths[i] + _borderWidth  >  contentOffset.x {
                location = i
            }
            
            if  _cellXOffsets[i] - _borderWidth                  <= contentOffset.x + frame.width &&
                _cellXOffsets[i] + _cellWidths[i] + _borderWidth  >  contentOffset.x  + frame.width{
                length = i - location + 1
            }
        }
        if length == 0 && numberOfColumns > 0 {
            length = numberOfColumns - location
        }
        
        return NSRange(location: location, length: length)
    }
    
    func displayRangeY() -> NSRange {
        
        var location = 0
        var length   = 0
        
        for i in 0 ..< numberOfRows {
            if  _cellYOffsets[i] - _borderWidth                 <=  contentOffset.y &&
                _cellYOffsets[i] + _cellHeights[i] + _borderWidth >  contentOffset.y {
                location = i
            }
            
            if  _cellYOffsets[i] - _borderWidth                  <= contentOffset.y + frame.height &&
                _cellYOffsets[i] + _cellHeights[i] + _borderWidth  > contentOffset.y  + frame.height{
                length = i - location + 1
            }
        }
        
        if length == 0 && numberOfRows > 0 {
            length = numberOfRows - location
        }
        
        return NSRange(location: location, length: length)
    }
    
    func _cellForRowAt(_ row: NSInteger, _ column: NSInteger) -> DoGridViewCell {
        let indexPath = IndexPath(row: row, section: column)
        var cell = visibleCells[indexPath]
        if cell == nil {
            cell = dataSource?.gridView(self, cellForGridAt: row, column: column)
        }
        return cell!
    }
    
    override func layoutSubviews() {
        
        self.contentSize = CGSize(width: _contentSize.width - contentInset.left - contentInset.right, height: _contentSize.height)
        
        let displayRangeX = self.displayRangeX()
        let displayRangeY = self.displayRangeY()
        
        for row in displayRangeY.location ..< displayRangeY.location + displayRangeY.length {
            for column in displayRangeX.location ..< displayRangeX.location + displayRangeX.length {
                let cell = _cellForRowAt( row, column)
                
                cell.frame = CGRect(x: _cellXOffsets[column], y: _cellYOffsets[row], width: _cellWidths[column], height: _cellHeights[row])
                addSubview(cell)
                cell._borderWidth = _borderWidth
                
                let isFirstCell : Bool = (row == 0 && column == 0)
                
                if row == 0 {
                    cell.corner_0.isHidden = !isFirstCell
                    cell.topBorder.isHidden = false
                    cell.corner_3.isHidden = false
                } else {
                    cell.corner_0.isHidden = true
                    cell.topBorder.isHidden = true
                    cell.corner_3.isHidden = true
                }
                
                if column == 0 {
                    cell.corner_0.isHidden = !isFirstCell
                    cell.leftBorder.isHidden = false
                    cell.corner_1.isHidden = false
                } else {
                    cell.corner_0.isHidden = true
                    cell.leftBorder.isHidden = true
                    cell.corner_1.isHidden = true
                }
                
                let indexPath = IndexPath(row: row, section: column)
                
                if !allowsMultipleSelection {
                    if let _ = _indexPathForSelected {
                        
                        
                        // corner_0
                        let index_corner0 = IndexPath(row: max(_indexPathForSelected!.row - 1, 0), section: max(_indexPathForSelected!.section - 1, 0))
                        let index_left = IndexPath(row: _indexPathForSelected!.row , section: max(_indexPathForSelected!.section - 1, 0))
                        let index_top = IndexPath(row: max(_indexPathForSelected!.row - 1, 0), section: _indexPathForSelected!.section)
                        
                        
                        if indexPath.compare(_indexPathForSelected!) == .orderedSame {
                            
                            let cell_corner = visibleCells[index_corner0]
                            cell_corner?.corner_2.backgroundColor = borderSelectedColor.cgColor
                            
                            let cell_left = visibleCells[index_left]
                            cell_left?.rightBorder.backgroundColor = borderSelectedColor.cgColor
                            cell_left?.corner_2.backgroundColor = borderSelectedColor.cgColor
                            cell_left?.corner_3.backgroundColor = borderSelectedColor.cgColor
                            
                            let cell_top = visibleCells[index_top]
                            cell_top?.bottomBorder.backgroundColor = borderSelectedColor.cgColor
                            cell_top?.corner_2.backgroundColor = borderSelectedColor.cgColor
                            cell_top?.corner_1.backgroundColor = borderSelectedColor.cgColor
                            
                            
                            if isFirstCell {
                                cell._changeBorderColor(borderSelectedColor,layers: cell.corner_0)
                            }
                            
                            if row == 0 {
                                cell._changeBorderColor(borderSelectedColor, layers: cell.topBorder, cell.corner_3)
                            }
                            
                            if column == 0 {
                                cell._changeBorderColor(borderSelectedColor, layers: cell.leftBorder,cell.corner_1,cell.corner_0)
                            }
                            
                            cell._changeBorderColor(borderSelectedColor, layers: cell.bottomBorder,cell.corner_2,cell.rightBorder)
                            
                        } else {
                            if indexPath.compare(index_corner0) == .orderedSame {
                                
                                cell._changeBorderColor(borderColor, layers: cell.corner_2,cell.bottomBorder,cell.rightBorder,cell.topBorder,cell.corner_3,cell.corner_0,cell.leftBorder,cell.corner_1)
                                
                            }
                            if indexPath.compare(index_left) == .orderedSame {
                                
                                cell._changeBorderColor(borderColor, layers: cell.rightBorder,cell.corner_2,cell.bottomBorder,cell.topBorder,cell.corner_0,cell.leftBorder,cell.corner_1)
                                
                            }
                            if indexPath.compare(index_top) == .orderedSame {
                                
                                cell._changeBorderColor(borderColor, layers: cell.bottomBorder,cell.rightBorder,cell.leftBorder,cell.topBorder,cell.topBorder,cell.corner_0,cell.corner_3)
                                
                            }
                            if indexPath.compare(index_corner0) != .orderedSame &&
                                indexPath.compare(index_left) != .orderedSame &&
                                indexPath.compare(index_top) != .orderedSame {
                                cell._changeBorderColor(borderColor, layers: cell.corner_0,cell.corner_1,cell.corner_2,cell.corner_3,cell.topBorder,cell.leftBorder,cell.bottomBorder,cell.rightBorder)
                            }
                            
                        }
                        
                    }
                    
                }
                
                _cleanUnusedCells(displayRangeX,displayRangeY)
                visibleCells[indexPath] = cell
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    

}
