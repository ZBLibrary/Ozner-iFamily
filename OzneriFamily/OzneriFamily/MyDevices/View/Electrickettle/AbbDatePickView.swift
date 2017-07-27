//
//  AbbDatePickView.swift
//  AbbDatePickDemo
//
//  Created by abb on 16/8/3.
//  Copyright © 2016年 abb. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

/**
 边角类型
 
 - Normal: 默认
 - Circle: 切角
 */
enum CornorType:Int {
    case normal
    case circle
}
class AbbDatePickView: UIView {
    /// 日历
    var calendar:Calendar?
    /// 最小日期
    var minDate:Date?
    /// 最大日期
    var maxDate:Date?
    /// 默认最早的日期
    var earliestPresentedDate:Date {
        return self.showOnlyValidDates ? self.minDate! : Date(timeIntervalSince1970: 0)
    }
    /// 显示日期行数
    var nDays:Int?
    /// 是否只显示有效日期
    var showOnlyValidDates:Bool = false
    /// 保存最终返回的日期
    var date:Date?
    /// 字体配色
    var color:UIColor = UIColor.black
    var bgColor:UIColor = UIColor.white
    /// 回调闭包
    var didFinishSelect:((_ date:Date)->())?
    // MARK: - 初始化方法
    init(cornorType:CornorType,minDate: Date,maxDate: Date,showOnlyValidDates: Bool) {
        super.init(frame: UIScreen.main.bounds)
        self.minDate = minDate
        self.maxDate = maxDate
        self.showOnlyValidDates = showOnlyValidDates
        if cornorType == CornorType.circle {
            setupCornor(bgView.frame)
        }
        setupUI()
        initDate()
        showDateOnPicker(self.date!)
    }
    init(cornorType:CornorType) {
        super.init(frame: UIScreen.main.bounds)
        if cornorType == CornorType.circle {
            setupCornor(bgView.frame)
        }
        setupUI()
        initDate()
        showDateOnPicker(self.date!)
    }
    /**
     加载UI
     */
    fileprivate func setupUI() {
        // 添加子控件
        addSubview(bgView)
        bgView.addSubview(cancelBtn)
        bgView.addSubview(titleLabel)
        bgView.addSubview(donelBtn)
        bgView.addSubview(splitLine)
        bgView.addSubview(pickView)
        
        // 布局子控件
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        donelBtn.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        splitLine.translatesAutoresizingMaskIntoConstraints = false
        pickView.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        let viewDict = ["cancelBtn":cancelBtn,"donelBtn":donelBtn,"titleLabel":titleLabel,"splitLine":splitLine,"pickView":pickView]
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[cancelBtn]-20-[titleLabel(cancelBtn)]-20-[donelBtn(cancelBtn)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[cancelBtn(30)]-5-[splitLine(0.5)]-5-[pickView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[titleLabel(30)]-5-[splitLine(0.5)]-5-[pickView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[donelBtn(30)]-5-[splitLine(0.5)]-5-[pickView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pickView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[splitLine]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        bgView.addConstraints(cons)
        // 添加监听
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        donelBtn.addTarget(self, action: #selector(done), for: .touchUpInside)
        // 配色
        self.color = tintColor
        self.bgView.backgroundColor = bgColor
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.isHidden = true
        // 日历
        if Float(UIDevice.current.systemVersion) >= 8.0 {
            self.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        } else {
            self.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        }

    }
    // MARK: - 控制方法
    /**
     弹出view
     */
    func showInView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bgView.frame.origin.y = UIScreen.main.bounds.height - self.bgView.frame.size.height
            self.isHidden = false
        }) 
    }
    /**
     隐藏view
     */
    func hideFromView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bgView.frame.origin.y = UIScreen.main.bounds.height
        }, completion: { (bool) in
            if bool {
                self.isHidden = true
            }
        }) 
    }
    /**
     根据frame设置圆角
     */
    fileprivate func setupCornor(_ frame:CGRect) {
        let rect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topRight,.topLeft], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        self.bgView.layer.mask = maskLayer
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches)
    }
    // MARK: - pickView方法
    
    /**
     初始化返回日期
     */
    fileprivate func initDate() {
        var startDay = 0
        var startHour = 0
        var startMinute = 0
        
        // 获取天数行数
        if self.minDate != nil && self.maxDate != nil && self.showOnlyValidDates {// 如果设置了最大最小日期
            // 创建一个包含天数,从最小日期到最大日期的组件
            let components = (self.calendar! as NSCalendar).components(.day, from: self.minDate!, to: self.maxDate!, options: NSCalendar.Options(rawValue: 0))
            // 拿到天数的行数
            nDays = components.day! + 1
            
        } else {// 如果没有设置
            // 行数为最大
            nDays = Int(INT16_MAX)
        }
        
        // 最大的日期
        var dateToPresent:Date?
        
        if self.minDate?.compare(Date()) == ComparisonResult.orderedDescending {
            dateToPresent = self.minDate
        } else if self.maxDate?.compare(Date()) == ComparisonResult.orderedAscending {
            dateToPresent = self.maxDate
        } else {
            dateToPresent = Date()
        }
        // 创建一个包含天时分,从最早日期到最大日期的组件
        let todaysComponents = (self.calendar! as NSCalendar).components([.day,.hour,.minute], from: self.earliestPresentedDate, to: dateToPresent!, options: NSCalendar.Options(rawValue: 0))
        // 转换为时间戳并赋值
        startDay = todaysComponents.day! * 60 * 60 * 24
        startHour = todaysComponents.hour! * 60 * 60
        startMinute = todaysComponents.minute! * 60
        // 计算总时间戳
        let timeInterval:TimeInterval = Double(startDay + startHour + startMinute)
        // 赋值给返回的日期
        self.date = Date(timeInterval: timeInterval, since: self.earliestPresentedDate)
    }
    /**
     根据日期滑动到对于的row
     
     - parameter date: 日期
     */
    fileprivate func showDateOnPicker(_ date:Date) {
        
        self.date = date
        // 创一个由年月日,最早的日期组成的组件
        var components = (self.calendar! as NSCalendar).components([NSCalendar.Unit.year,.month,.day], from: self.earliestPresentedDate)
        // 根据组件从日历中拿到NSDate
        let fromDate = self.calendar!.date(from: components)
        // 创建一个日时分,从fromDate到需要显示的date的组件
        components = (self.calendar! as NSCalendar).components([.day,.hour,.minute], from: fromDate!, to: date, options: NSCalendar.Options(rawValue: 0))
        // 计算行数,在计算分钟和小时的时候,为避免滑动到第0行,加上x * (Int(INT16_MAX) / 120),其中x等于对于的进制
        let hoursRow = components.hour! + 24 * (Int(INT16_MAX) / 120)
        let minutesRow = components.minute! + 60 * (Int(INT16_MAX) / 120)
        let daysRow = components.day
        // 滑动到对于的行
        pickView.selectRow(daysRow!, inComponent: 0, animated: true)
        pickView.selectRow(hoursRow, inComponent: 1, animated: true)
        pickView.selectRow(minutesRow, inComponent: 2, animated: true)
    }
    // MARK: - 按钮监听方法
    /**
     取消按钮
     */
    func cancel() {
        // 隐藏
        hideFromView()
    }
    /**
     确定按钮
     */
    func done() {
        // 获取系统当前时区
        let zone = TimeZone.current
        // 计算与GMT时区的差
        let interval = zone.secondsFromGMT(for: date!)
//      let interval =   zone.secondsFromGMT()
        // 加上差的时时间戳
        let localeDate = date?.addingTimeInterval(Double(interval))
        // 回调闭包
        didFinishSelect?(localeDate!)
        // 隐藏
        self.hideFromView()
    }
    // MARK: - 懒加载
    /// 取消按钮
    fileprivate lazy var cancelBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: UIControlState())
        btn.setTitleColor(self.color, for: UIControlState())
        return btn
    }()
    /// 中间标题
    fileprivate lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "选择时间"
        label.textAlignment = NSTextAlignment.center
        label.textColor = self.color
        return label
    }()
    /// 确定按钮
    fileprivate lazy var donelBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", for: UIControlState())
        btn.setTitleColor(self.color, for: UIControlState())
        return btn
    }()
    /// 分割线
    fileprivate lazy var splitLine:UIView = {
        let sl = UIView()
        sl.backgroundColor = self.color
        return sl
    }()
    /// 时间选择器
    fileprivate lazy var pickView:UIPickerView = {
        let pv = UIPickerView()
        pv.delegate = self
        pv.dataSource = self
        return pv
    }()
    // 背景
    fileprivate lazy var bgView:UIView = UIView(frame: CGRect(x: 0, y: self.frame.maxY, width: self.frame.width, height: 250))
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - UIPickerViewDelegate+UIPickerViewDataSource
extension AbbDatePickView:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return nDays ?? 0
        }
        else if component == 1 {
            return Int(INT16_MAX)
        }
        else {
            return Int(INT16_MAX)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 120
        case 1:
            return 60
        case 2:
            return 60
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // 定义一个label用于展示时间
        let dateLabel = UILabel()
        // 字体大小
        dateLabel.font = UIFont.systemFont(ofSize: 25)
        // 字体颜色
        dateLabel.textColor = UIColor.black
        // label背景色
        dateLabel.backgroundColor = UIColor.clear
        
        // 隐藏黑线
        pickerView.subviews[1].isHidden = true
        pickerView.subviews[2].isHidden = true
        
        if component == 0 {// 天数
            // 根据当前的行数转换为时间戳,记录当前行数所表示的日期
            let aDate = Date(timeInterval: Double(row * 24 * 60 * 60), since: self.earliestPresentedDate)
            // 创建一个有纪元年月日组成的,当前时间的组件
            var components = (self.calendar! as NSCalendar).components([.era,.year,.month,.day], from: Date())
            // 根据组件从日历里拿到今天的NSDate()
            let toDay = self.calendar!.date(from: components)
            // 组件变为由当前行数所表示的日期组成的组件
            components = (self.calendar! as NSCalendar).components([.era,.year,.month,.day], from: aDate)
            // 根据组件从日历拿到当前行数表示的NSDate
            let otherDate = self.calendar!.date(from: components)
            // 如果今天的NSDate等于当前行数表示的NSDate,就设置文字为今天
            if toDay! == otherDate! {
                dateLabel.text = "今天"
            } else {
                // 如果不是,创建一个NSDateFormatter
                let formatter = DateFormatter()
                // 地区设置
                formatter.locale = Locale.current
                // 日期格式设置
                formatter.dateFormat = "M月d日"
                // label文字设置
                dateLabel.text = formatter.string(from: aDate)
            }
            dateLabel.textAlignment = NSTextAlignment.center
        } else if component == 1 {// 小时
            // 小时的范围0-23,长度是24
            let max = (self.calendar! as NSCalendar).maximumRange(of: NSCalendar.Unit.hour).length
            // label文字
            dateLabel.text = String(format:"%02ld",row % max)
            dateLabel.textAlignment = NSTextAlignment.left
        } else if component == 2 {// 分钟
            // 分钟的范围0-59,长度是60
            let max = (self.calendar! as NSCalendar).maximumRange(of: NSCalendar.Unit.minute).length
            dateLabel.text = String(format:"%02ld",row % max)
            dateLabel.textAlignment = NSTextAlignment.left
        }
        return dateLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 选择的日的行数
        let daysRow = pickerView.selectedRow(inComponent: 0)
        // 根据行数转换为时间戳
        let chosenDate = Date(timeInterval: Double(daysRow * 24 * 60 * 60), since: self.earliestPresentedDate)
        // 选择的小时的行数
        let hoursRow = pickerView.selectedRow(inComponent: 1)
        // 选择的分钟的行数
        let minutesRow = pickerView.selectedRow(inComponent: 2)
        // 根据选择的日期的时间戳,创建一个有年月日的日历组件
        var components = (self.calendar! as NSCalendar).components([.day,.month,.year], from: chosenDate)
        // 设置组件的小时
        components.hour = hoursRow % 24
        // 设置组件的分钟
        components.minute = minutesRow % 60
        // 根据组件从日历中拿到对应的NSDate,赋值给date
        self.date = self.calendar!.date(from: components)
        // 比较date与限定的最大最小时间,如果超过最大时间或小于最小时间,就回滚到有效时间内
        if self.date!.compare(self.minDate!) == ComparisonResult.orderedAscending {
            self.showDateOnPicker(self.minDate!)
        } else if self.date!.compare(self.maxDate!) == ComparisonResult.orderedDescending {
            self.showDateOnPicker(self.maxDate!)
        }
    }
    
}

