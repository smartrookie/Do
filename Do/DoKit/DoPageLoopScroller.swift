//
//  DoPageLoopScroller.swift
//  Do
//
//  Created by rookie on 2017/3/1.
//  Copyright © 2017年 rookie. All rights reserved.
//

import UIKit

class DoPageLoopScroller: UIScrollView {
    
    let pageCount : NSInteger = 7
    
    let pageController = UIPageControl()
    
    let colors = [UIColor.red,UIColor.orange,UIColor.yellow,UIColor.green,UIColor.blue,UIColor.cyan]
    var views : [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pageController.size(forNumberOfPages: pageCount)
        pageController.numberOfPages = pageCount
        pageController.backgroundColor = UIColor.do_lightGrayColor()
        pageController.currentPage = 0
        addSubview(pageController)
        pageController.pageIndicatorTintColor = UIColor.red
        translatesAutoresizingMaskIntoConstraints = false
        isPagingEnabled = true
        bounces = false
        
        pageController.frame = CGRect(x: 0, y: 0, width: 320, height: 80)
        pageController.currentPageIndicatorTintColor = UIColor.black
        
        for i in 0 ..< colors.count {
            let view = UIView()
            view.backgroundColor = colors[i]
            view.frame = CGRect(x: i * 320, y: 0, width: 320, height: 80)
            addSubview(view)
            views.append(view)
        }
        delegate = self
        
    }
    
    
    
    
    
    override func layoutSubviews() {
        
        contentSize = CGSize(width: frame.width * CGFloat( pageCount ), height: frame.height - contentInset.top)
        for i in 0 ..< views.count {
            let view = views[i]
            view.frame = CGRect(x: CGFloat(i) * frame.width, y: 0, width: frame.width, height: frame.height)
        }
        
        pageController.frame = CGRect(x: contentOffset.x + 5 , y: frame.height - 80 - contentInset.top, width: frame.width - 10, height: 80)
        
        
        if contentOffset.x == 0 || contentOffset.x == frame.width * 6  {
            let offsetX = frame.width * 3
            contentOffset = CGPoint(x: offsetX, y: contentOffset.y)
        }
        
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension DoPageLoopScroller : UIScrollViewDelegate {
    
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    
    
}




















