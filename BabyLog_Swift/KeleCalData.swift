//
//  keleData.swift
//  KeleCalendar
//
//  Created by antz on 15/6/17.
//  Copyright (c) 2015年 antz. All rights reserved.
//

import UIKit

private var INS:KeleCalData?


struct CalDataVO {
    var startWeek:Int?
    var totalDays:Int?
    var today:Int? //如果>1 表示当月即今月
    var year:Int?
    var month:Int?
    
    init(){
        
    }
}

struct CalDateTimeVO {
    var year:Int?
    var month:Int?
    var day:Int?
    
    init()
    {
        
    }
}

class KeleCalData:NSObject
{
    private var _calendar: NSCalendar?
    private var _todayDate:NSDate?
    private var _todayComp:NSDateComponents?
    
    
    private var _currentComp:NSDateComponents?
    
    
    var currentDay:CalDataVO!
    var preDay:CalDataVO!
    var nextDay:CalDataVO!
    
    class func getIns()->KeleCalData
    {
        if (INS == nil)
        {
            INS = KeleCalData()
        }
        
        return INS!
    }
    
    override init()
    {
        super.init()
        self._calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        self._calendar!.firstWeekday = 1
        
        self.setToday()
        
    }
    
    internal func next()
    {
        _currentComp?.month++
        getDay()
    }
    
    internal func pre()
    {
        _currentComp?.month--
        getDay()
    }
 
    
    internal func setToday()
    {
        _todayDate = NSDate()
        _todayComp = dateRange(_todayDate!)
        _currentComp = _todayComp
        
        self.getDay()
    }
    
    private func getDay()
    {
       
       currentDay =  parse(getDateByComp(_currentComp!))
        
        
        _currentComp?.month--
        preDay = parse(getDateByComp(_currentComp!))
        
        _currentComp?.month = _currentComp!.month + 2
        nextDay = parse(getDateByComp(_currentComp!))
        
        _currentComp?.month--
    }
  
    
    
    internal func getDayStr(data:CalDataVO!)->String
    {
        return String(data.year!) + "年" + String(data.month!) + "月"
    }

    //-------------------PRIVATE---------------------------------
    private func parse(date:NSDate)->CalDataVO!
    {
        var data:CalDataVO = CalDataVO()
        //当前月和年
        let comp:NSDateComponents = self.dateRange(date)
        
        data.year = comp.year
        data.month = comp.month
        
        _currentComp = comp
        
        //当月第一天开始week
        comp.day = 1
        let date:NSDate! = self._calendar?.dateFromComponents(comp)
        let comp1 = self.dateRange(date)
        data.startWeek =  comp1.weekday
        
        //当月总天数
        let total:Int! = self._calendar?.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date).length
        data.totalDays = total
        
        //当月是否有今日
        if(data.year == _todayComp?.year && data.month == _todayComp?.month)
        {
            data.today = _todayComp?.day
        } else {
            data.today = -1
        }
        
        
//        println(data.year)
//        println(data.month)
//        println(data.today)
//        println(data.totalDays)
//        println(data.startWeek)
//        println("-------------")
        
        return data
        
    }
    
    
    private func getDateByComp(comp:NSDateComponents)->NSDate
    {
        let date:NSDate! = self._calendar?.dateFromComponents(comp)
        
        return date
    }
    
    
    private func dateRange(date: NSDate) -> (NSDateComponents) {
        // http://stackoverflow.com/questions/22744458/how-to-replace-deprecated-nsweekcalendarunit-in-context-of-uilocalnotification
        // explain replace the deprecated week to weekofMonth or weekorYear
        let units:NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.WeekOfMonth, NSCalendarUnit.Day, NSCalendarUnit.Weekday]
        let components = self._calendar?.components(units, fromDate: date)
        
        return components!
    }
    
    
    //    internal func monthDateRange(date: NSDate) -> (countOfWeeks: NSInteger, monthStartDate: NSDate, monthEndDate: NSDate) {
    //
    //        var components = self.dateRange(date)
    //        // Start of the month.
    //        components.day = 1
    //        let monthStartDate = self._calendar?.dateFromComponents(components)
    //
    //        // End of the month.
    //        components.month += 1
    //        components.day -= 1
    //        let monthEndDate = self._calendar?.dateFromComponents(components)
    //
    //        // Range of the month.
    //        let range = self._calendar?.rangeOfUnit(NSCalendarUnit.WeekCalendarUnit, inUnit: NSCalendarUnit.MonthCalendarUnit, forDate: date)
    //        let countOfWeeks = range?.length
    //
    //        return (countOfWeeks!, monthStartDate!, monthEndDate!)
    //        
    //    }
    
    
    
}


