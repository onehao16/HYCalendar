//
//  ViewController.swift
//  HYCalendar
//
//  Created by 黄蒿云 on 2017/3/8.
//  Copyright © 2017年 haoyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var btn : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = Calendar.current.dateComponents([.year,.month,.day], from: Date())
        print("\(calendar.year!)-\(calendar.month!)-\(calendar.day!)")
        print("这个月的第一天是周:\(Calendar.firstWeekdayInMonth(date: Date()))")
        let dayCount = Calendar.totaldaysInThisMonth(date: Date(timeIntervalSinceNow: -2819000))
        print("当前月份天数dayCount:\(dayCount)")
        let lastMonth = Calendar.lastMonth(date: Date(timeIntervalSinceNow: 1900800))
        print("上一个月lastMonth:\(lastMonth)")
        
        let nextMonth = Calendar.nextMonth(date: Date(timeIntervalSinceNow: 1900800))
        print("下一个月nextMonth:\(nextMonth)")
        
        btn = UIButton(frame: CGRect(x: 0, y: 200, width: APP_SCREEN_WIDTH, height: 30))
        btn.setTitle("日历", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.setTitleColor(UIColor.brown, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(ViewController.btnClick(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(btn)
        
    }

    func btnClick(_ btn:UIButton) {
        let calendarView = HYCalendarView.showOnView(onView: view)
        calendarView.frame = CGRect(x: 0, y: 100, width: APP_SCREEN_WIDTH, height: APP_SCREEN_WIDTH)
        calendarView.CurrentDate = Date()
        calendarView.Today = Date()
        view.addSubview(calendarView)
        
        calendarView.canlendarBlock = {(_ day:Int,_ month:Int, _ year : Int) -> () in
            btn.setTitle("选中的日期是\(year)-\(month)-\(day)", for: UIControlState.normal)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

