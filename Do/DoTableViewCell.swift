//
//  DoTableViewCell.swift
//  Do
//
//  Created by rookie on 2017/2/17.
//  Copyright © 2017年 rookie. All rights reserved.
//

import UIKit

class DoTableViewCell: UIView {

    var reuseIdentifier : String?
    let textLabel : UILabel = UILabel()
    
    convenience init(reuseIdentifier: String?) {
        self.init()
        self.reuseIdentifier = reuseIdentifier
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textLabel)
        
        layer.addSublayer(line)
        line.backgroundColor = UIColor.do_separatorColor().cgColor
    }
    
    
    let line = CALayer()
    
    override func layoutSubviews() {
        line.frame = CGRect(x: 0, y: frame.height - 0.5, width: frame.width, height: 0.5)
        textLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
