//
//  LogTabViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/28/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit
import Alamofire

class LogTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,PickDateDelegate, UploadLogDelegate
{

    let cellReuseId = "logCell"
    
    var logItemsForDisplay = [DailyLogItem]()
    
    var curDate = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logView.delegate = self
        logView.dataSource = self
        logView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        
        // set current date
        let date = NSDate()
        curDate = "\(date.year)-\(date.month)-\(date.day)"
        
        // retrieve the logs for current date
        _retrieveDailyLog(curDate)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBar!.topItem?.title = curDate + " Log " //refer to: http://stackoverflow.com/questions/10895122/changing-nav-bar-title-programatically
    }
    
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    @IBOutlet weak var logView: UITableView!
    
    
    @IBAction func pickDateFromCalendar(sender: UIBarButtonItem) {
        
        println("showing the calendar")
        
        let calendarPickerVC = KeleCalendarViewController()
        calendarPickerVC.delegate = self
        
        calendarPickerVC.modalPresentationStyle = .Custom
        presentViewController(calendarPickerVC, animated: true, completion: nil)
        
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToShowAddLogVC" //yxu: defined in segue property in Storyboard
        {
            let addLogVC = segue.destinationViewController as! AddDailyLogViewController
            addLogVC.delegate = self
        }
        
    }
    
    
    
    
    // MARK: delegate for calendar VC
    func pickDataFromCalendar(date: String) {
        
        _retrieveDailyLog(date);
        
        
        
    }
    
    func uploadLogItem(activityId: Int) {
        
        
        
        var requestParams : [String:AnyObject] = [
            "TimeBegin":"08:00",
            "TimeEnd":"09:30",
            "InDay": curDate,
            "DiaryType": activityId,
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
                    
                    
                    // refresh the view after uploading
                    self._retrieveDailyLog(self.curDate)
                    
                    
                } else {
                    println("Failed to get response")
                    let errStr = (JSON as! NSDictionary)["Error"] as! String
                    
                }
                
                
            } else {
                //self.displayAlert("Login failed", message: error!.description)
            }
            
            
        }
        
    }
    
    
    
    
    func _retrieveDailyLog(date: String) {
        
        curDate = date
        navigationBar!.topItem?.title = curDate + " Log "
        
        // block the UI before async action
        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents() // prevent the user messing up the ui
        
        
        
        //todo: add sanity check for the date string
        
        var requestParams : [String:AnyObject] = [
            //"Id":307, 306, 305
            "Day": date, //"2015-6-25"
        ]
        
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Token": "VhuZ18JOWjuLxyxJ" ] //todo: retrive the token from UserDefault and put it in the header
        
        
        let data = NSJSONSerialization.dataWithJSONObject(requestParams, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        
        // get by date: "http://www.babysaga.cn/app/service?method=ClassSchedule.GetListSchedule"
        // get by Id of date: "http://www.babysaga.cn/app/service?method=ClassSchedule.GetScheduleById"
        let requestSchedule =  Alamofire.request(.POST, "http://www.babysaga.cn/app/service?method=ClassSchedule.GetListSchedule", parameters: [:], encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = data
            return (mutableRequest, nil)
        })).responseJSON() {
            (request, response, data, error) in
            
            if error == nil {
                println("we did get the response")
                println(data) //yxu: output the unicode
                println(request)
                println(response)
                println(error)
                println((data as! NSDictionary)["Error"]!)
                
                let statusCode = (data as! NSDictionary)["StatusCode"] as! Int
                if statusCode  == 200 {
                    println("Succeeded in getting the log")
                    
                    // refer to: https://grokswift.com/rest-with-alamofire-swiftyjson/
                    if let data: AnyObject = data { //yxu: check if data is nil
                        let jsonResult = JSON(data)
                        
                        self._parseJsonForLogItemArray(jsonResult)
                        
                    }
                    
                    
                } else {
                    println("Failed to get response")
                    let errStr = (data as! NSDictionary)["Error"] as! String
                    
                }
            } else {
                //self.displayAlert("Login failed", message: error!.description)
            }
            
            
            
            
            // Make sure we are on the main thread, and update the UI.
            dispatch_async(dispatch_get_main_queue()) { //sync or async
                // update some UI
                
                self.logView.reloadData() //yxu: reloadData must be called on main thread. otherwise it does not work!!!
                
                
                println("updating the table view")
                // resume the UI at the end of async action
                activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
            
            
            //todo: save the date to local strcture, array of logs
            
        }
        
    }
    
    // refer to: http://stackoverflow.com/questions/26672547/swift-handling-json-with-alamofire-swiftyjson
    // refer to: http://www.raywenderlich.com/82706/working-with-json-in-swift-tutorial
    func _parseJsonForLogItemArray(result: JSON) {
        
        if let logItemArray = result["ScheduleList"].array {
            
            var logItems = [DailyLogItem]()
            
            for logItem in logItemArray {
                var logId: Int = logItem["Id"].int ?? 0
                var logContent: String? = logItem["Content"].string
                var logStartTime: String? = logItem["StartTime"].string
                var logEndTime: String? = logItem["EndTime"].string
                
                var dailyLogItem = DailyLogItem(id: logId, content: logContent, startTime: logStartTime, endTime: logEndTime)
                logItems.append(dailyLogItem)
            }
            
            logItemsForDisplay = logItems
            
        }
        
        
    }
    
    
    
    
    // MARK: delegate: table view delegate and datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logItemsForDisplay.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier(cellReuseId) as! UITableViewCell
        cell.textLabel?.text = logItemsForDisplay[indexPath.row].id.description
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected cell #\(indexPath.row)")
    }
    
    
    // add following two to delete the cell:  http://stackoverflow.com/questions/24103069/swift-add-swipe-to-delete-tableviewcell
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            println("deleting the cell ")
            
            // add spinner
            
            // call web api 
            
            // if success, delete it from local copy
            
            // in callback, reload view ( using local copy)
            
            
        }
    }
 
    
    
    
}
