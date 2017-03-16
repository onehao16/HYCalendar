//
//  MMExtension.swift
//  HYCalendar
//
//  Created by 黄蒿云 on 2017/3/8.
//  Copyright © 2017年 haoyun. All rights reserved.
//

import UIKit

extension Calendar {
    
    static func month(date:Date)-> Int{
        return Calendar.current.dateComponents([.year,.month,.day], from: date).month!
    }
    
    static func day(date:Date)-> Int{
        return Calendar.current.dateComponents([.year,.month,.day], from: date).day!
    }
    
    static func year(date:Date)-> Int{
        return Calendar.current.dateComponents([.year,.month,.day], from: date).year!
    }
    //获取当前月的第一天是周几
    static func firstWeekdayInMonth(date: Date) -> Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        var comps = calendar.dateComponents([.year,.month, .day], from: date)
        comps.day = 1
        let firstDayOfMonthDate = calendar.date(from: comps)
        let firstWeekDay = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: firstDayOfMonthDate!)!
        
        return firstWeekDay - 1
    }
    
    //当月总共有多少天
    static func totaldaysInThisMonth(date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)!.count
    }
    
    //获得上月
    static func lastMonth(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        let newDate = Calendar.current.date(byAdding:dateComponents , to: date, wrappingComponents: false)!
        return newDate
    }
    
    //获得下月
    static func nextMonth(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let newDate = Calendar.current.date(byAdding:dateComponents , to: date, wrappingComponents: false)!
        return newDate
    }
}

extension UIColor {

    // 16进制颜色
    static func AppHexColor(hexStr hex:String, alpha:CGFloat = 1) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if cString.characters.count < 6 {return UIColor.black}
        if cString.hasPrefix("0X") {cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))}
        if cString.hasPrefix("#") {cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))}
        if cString.characters.count != 6 {return UIColor.black}
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
}


extension UIView {
    //设置圆角
    func viewWithSetCorner(corner:CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = corner
    }
    
    //设置边框
    func viewWithSetBorder(borderWidth:CGFloat = 1.0, borderColor: CGColor) {
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
    }

}

extension Date {
    // 返回当前时间的字符串
    func dateStringInCurrentLocal(format:String = "yyyy年MM月dd日") -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
}
