//
//  CalendarPickerViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/26/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit





class CalendarPickerViewController: UIViewController, CalendarViewDelegate {

    var delegate: PickDateDelegate!
    
    
    var bDatePickedFirstTime = true

    
    override func viewDidLoad() {
        
        //yxu: added calender view https://github.com/lancy98/Calendar

        // todays date.
        let date = NSDate()
        
        // create an instance of calendar view with
        // base date (Calendar shows 12 months range from current base date)
        // selected date (marked dated in the calendar)
        let calendarView = CalendarView.instance(date, selectedDate: date)
        calendarView.delegate = self
        calendarView.setTranslatesAutoresizingMaskIntoConstraints(false)
 
        var placeholderView = UIView(frame: CGRectMake(30, 30, view.frame.size.width - 30, view.frame.size.height - 30))
        
        placeholderView.addSubview(calendarView)
        
        // Constraints for calendar view - Fill the parent view.
        placeholderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["calendarView": calendarView]))
        placeholderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[calendarView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["calendarView": calendarView]))
        self.view.addSubview(placeholderView)
 
 
        

    }
    
    
    
    // conform to calendarViewDelegate
    func didSelectDate(date: NSDate) {
        let date = "\(date.year)-\(date.month)-\(date.day)"
        println(date)
        
        delegate?.pickDataFromCalendar(date)
        
        if bDatePickedFirstTime {
            bDatePickedFirstTime = false
        }else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    

    /* // add viewTapped method
    
    // add to viewDidLoad
    //let tapRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped")
    //view.addGestureRecognizer(tapRecognizer)
    
    func viewTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    */
    
}
