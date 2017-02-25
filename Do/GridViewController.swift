//
//  GridViewController.swift
//  Do
//
//  Created by rookie on 2017/2/21.
//  Copyright © 2017年 rookie. All rights reserved.
//

import UIKit

class GridViewController: UIViewController {
    
    let gridView = DoGridView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Grid view"
        view.backgroundColor = UIColor.do_whiteColor()
        
        gridView.frame = view.bounds
        view.addSubview(gridView)
        
        gridView.dataSource = self
        gridView.doDelegate = self 
        gridView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        gridView.autoresizesSubviews = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension GridViewController : DoGridViewDataSource {
    
    func numberOfRows(in gridView: DoGridView) -> Int {
        return 2000
    }
    
    func numberOfColumns(in gridView: DoGridView) -> Int {
        return 2000
    }
    
    func gridView(_ gridView: DoGridView, cellForGridAt row: NSInteger, column: NSInteger) -> DoGridViewCell {
        
        var cell : DoGridViewCell? = gridView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = DoGridViewCell(reuseIdentifier: "cell")
        }
        cell?.textLabel.text = "\(row) x \(column)"
        return cell!
    }
    
    func gridView(_ gridView: DoGridView, heightForRowAt row: NSInteger) -> CGFloat {
        return 44
    }
    
    func gridView(_ gridView: DoGridView, widthForColumnAt column: NSInteger) -> CGFloat {
        return 80
    }
    
    
}

extension GridViewController : DoGridViewDelegate {
    
    func gridView(_ gridView: DoGridView, didSelectRowAt indexPath: IndexPath) {
        print("selected gridview index \(indexPath)")
    }

    
}




