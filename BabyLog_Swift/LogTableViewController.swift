//
//  LogViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/24/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit
import Alamofire


/*
Design: Embed a table view controller inside a navigation controller
From the outline view, make sure your Table View Controller is selected.

Then go to the Editor menu, and click on the Embed In submenu, and choose Navigation Controller and voila. You have your navigation controller pointing to your tableview controller with a relationship built in.

*/

//yxu: add this for calendar view: CalendarViewDelegate
class LogTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var logView = UITableView()
    
    var arrLog = ["MorningPlay", "Nap", "AfternoonPlay", "AfternoonSnack"]
   
    let cellReuseId = "logCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //yxu: customize the table view
        logView.separatorStyle = UITableViewCellSeparatorStyle.SingleLineEtched //?? yxu: does not work?? separator
        logView.frame = CGRectMake(0, 50, 320, 200)
        logView.delegate = self
        logView.dataSource = self
        logView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        
        // add a 
        var headerView = UIView(frame: CGRectMake(0, 0, logView.frame.size.width, 30))
        var headerLabel = UILabel(frame: CGRectMake(0, 0, logView.frame.size.width, 30))
        headerLabel.text = "Header Text"
        headerLabel.textColor = UIColor.redColor()
        headerLabel.textAlignment  = NSTextAlignment.Center
        headerView.addSubview(headerLabel)
        
        // add a button to the header
        var btnCalendar = UIButton(frame: CGRectMake(logView.frame.size.width / 2, 0, 100, 30))
        btnCalendar.setTitle("ShowCalendar", forState: UIControlState.Highlighted) //yxu: note: state Selected will not be reset automatically
        btnCalendar.setTitle("ClickCalendar", forState: UIControlState.Normal)
        btnCalendar.backgroundColor = UIColor.greenColor()
        headerView.addSubview(btnCalendar)
        
        logView.tableHeaderView = headerView //yxu: this is the key, do not use addSubView
        
        
        
        
        self.view.addSubview(logView)
        
        
        /*
        //yxu: added calender https://github.com/lancy98/Calendar
        var placeholderView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        // todays date.
        let date = NSDate()
        
        // create an instance of calendar view with
        // base date (Calendar shows 12 months range from current base date)
        // selected date (marked dated in the calendar)
        let calendarView = CalendarView.instance(date, selectedDate: date)
        calendarView.delegate = self
        calendarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        placeholderView.addSubview(calendarView)
        
        
        // Constraints for calendar view - Fill the parent view.
        placeholderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["calendarView": calendarView]))
        placeholderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[calendarView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["calendarView": calendarView]))

        self.view.addSubview(placeholderView)
        */
    }
    
    /* // related to v
    func didSelectDate(date: NSDate) {
        println("\(date.year)-\(date.month)-\(date.day)")
    }
    */
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLog.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier(cellReuseId) as! UITableViewCell
        cell.textLabel?.text = arrLog[indexPath.row]
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected cell #\(indexPath.row)")
    }
    
    
    override func viewDidAppear(animated: Bool) {
        var refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "buttonMethod") //Use a selector
        logVC.navigationItem.leftBarButtonItem = refreshButton

        
        // teacher's retrieveLog module
 
        var requestParams : [String:AnyObject] = [
            "Id":307,
            //"Day":"2015-06-25",
        ]
        
        
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
        "Token": "VhuZ18JOWjuLxyxJ" ] //todo: retrive the token and put it in the header
        
        
        let data = NSJSONSerialization.dataWithJSONObject(requestParams, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        
        // get by date: "http://www.babysaga.cn/app/service?method=ClassSchedule.GetListSchedule"
        // get by Id of date: "http://www.babysaga.cn/app/service?method=ClassSchedule.GetScheduleById"
        let requestSchedule =  Alamofire.request(.POST, "http://www.babysaga.cn/app/service?method=ClassSchedule.GetScheduleById", parameters: [:], encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = data
            return (mutableRequest, nil)
        })).responseJSON() {
            (request, response, JSON, error) in
        
            if error == nil {
                println("we did get the response")
                println(JSON) //yxu: output the unicode
                println(request)
                println(response)
                println(error)
                println((JSON as! NSDictionary)["Error"]!)
                
                let statusCode = (JSON as! NSDictionary)["StatusCode"] as! Int
                if statusCode  == 200 {
                println("Succeeded in getting the log")
            
            
                } else {
                    println("Failed to get response")
                    let errStr = (JSON as! NSDictionary)["Error"] as! String
                
                }
            } else {
            //self.displayAlert("Login failed", message: error!.description)
            }
        }
        

        
        
        
        
        
        // teacher's uploadLog module
        /*
        var requestParams : [String:AnyObject] = [
            "TimeBegin":"08:00",
            "TimeEnd":"09:30",
            "InDay":"2015-06-25",
            "DiaryType": 1,
            "ScheduleRemark": "This is a test",
            "isPublish": 0
        ]
        
        
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Token": "VhuZ18JOWjuLxyxJ" ] //todo: retrive the token and put it in the header
        
        
        let data = NSJSONSerialization.dataWithJSONObject(requestParams, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        
        let requestSchedule =  Alamofire.request(.POST, "http://www.babysaga.cn/app/service?method=ClassSchedule.InputScheduleJson", parameters: [:], encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = data
            return (mutableRequest, nil)
        })).responseJSON() {
            (request, response, JSON, error) in
            
            if error == nil {  //??yxu: error means http error. The web api error is inside JSON
                println("we did get the response")
                println(JSON) //yxu: output the unicode
                println(request)
                println(response)
                println(error)
                println((JSON as! NSDictionary)["Error"]!) //yxu: output Chinese: http://stackoverflow.com/questions/26963029/how-can-i-get-the-swift-xcode-console-to-show-chinese-characters-instead-of-unic
                
                let statusCode = (JSON as! NSDictionary)["StatusCode"] as! Int
                if statusCode  == 200 {
                    println("Succeeded in sending the log")
    
                    
                } else {
                    println("Failed to get response")
                    let errStr = (JSON as! NSDictionary)["Error"] as! String

                }
                
                
            } else {
                //self.displayAlert("Login failed", message: error!.description)
            }
            
 
            
        }
        
        */
        
    }
    
    

    

}
