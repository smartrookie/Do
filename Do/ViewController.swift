//
//  ViewController.swift
//  Do
//
//  Created by rookie on 2017/2/17.
//  Copyright © 2017年 rookie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = DoTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.do_whiteColor()
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        tableView.autoresizesSubviews = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController : DoTableViewDataSource {
    
    func numberOfSections(in tableView: DoTableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: DoTableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: DoTableView, cellForRowAt indexPath: IndexPath) -> DoTableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = DoTableViewCell(reuseIdentifier: "cell")
        }
        cell?.textLabel.text = indexPath.row.description
        
        return cell!
    }
    
    func tableView(_ tableView: DoTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
