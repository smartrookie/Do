//
//  DoColor.swift
//  Do
//
//  Created by rookie on 2017/2/20.
//  Copyright © 2017年 rookie. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    /**深灰*/
    static func do_darkGrayColor() -> UIColor {
        return UIColor.color(hex: "#444a5a")
    }
    /**浅灰*/
    static func do_lightGrayColor() -> UIColor {
        return UIColor.color(hex: "#acb3bb")
    }
    /**微灰*/
    static func do_micrGrayColor() -> UIColor {
        return UIColor.color(hex: "#dbdbdd")
    }
    /**蓝*/
    static func do_blueColor() -> UIColor {
        return UIColor.color(hex: "#1777cb")
    }
    /**黄*/
    static func do_yellowColor() -> UIColor {
        return UIColor.color(hex: "#ddba76")
    }
    /**绿*/
    static func do_greenColor() -> UIColor {
        return UIColor.color(hex: "#20ab36")
    }
    /**白*/
    static func do_whiteColor() -> UIColor {
        return UIColor.color(hex: "#f9f9f9")
    }
    /**轻白*/
    static func do_lightWhiteColor() -> UIColor {
        return UIColor.color(hex: "#f2f2f2")
    }
    
    static func do_accentColor() -> UIColor {
        return UIColor.color(hex: "#007ee5")
    }
    
    static func do_separatorColor() -> UIColor {
        return UIColor.color(hex: "#c8c7cc")
    }
    
    static func do_selectionColor() -> UIColor {
        return UIColor.color(hex: "#d9d9d9")
    }
    
    static func do_destructiveAccentColor() -> UIColor {
        return UIColor.color(hex: "#ff3b30")
    }
}



extension UIColor {
    
    static func color(hex:String) -> UIColor {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
        _ = hexStrToRGBA(hex, &r, &g, &b, &a)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

func hexStrToRGBA(_ hexStr: String, _ r: inout CGFloat, _ g: inout CGFloat, _ b: inout CGFloat, _ a: inout CGFloat) -> Bool {
    var hexStr = hexStr
    hexStr = hexStr.uppercased()
    if hexStr.hasPrefix("#") {
        hexStr = hexStr.substring(from: hexStr.index(hexStr.startIndex, offsetBy: 1))
    } else if hexStr.hasPrefix("0X") {
        hexStr = hexStr.substring(from: hexStr.index(hexStr.startIndex, offsetBy: 2))
    }
    
    let length = hexStr.characters.count
    if length != 3 && length != 4 && length != 6 && length != 8 {
        return false
    }
    
    if length < 5 {
        r = CGFloat(hexStrToFloat( (hexStr as NSString).substring(with: NSRange(location: 0, length: 1)) )) / 255.0
        g = CGFloat(hexStrToFloat( (hexStr as NSString).substring(with: NSRange(location: 1, length: 1)) )) / 255.0
        b = CGFloat(hexStrToFloat( (hexStr as NSString).substring(with: NSRange(location: 2, length: 1)) )) / 255.0
        if length == 4 {
            a = CGFloat(hexStrToFloat( (hexStr as NSString).substring(with: NSRange(location: 3, length: 1)) )) / 255.0
        } else {
            a = 1
        }
    } else {
        r = CGFloat(hexStrToFloat( (hexStr as NSString).substring(with: NSRange(location: 0, length: 2)) )) / 255.0
        g = CGFloat(hexStrToFloat( (hexStr as NSString).substring(with: NSRange(location: 2, length: 2)) )) / 255.0
        b = CGFloat(hexStrToFloat( (hexStr as NSString).substring(with: NSRange(location: 4, length: 2)) )) / 255.0
        if length == 4 {
            a = CGFloat(hexStrToFloat( (hexStr as NSString).substring(with: NSRange(location: 6, length: 2)) )) / 255.0
        } else {
            a = 1
        }
    }
    return true
}

func hexStrToFloat(_ hexStr: String) -> Float {
    var result : Float = 0
    Scanner(string: "0X" + hexStr).scanHexFloat(&result)
    return result
}
