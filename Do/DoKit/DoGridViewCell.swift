//
//  DoGridViewCell.swift
//  Do
//
//  Created by rookie on 2017/2/21.
//  Copyright © 2017年 rookie. All rights reserved.
//

import UIKit

class DoGridViewCell: UIView {

    var reuseIdentifier : String?
    let textLabel : UILabel = UILabel()
    
    
    let topBorder    = CALayer()
    let leftBorder   = CALayer()
    let rightBorder  = CALayer()
    let bottomBorder = CALayer()
    
    let corner_0 = CALayer()
    let corner_1 = CALayer()
    let corner_2 = CALayer()
    let corner_3 = CALayer()
    
    
    var _borderWidth : CGFloat = 0 {
        didSet {
            if _borderWidth != 0 {
                _layoutBorder()
            }
        }
    }
    func _layoutBorder() {
        corner_0.frame = CGRect(x: -_borderWidth, y: -_borderWidth, width: _borderWidth, height: _borderWidth)
        corner_1.frame = CGRect(x: -_borderWidth, y: frame.height, width: _borderWidth, height: _borderWidth)
        corner_2.frame = CGRect(x: frame.width, y: frame.height, width: _borderWidth, height: _borderWidth)
        corner_3.frame = CGRect(x: frame.width, y: -_borderWidth, width: _borderWidth, height: _borderWidth)
        
        topBorder.frame = CGRect(x: 0, y: -_borderWidth, width: frame.width, height: _borderWidth)
        leftBorder.frame = CGRect(x: -_borderWidth, y: 0, width: _borderWidth, height: frame.height)
        bottomBorder.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: _borderWidth)
        rightBorder.frame = CGRect(x: frame.width, y: 0, width: _borderWidth, height: frame.height)
    }
    
    convenience init(reuseIdentifier: String?) {
        self.init()
        self.reuseIdentifier = reuseIdentifier
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textLabel)
        textLabel.textAlignment = .center
        //backgroundColor = UIColor.red
        
        topBorder.backgroundColor = UIColor.do_separatorColor().cgColor
        leftBorder.backgroundColor = UIColor.do_separatorColor().cgColor
        rightBorder.backgroundColor = UIColor.do_separatorColor().cgColor
        bottomBorder.backgroundColor = UIColor.do_separatorColor().cgColor
    
        layer.addSublayer(topBorder)
        layer.addSublayer(leftBorder)
        layer.addSublayer(rightBorder)
        layer.addSublayer(bottomBorder)
        
        corner_0.backgroundColor = UIColor.do_separatorColor().cgColor
        corner_1.backgroundColor = UIColor.do_separatorColor().cgColor
        corner_2.backgroundColor = UIColor.do_separatorColor().cgColor
        corner_3.backgroundColor = UIColor.do_separatorColor().cgColor
        
        layer.addSublayer(corner_0)
        layer.addSublayer(corner_1)
        layer.addSublayer(corner_2)
        layer.addSublayer(corner_3)
    }
    
    func _changeBorderColor(_ color:UIColor, layers: CALayer ...) {
        for layer in layers {
            layer.backgroundColor = color.cgColor
        }
    }
    
    override func layoutSubviews() {
        textLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        _layoutBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
