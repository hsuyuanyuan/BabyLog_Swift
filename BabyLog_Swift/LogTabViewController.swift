//
//  LogTabViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/28/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit
import Alamofire


// share functions across the views:  http://stackoverflow.com/questions/27050580/how-are-global-functions-defined-in-swift
extension UIViewController {
    

    
    func _saveUserToken(userToken:String) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(userToken, forKey: userTokenKeyInUserDefault)
    }
    
    func _getUserToken() -> String {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let userToken = userDefault.stringForKey(userTokenKeyInUserDefault) ?? ""
        println("\(userToken)")
        return userToken
    }

    func displayAlert(title: String, message: String ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil) //yxu?: is self the alert or the LoginViewController??
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    

    

    
}









class LogTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,PickDateDelegate, UploadLogDelegate
{

    let cellReuseId = "logCell"
    var activityIndicator:UIActivityIndicatorView!
    var _logItemsForDisplay = [DailyLogItem]()
    var curDate = ""
 
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    @IBOutlet weak var logView: UITableView!
    
    
    @IBAction func pickDateFromCalendar(sender: UIBarButtonItem) {
        
        println("showing the calendar")
        
        let calendarPickerVC = KeleCalendarViewController()
        calendarPickerVC.delegate = self
        
        calendarPickerVC.view.backgroundColor = UIColor.whiteColor()
        calendarPickerVC.modalPresentationStyle = .Custom //tried .CurrentContext. totally blocked the underlying view
        presentViewController(calendarPickerVC, animated: true, completion: nil)
        
        
        
    }
    
    func _startSpinnerAndBlockUI() {
        // block the UI before async action
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents() // prevent the user messing up the ui
    }
    
    func _stopSpinnerAndResumeUI() {
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
    }
    

    // MARK: view management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // set current date
        let date = NSDate()
        
        /*
        // refer to: http://stackoverflow.com/questions/24070450/how-to-get-the-current-timeand-hour-as-datetime-swift
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        
        curDate = "\(components.year)-\(components.month)-\(components.day)"
        */
        
        curDate = date.formattedYYYYMMDD
        
        // set up spinner
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
        // set up table view
        logView.delegate = self
        logView.dataSource = self
        
        //yxu: the following line caused problem!  The labels and images are nil. Have to remove it!
        //logView.registerClass(LogItemTableViewCell.self, forCellReuseIdentifier: cellReuseId)
        
        logView.tableFooterView = UIView() //yxu: trick to remove the empty cells in tableView
        
        _retrieveDataForDisplayInTableView()

        
   
    }
    
    //yxu: override this in children view
    func _retrieveDataForDisplayInTableView() {
        // retrieve the logs for current date
        _retrieveDailyLog(curDate)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBar!.topItem?.title = curDate + " Log " //refer to: http://stackoverflow.com/questions/10895122/changing-nav-bar-title-programatically
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToShowAddLogVC" //yxu: defined in segue property in Storyboard
        {
            let addLogVC = segue.destinationViewController as! AddDailyLogViewController
            addLogVC.delegate = self
        } else if segue.identifier == "showDailyLogPerBaby" {
            
            let dailyLogPerBabyVC = segue.destinationViewController as! AddDailyLogPerBabyViewController
            
            let senderButton = sender as! UIButton
            println("button tag: \(senderButton.tag)")
            
            let curDailyLog = _logItemsForDisplay[senderButton.tag]
            
            dailyLogPerBabyVC.initActivityInternalInfo(curDailyLog)
        }
        
    }
    
    
    
    
    // MARK: delegate for calendar VC
    func pickDataFromCalendar(date: String) {
        
        _retrieveDailyLog(date);

    }
    
    func uploadLogItem(activityItem: DailyLogItem) {
        
        _uploadDailyLog(activityItem)
        
    }
    
    

    
    
    
    // MARK: help functions
    

    

    

    
    
    // MARK: call web api
    
    func _deleteDailyLog(logId: Int) {
        
        // add spinner
        _startSpinnerAndBlockUI()
        
        // call web api: parameter: int Id  日程的Id; http://www.babysaga.cn/app/service?method=ClassSchedule.DeleteSchedule
        
        
        // TODO: make a function for calling web api
        
        // func start
        var requestParams : [String:AnyObject] = [ //todo: add sanity check for the date string
            "Id":logId
        ]
        
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Token": _getUserToken() ]
        
        let data = NSJSONSerialization.dataWithJSONObject(requestParams, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        
        let requestSchedule =  Alamofire.request(.POST, "http://www.babysaga.cn/app/service?method=ClassSchedule.DeleteSchedule", parameters: [:], encoding: .Custom({
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
                    println("Succeeded in deleting the log")
                    
                    // delete the member from logItemsForDisplay
                    self._logItemsForDisplay = self._logItemsForDisplay.filter({ (logItem ) -> Bool in
                        logItem.uniqueId != logId //yxu: filter / map: in nature is looping, O(N)
                    })
                    
                    
                    
                } else {
                    println("Failed to get response")
                    let errStr = (data as! NSDictionary)["Error"] as! String
                    
                }
            } else {
                self.displayAlert("Login failed", message: error!.description)
            }
            
            
            
            
            // Make sure we are on the main thread, and update the UI.
            dispatch_async(dispatch_get_main_queue()) { //sync or async
                // update some UI
                
                self.logView.reloadData() //yxu: reloadData must be called on main thread. otherwise it does not work!!!
                
                
                println("updating the table view")
                // resume the UI at the end of async action
                
                self._stopSpinnerAndResumeUI()
                
            }
            
            
            //todo: persist data with UserDefault
            
        }
        //func end
        
        
        
        // if success, delete it from local copy
        
        // in callback, reload view ( using local copy)
        
        
    }
    
    
    func _uploadDailyLog(activityItem: DailyLogItem) {
        var requestParams : [String:AnyObject] = [
            "TimeBegin":activityItem.startTime, //"08:00",
            "TimeEnd":activityItem.endTime, //"09:30",
            "InDay": curDate,
            "DiaryType": activityItem.activityType,
            "ScheduleRemark": activityItem.content, //"This is a test",
            "isPublish": 0
        ]
        
        
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Token": _getUserToken()] //todo: retrive the token and put it in the header
        
        
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
                    
                    // todo: add to local array, then update tableView => save one web api call
                    
                    /* refer to: http://www.raywenderlich.com/81880/storyboards-tutorial-swift-part-2
                    //add the new player to the players array
                    players.append(playerDetailsViewController.player)
                    
                    //update the tableView
                    let indexPath = NSIndexPath(forRow: players.count-1, inSection: 0)
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    */
                    
                    
                } else {
                    println("Failed to get response")
                    let errStr = (JSON as! NSDictionary)["Error"] as! String
                    
                }
                
                
            } else {
                self.displayAlert("Login failed", message: error!.description)
            }
            
            
        }
        
    }
    
    
    func _retrieveDailyLog(date: String) {
        
        curDate = date
        navigationBar!.topItem?.title = curDate + " Log "
        
        _startSpinnerAndBlockUI()
       
        
        var requestParams : [String:AnyObject] = [ //todo: add sanity check for the date string
            //"Id":307, 306, 305
            "Day": date, //"2015-6-25"
        ]
        
        
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            userTokenStringInHttpHeader: _getUserToken()]
        
        
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
                self.displayAlert("Login failed", message: error!.description)
            }
            
            
            
            
            // Make sure we are on the main thread, and update the UI.
            dispatch_async(dispatch_get_main_queue()) { //sync or async
                // update some UI
                
                self.logView.reloadData() //yxu: reloadData must be called on main thread. otherwise it does not work!!!
                
                
                println("updating the table view")
                // resume the UI at the end of async action
                
                self._stopSpinnerAndResumeUI()

            }
            
            
            //todo: persist data with UserDefault
            
        }
        
    }
    
    
    // refer to: http://stackoverflow.com/questions/26672547/swift-handling-json-with-alamofire-swiftyjson
    // refer to: http://www.raywenderlich.com/82706/working-with-json-in-swift-tutorial
    func _parseJsonForLogItemArray(result: JSON) {
        
        if let logItemArray = result["ScheduleList"].array {
            
            var logItems = [DailyLogItem]()
            
            for logItem in logItemArray {
                var logUniqueId: Int = logItem["Id"].int ?? 0
                var logActivityType: Int = logItem["DiaryType"].int ?? 0
                var logContent: String? = logItem["Content"].string
                var logStartTime: String? = logItem["StartTime"].string
                var logEndTime: String? = logItem["EndTime"].string
                
                var dailyLogItem = DailyLogItem(uniqueId: logUniqueId, activityType: logActivityType, content: logContent, startTime: logStartTime, endTime: logEndTime)
                logItems.append(dailyLogItem)
            }
            
            _logItemsForDisplay = logItems
            
        }
        
        
    }
    
    
    
    
    // MARK: delegate: table view delegate and datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _logItemsForDisplay.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reusableCell  = tableView.dequeueReusableCellWithIdentifier(cellReuseId) as! LogItemTableViewCell
        
        reusableCell.dailyLogPerBabyButton.tag = indexPath.row // used to identify which cell triggers the segue to per-baby view
        
        reusableCell.startEndTimeLabel!.text = _logItemsForDisplay[indexPath.row].startTime + "-" + _logItemsForDisplay[indexPath.row].endTime
        
        reusableCell.activityDetailsLabel!.text = _logItemsForDisplay[indexPath.row].content
        
        if let curActivity = activityTypeDictionary[_logItemsForDisplay[indexPath.row].activityType] {
            
            reusableCell.activityTypeLabel!.text = curActivity.name
            reusableCell.activityIcon!.image = UIImage(named: curActivity.imageName)
            
            
        }
        

 
 
        
        
        // set background of cell:  http://www.gfzj.us/tech/2014/12/09/iOS-dev-tips.html
        //cell.layer.contents = (id)[UIImage imageNamed:@"space_bg.jpg"].CGImage;//fill模式
        //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"space_bg.jpg"]];//平铺模式
        
        return reusableCell
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
            
            // get id
            let logId = _logItemsForDisplay[indexPath.row].uniqueId
            
            // call web api
            _deleteDailyLog(logId)
            
        }
    }
 
    
    
 
    
    
    
}













// inherit and override for LogTabViewController
class LogTabForBabyViewController: LogTabViewController
{
    
    var _babyId = 0 // init to invalid one, set by the segue
 
    var _extraInfo = [DailyLogItem_ExtraInfoForBaby]()
    
 

    
    
    
    @IBAction func finishButtonTapped(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: delegate for calendar VC
    override func pickDataFromCalendar(date: String) {
        
        _retrieveDailyLogForBaby(date);
        
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    // MARK: call web api
    override func _retrieveDataForDisplayInTableView() {
        println("baby id = \(_babyId),  current date = \(curDate)")
        
        _retrieveDailyLogForBaby(curDate)
    }
    
    
    override func _parseJsonForLogItemArray(result: JSON) {
        
        if let logItemArray = result["Diary"].array {
            
            var logItems = [DailyLogItem]()
            var extraInfoItems = [DailyLogItem_ExtraInfoForBaby]()
            
            for logItem in logItemArray {
                var logUniqueId: Int = logItem["Id"].int ?? 0
                var logActivityType: Int = logItem["DiaryTypeId"].int ?? 0
                var logContent: String? = logItem["Content"].string
                var logStartTime: String? = logItem["StartTime"].string
                var logEndTime: String? = logItem["EndTime"].string

                var dailyLogItem = DailyLogItem(uniqueId: logUniqueId, activityType: logActivityType, content: logContent, startTime: logStartTime, endTime: logEndTime)
                logItems.append(dailyLogItem)
                

                var logStars: Int = logItem["Rank"].int ?? 0
                var logBabyId: Int = logItem["ToUseId"].int ?? 0
                var logClassId: Int = logItem["ByClassId"].int ?? 0
                var logCreatorId: Int = logItem["ByUserId"].int ?? 0
                var logPicCount: Int = logItem["PicCount"].int ?? 0
                
                var logPicPaths = [String]()
                
                if let picListArray = logItem["PicList"].array {
                    
                    for pic in picListArray {
                        logPicPaths.append(pic.string ?? "")
                        println("\(pic.string)")
                        
                    }
                }
                
                var extraInfo = DailyLogItem_ExtraInfoForBaby(stars: logStars, babyId: logBabyId, classId: logClassId, creatorId: logCreatorId, picCount: logPicCount, picPaths: logPicPaths)
                
                extraInfoItems.append( extraInfo)
                
            }
            
            _logItemsForDisplay = logItems
            _extraInfo = extraInfoItems
            
        }
        
        
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reusableCell  = tableView.dequeueReusableCellWithIdentifier(cellReuseId) as! LogItemForBabyTableViewCell
        
        // reusableCell.dailyLogPerBabyButton.tag = indexPath.row // used to identify which cell triggers the segue to per-baby view
        
        reusableCell.startEndTimeLabel!.text = _logItemsForDisplay[indexPath.row].startTime + "-" + _logItemsForDisplay[indexPath.row].endTime
        
        reusableCell.activityDetailsLabel!.text = _logItemsForDisplay[indexPath.row].content
        
        if let curActivity = activityTypeDictionary[_logItemsForDisplay[indexPath.row].activityType] {
            
            reusableCell.activityTypeLabel!.text = curActivity.name
            reusableCell.activityIcon!.image = UIImage(named: curActivity.imageName)
            

        }
        

        reusableCell.numStarsLabel.text = String( _extraInfo[indexPath.row]._stars )
        
        reusableCell.numImagesButton.setTitle( String( _extraInfo[indexPath.row]._picCount), forState: UIControlState.Normal)
        
        
        // set background of cell:  http://www.gfzj.us/tech/2014/12/09/iOS-dev-tips.html
        //cell.layer.contents = (id)[UIImage imageNamed:@"space_bg.jpg"].CGImage;//fill模式
        //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"space_bg.jpg"]];//平铺模式
        
        return reusableCell
    }
    
    
    
 
    // 1. segeu pass in the student id?? 
    // 2. call this api to populate the table view

    func _retrieveDailyLogForBaby(date: String) {
        
        curDate = date
        navigationBar!.topItem?.title = curDate + " Log "
        
        _startSpinnerAndBlockUI()
        
        
        var requestParams : [String:AnyObject] = [ //todo: add sanity check for the date string
            "ToUser": _babyId,
            "Day": date, //"2015-6-25"
        ]
        
        
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            userTokenStringInHttpHeader: _getUserToken()]
        
        
        let data = NSJSONSerialization.dataWithJSONObject(requestParams, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        
        // get by date: "http://www.babysaga.cn/app/service?method=ClassSchedule.GetListSchedule"
        // get by Id of date: "http://www.babysaga.cn/app/service?method=ClassSchedule.GetScheduleById"
        let requestSchedule =  Alamofire.request(.POST, "http://www.babysaga.cn/app/service?method=diary.tdaydiary", parameters: [:], encoding: .Custom({
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
                self.displayAlert("Login failed", message: error!.description)
            }
            
            
            
            
            // Make sure we are on the main thread, and update the UI.
            dispatch_async(dispatch_get_main_queue()) { //sync or async
                // update some UI
                
                self.logView.reloadData() //yxu: reloadData must be called on main thread. otherwise it does not work!!!
                
                
                println("updating the table view")
                // resume the UI at the end of async action
                
                self._stopSpinnerAndResumeUI()
                
            }
            
            
            //todo: persist data with UserDefault
            
        }
        
    }

}

