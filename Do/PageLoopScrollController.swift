//
//  PageLoopScrollController.swift
//  Do
//
//  Created by rookie on 2017/3/1.
//  Copyright © 2017年 rookie. All rights reserved.
//

import UIKit

class PageLoopScrollController: UIViewController {

    let loopScroll = DoPageLoopScroller()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.do_whiteColor()
        
        loopScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 320)
        view.addSubview(loopScroll)
        loopScroll.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        loopScroll.backgroundColor = UIColor.do_micrGrayColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
