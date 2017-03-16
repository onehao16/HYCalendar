//
//  MMCalendar.swift
//  HYCalendar
//
//  Created by 黄蒿云 on 2017/3/8.
//  Copyright © 2017年 haoyun. All rights reserved.
//

import UIKit
// 屏幕size
let APP_SCREEN_RECT = UIScreen.main.bounds

// 屏幕宽度
let APP_SCREEN_WIDTH = UIScreen.main.bounds.size.width

//屏幕宽度
let APP_SCREEN_HEIGHT = UIScreen.main.bounds.size.height

/// 屏宽比
let APP_SCREEN_WIDTH_RATE = (APP_SCREEN_WIDTH / 320.0)

let APP_COLOR_RAD  = UIColor.AppHexColor(hexStr: "ff6f9f", alpha: 1)

class HYCalendarView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    var canlendarBlock:((_ day:Int,_ month:Int, _ year : Int) -> ())?

    class func showOnView(onView : UIView) -> HYCalendarView {
        let calendarView = HYCalendarView()
        calendarView.vi_shadeView.frame = onView.bounds
        calendarView.vi_shadeView.alpha = 0
        onView.addSubview(calendarView.vi_shadeView)
        onView.addSubview(calendarView)
        calendarView.show()
        calendarView.setUpUI()
        calendarView.addGesture()
        
        return calendarView
    }
    
    var CurrentDate : Date! {
        didSet{
            lb_month.text = "\(Calendar.year(date: CurrentDate))年\(Calendar.month(date: CurrentDate))月"
            weekFirstDay = Calendar.firstWeekdayInMonth(date: CurrentDate)
            totalMonth = Calendar.totaldaysInThisMonth(date: CurrentDate)
            mCollectionView.reloadData()
        }
    }
    var Today : Date!
    var mCollectionView : UICollectionView!
    var vi_content : UIView!
    lazy var layout :UICollectionViewFlowLayout = {
        let ly = UICollectionViewFlowLayout.init()
        ly.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        ly.minimumLineSpacing = 0
        ly.minimumInteritemSpacing = 0
        return ly
    }()
    
    lazy var lb_month : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.textColor = APP_COLOR_RAD
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var btn_nextMonth : UIButton = {
        let btn = UIButton()
        btn.setTitle("下月", for: UIControlState.normal)
        btn.setTitleColor(APP_COLOR_RAD, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(HYCalendarView.nextBtnClick(_:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    lazy var btn_upMonth : UIButton = {
        let btn = UIButton()
        btn.setTitle("上月", for: UIControlState.normal)
        btn.setTitleColor(APP_COLOR_RAD, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(HYCalendarView.upBtnClick(_:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    lazy var vi_shadeView :UIView = {
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: APP_SCREEN_WIDTH, height: APP_SCREEN_HEIGHT))
        vi.isUserInteractionEnabled = true
        vi.backgroundColor = UIColor.black
        vi.alpha = 0
        return vi
    }()
    var weekFirstDay = 0 //
    var totalMonth = 0
    lazy var weekArray = ["日","一","二","三","四","五","六"]

    let btnWidth :CGFloat = 80
    let btnHeight:CGFloat = 30
    let MMPadding : CGFloat = 10.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        btn_upMonth.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnHeight)
        btn_nextMonth.frame = CGRect(x: APP_SCREEN_WIDTH-btnWidth-40, y: 0, width: btnWidth, height: btnHeight)
        lb_month.frame.size = CGSize(width: 200, height: btnHeight)
        lb_month.center = CGPoint(x: vi_content.center.x, y: 15)
    }
    
    func setUpUI() {
        vi_content = UIView(frame: CGRect(x: 20, y: 0, width: APP_SCREEN_WIDTH-40, height: APP_SCREEN_WIDTH))
        vi_content.backgroundColor = UIColor.white
        vi_content.viewWithSetCorner(corner: 5)
        mCollectionView = UICollectionView(frame: CGRect(x: 0, y: btnHeight+MMPadding, width: APP_SCREEN_WIDTH-40, height: APP_SCREEN_WIDTH-40), collectionViewLayout: layout)
        mCollectionView.backgroundColor = UIColor.white
        mCollectionView.viewWithSetCorner(corner: 5)
        mCollectionView.register(MMCalendarViewCell.self, forCellWithReuseIdentifier: "MMCalendarViewCell")
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        layout.itemSize = CGSize(width: mCollectionView.bounds.width/7.0, height: mCollectionView.bounds.height/7.0)
        self.addSubview(vi_content)
        vi_content.addSubview(mCollectionView)
        vi_content.addSubview(btn_upMonth)
        vi_content.addSubview(btn_nextMonth)
        vi_content.addSubview(lb_month)
    }
    
    func show() {
        self.transform.scaledBy(x: 0, y: APP_SCREEN_HEIGHT + self.frame.size.height)
        UIView.animate(withDuration: 0.5, animations: {
            self.vi_shadeView.alpha = 0.2
            self.transform = .identity
        }) { (bool) in
            
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform.scaledBy(x: 0, y: APP_SCREEN_HEIGHT+self.bounds.height)
            self.vi_shadeView.alpha = 0
        }) { (bool) in
            for subview in self.subviews{
                subview.removeFromSuperview()
            }
            self.removeFromSuperview()
        }
    }
    func addGesture() {
        let swipLeft = UISwipeGestureRecognizer(target: self, action:  #selector(HYCalendarView.nextBtnClick(_:)))
        swipLeft.direction = .left
        self.addGestureRecognizer(swipLeft)
        
        let swipUp = UISwipeGestureRecognizer(target: self, action:  #selector(HYCalendarView.nextBtnClick(_:)))
        swipUp.direction = .up
        self.addGestureRecognizer(swipUp)
        
        let swipDown = UISwipeGestureRecognizer(target: self, action:  #selector(HYCalendarView.upBtnClick(_:)))
        swipDown.direction = .down
        self.addGestureRecognizer(swipDown)
        
        let swipRight = UISwipeGestureRecognizer(target: self, action:  #selector(HYCalendarView.upBtnClick(_:)))
        swipRight.direction = .right
        self.addGestureRecognizer(swipRight)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HYCalendarView.hide))
        vi_shadeView.addGestureRecognizer(tap)
    }

    //下一个月
    func nextBtnClick(_ btn:UIButton) {
        UIView.transition(with: mCollectionView, duration: 0.5, options: UIViewAnimationOptions.transitionCurlUp, animations: {
            self.CurrentDate = Calendar.nextMonth(date: self.CurrentDate)
        }) { (_) in
            
        }
    }
    
    //上一个月
    func upBtnClick(_ btn:UIButton) {
        UIView.transition(with: mCollectionView, duration: 0.5, options: UIViewAnimationOptions.transitionCurlDown, animations: {
            self.CurrentDate = Calendar.lastMonth(date: self.CurrentDate)
        }) { (_) in
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return weekArray.count
        }else{
            return (Int((weekFirstDay + totalMonth)/7)+1)*7 //不全不在当月的cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MMCalendarViewCell", for: indexPath) as! MMCalendarViewCell
        cell.lb_date.backgroundColor = UIColor.white
        if indexPath.section == 0{
            cell.lb_date.text = weekArray[indexPath.row]
            
        }else{
            var day = 0
            let i = indexPath.item
            if i<weekFirstDay || i>weekFirstDay + totalMonth-1 {
                cell.lb_date.text = " "
            }else {
                day = i - weekFirstDay + 1
                cell.lb_date.text = "\(day)"
                if day == Calendar.day(date: CurrentDate) && Calendar.month(date: Today)==Calendar.month(date: CurrentDate){
                    cell.lb_date.backgroundColor = APP_COLOR_RAD
                }
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = indexPath.item - weekFirstDay + 1
        canlendarBlock?(day,Calendar.month(date: CurrentDate),Calendar.year(date: CurrentDate))
        hide()
    }
    
}

class MMCalendarViewCell: UICollectionViewCell{
    var lb_date : UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 17)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(lb_date)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        lb_date.frame = self.bounds
        lb_date.frame.size.width = lb_date.frame.size.height
        lb_date.viewWithSetCorner(corner: lb_date.bounds.height/2+1)
    }
}
