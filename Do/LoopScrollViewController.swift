//
//  LoopScrollViewController.swift
//  Do
//
//  Created by rookie on 2017/2/28.
//  Copyright © 2017年 rookie. All rights reserved.
//

import UIKit

class LoopScrollViewController: UIViewController {
    
    let loopScroll = DoLoopScroller()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loopScroll.frame = view.bounds
        view.addSubview(loopScroll)
        loopScroll.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        loopScroll.backgroundColor = UIColor.do_micrGrayColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
