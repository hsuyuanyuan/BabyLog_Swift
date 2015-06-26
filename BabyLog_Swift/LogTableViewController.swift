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


class LogTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: member varaibles
    var logView = UITableView()
    
    var arrLog = ["MorningPlay", "Nap", "AfternoonPlay", "AfternoonSnack"]
   
    let cellReuseId = "logCell"
    
    
    
    
    // MARK: view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customize a self-defined table view. will be added as a subview
        logView.separatorStyle = UITableViewCellSeparatorStyle.SingleLineEtched //?? yxu: does not work?? separator
        logView.frame = CGRectMake(0, 50, 320, 200)
        logView.delegate = self
        logView.dataSource = self
        logView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        
        // add a label to the header
        var headerView = UIView(frame: CGRectMake(0, 0, logView.frame.size.width, 30)) //yxu: relative to parent's view's upper left corner
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
        
        btnCalendar.addTarget(self, action: "showCalendar:", forControlEvents: .TouchUpInside) // set up the control target func
        
        headerView.addSubview(btnCalendar)
        
        
        // set the table view header
        logView.tableHeaderView = headerView //yxu: this is the key, do not use addSubView
        
        
        // add tableview as a subview to the generic UIViewController
        self.view.addSubview(logView)
        
        

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
    
    
    
    // MARK: table view delegate and datasource
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
    
    

    
    // MARK: control target
    func showCalendar(sender: UIButton) {
        
        println("button pressed")
        
        let calendarPickerVC = CalendarPickerViewController()

        calendarPickerVC.modalPresentationStyle = .Custom
        presentViewController(calendarPickerVC, animated: true, completion: nil)
        
        
    }
    

}
