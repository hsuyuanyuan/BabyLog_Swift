//
//  LogTabViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/28/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit






class LogTabViewController: UIViewControllerForWebAPI, UITableViewDelegate, UITableViewDataSource,PickDateDelegate, UploadLogDelegate
{

    let cellReuseId = "logCell"
    
    var _babyName = "" // empty for all baby, but set for one baby

    var _logItemsForDisplay = [DailyLogItem]()
    
    var curDate = "" {
        didSet {
            curDateLabel.text = _babyName + " " + curDate
        }
    }
    
    @IBOutlet weak var curDateLabel: UILabel!
    
 
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
 
 
 

    // MARK: view management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set current date
        let date = NSDate()
        curDate = date.formattedYYYYMMDD
        

        
        // set up table view
        logView.delegate = self
        logView.dataSource = self
        
        //yxu: the following line caused problem!  The labels and images are nil. Have to remove it!  Correct way: 1. set the string in storyboard  2. use it in the code for deque
        //logView.registerClass(LogItemTableViewCell.self, forCellReuseIdentifier: cellReuseId)
        
        logView.tableFooterView = UIView() //yxu: trick to remove the empty cells in tableView
        
        _retrieveDataForDisplayInTableView()

        
   
    }
    
    
    func _retrieveDataForDisplayInTableView() {
        // retrieve the logs for current date
        _retrieveDailyLog(curDate)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //navigationBar!.topItem?.title = curDate + " Log " //refer to: http://stackoverflow.com/questions/10895122/changing-nav-bar-title-programatically
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
    
    
    
    // MARK: call web api
    
    func _deleteDailyLog(logId: Int, atRow: Int) {
        
        _startSpinnerAndBlockUI()
        
        var requestParams : [String:AnyObject] = [ //todo: add sanity check for the date string
            "Id":logId
        ]
        
        callWebAPI(requestParams, curAPIType: APIType.DeleteScheduleForClass, postActionAfterSuccessulReturn: { (data) -> () in
            
            /*
            // delete the member from logItemsForDisplay
            self._logItemsForDisplay = self._logItemsForDisplay.filter({ (logItem ) -> Bool in
                logItem.uniqueId != logId //yxu: filter / map: in nature is looping, O(N)
            })
            */
            
            self._logItemsForDisplay.removeAtIndex(atRow)
            
            
        }, postActionAfterAllReturns: { () -> () in
            // Make sure we are on the main thread, and update the UI.
            dispatch_async(dispatch_get_main_queue()) { //sync or async
                // update some UI
                
                self.logView.reloadData() //yxu: reloadData must be called on main thread. otherwise it does not work!!!
                
                println("updating the table view")
                // resume the UI at the end of async action
                
                self._stopSpinnerAndResumeUI()
                
            }
        } )
        
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
        
        
        
        callWebAPI(requestParams, curAPIType: APIType.AddScheduleForClass, postActionAfterSuccessulReturn: { (data) -> () in
            // refresh the view after uploading
            self._retrieveDailyLog(self.curDate)
            
            // TODO : add to local array, then update tableView => save one web api call
            
            /* refer to: http://www.raywenderlich.com/81880/storyboards-tutorial-swift-part-2
            //add the new player to the players array
            players.append(playerDetailsViewController.player)
            
            //update the tableView
            let indexPath = NSIndexPath(forRow: players.count-1, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            */
        }, postActionAfterAllReturns: nil)
        
    }
    
    
    func _retrieveDailyLog(date: String) {
        
        curDate = date
        // navigationBar!.topItem?.title = curDate + " Log "
        
        _startSpinnerAndBlockUI()
       
        
        var requestParams : [String:AnyObject] = [ //todo: add sanity check for the date string
            //"Id":307, 306, 305
            "Day": date, //"2015-6-25"
        ]
        
        
        
        callWebAPI(requestParams, curAPIType: APIType.GetScheduleForClass, postActionAfterSuccessulReturn: { (data) -> () in
            // refer to: https://grokswift.com/rest-with-alamofire-swiftyjson/
            if let data: AnyObject = data { //yxu: check if data is nil
                let jsonResult = JSON(data)
                
                self._parseJsonForLogItemArray(jsonResult)
                
            }
        }, postActionAfterAllReturns: { () -> () in
            
            // Make sure we are on the main thread, and update the UI.
            dispatch_async(dispatch_get_main_queue()) { //sync or async
                // update some UI
                
                self.logView.reloadData() //yxu: reloadData must be called on main thread. otherwise it does not work!!!
                
                
                println("updating the table view")
                // resume the UI at the end of async action
                
                self._stopSpinnerAndResumeUI()
                
            }
        })
        
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
            _deleteDailyLog(logId, atRow: indexPath.row)
            
        }
    }
    
}






// inherit and override for LogTabViewController
class LogTabForOneBabyViewController: LogTabViewController, UploadLogForOneBabyDelegate
{
    
    var _babyId = 0 // init to invalid one, set by the segue
 
    var _extraInfo = [DailyLogItem_ExtraInfoForBaby]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _babyName = _babyInfoArray[_babyId].nickName
        curDate = curDate // trigger the event caller to set label = name + date
    }
    

    @IBAction func cancelButtonTapped(sender: AnyObject) {
                dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "showAddDailyLogForOneBaby" //yxu: defined in segue property in Storyboard
        {
            let addLogForOneBabyVC = segue.destinationViewController as! AddDailyLogForOneBabyViewController
            addLogForOneBabyVC.delegatePerBaby = self
            addLogForOneBabyVC._babyId = _babyId // pass in the baby id
        }
        
    }
    
    
    
    // MARK: delegate for calendar VC
    override func pickDataFromCalendar(date: String) {
        
        _retrieveDailyLogForOneBaby(date);
        
    }

    
    
    // MARK: delegate for VC
    
    func uploadLogItemForOneBaby(activityItem: DailyLogItem, extraInfo: DailyLogItem_ExtraInfoForBaby)
    {
        println("conform to the delegate: calling api to upload log for one baby ")
        
        _uploadDailyLogForOneBaby(activityItem, extraInfo: extraInfo)
        
    }
    
    override func _retrieveDataForDisplayInTableView() {
        println("baby id = \(_babyId),  current date = \(curDate)")
        
        _retrieveDailyLogForOneBaby(curDate)
    }
    

    
    

    
    // MARK: call web api
    
    func _uploadDailyLogForOneBaby(activityItem: DailyLogItem, extraInfo: DailyLogItem_ExtraInfoForBaby) {
        
        
        // convert images to base64 string
        var imageBase64StrList = [String]()
        
        if (extraInfo._images != nil) {
            for image in extraInfo._images! {
                var imageData = image.mediumQualityJPEGNSData
                if imageData.length > defaultUploadImageSizeLimit {
                    imageData = image.lowQualityJPEGNSData
                }
                
                println("image size: \(imageData.length)") // ~100k
                
                let base64Str = imageData.base64EncodedStringWithOptions( NSDataBase64EncodingOptions.allZeros )
                //refer here for size on disk and size in mem: 
                // http://stackoverflow.com/questions/15656403/inaccurate-nsdata-size-given-in-bytes
                
                imageBase64StrList.append(base64Str)
            }
        }
    
        
        var requestParams : [String:AnyObject] = [
            "TimeBegin":activityItem.startTime, //"08:00",
            "TimeEnd":activityItem.endTime, //"09:30",
            "DiaryType": activityItem.activityType,
            "UploadPic": imageBase64StrList, // array of image data in base64 format
            //"Important": 0,
            //"Open": 0,
            "ByUser": 0,
            "ToUser": extraInfo._babyId, // baby id
            "RankStr": String(extraInfo._stars),
            "Title": "Test Title",
            "Content": activityItem.content,
            "DiaryDate": curDate
        ]
        
        
        
        callWebAPI(requestParams, curAPIType: APIType.AddDairyForOneBaby, postActionAfterSuccessulReturn: { (data) -> () in
            
            // refresh the view after uploading
            self._retrieveDailyLogForOneBaby(self.curDate)
            
            }, postActionAfterAllReturns: nil)
        
        
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
    

    

    
    
    // workflow:
    // 1. segeu pass in the student id?? 
    // 2. call this api to populate the table view

    func _retrieveDailyLogForOneBaby(date: String) {
        
        curDate = date
        // navigationBar!.topItem?.title = curDate + " Log "
        
        _startSpinnerAndBlockUI()
        

        var requestParams : [String:AnyObject] = [ //todo: add sanity check for the date string
            "ToUser": _babyId,
            "Day": date, //"2015-6-25"
        ]
        
        
        callWebAPI(requestParams, curAPIType: APIType.GetDairyForOneBaby, postActionAfterSuccessulReturn: { (data) -> () in
            if let data: AnyObject = data { //yxu: check if data is nil
                let jsonResult = JSON(data)
                
                self._parseJsonForLogItemArray(jsonResult)
                
            }
        }, postActionAfterAllReturns: { () -> () in
            // Make sure we are on the main thread, and update the UI.
            dispatch_async(dispatch_get_main_queue()) { //sync or async
                // update some UI
                
                self.logView.reloadData() //yxu: reloadData must be called on main thread. otherwise it does not work!!!
                
                
                println("updating the table view")
                // resume the UI at the end of async action
                
                self._stopSpinnerAndResumeUI()
                
            }
        })
        
            
    }
    
    
    
    
    func _deleteDailyLogForOneBaby(logId: Int, atRow: Int) {
        
        _startSpinnerAndBlockUI()
        
        var requestParams : [String:AnyObject] = [ //todo: add sanity check for the date string
            "Id":logId
        ]
        
        callWebAPI(requestParams, curAPIType: APIType.DelDairyForOneBaby, postActionAfterSuccessulReturn: { (data) -> () in
            
                // delete the member from logItemsForDisplay
                self._logItemsForDisplay.removeAtIndex(atRow)
                self._extraInfo.removeAtIndex(atRow)
            
            }, postActionAfterAllReturns: { () -> () in
                // Make sure we are on the main thread, and update the UI.
                dispatch_async(dispatch_get_main_queue()) { //sync or async
                    // update some UI
                    
                    self.logView.reloadData() //yxu: reloadData must be called on main thread. otherwise it does not work!!!
                    
                    println("updating the table view")
                    // resume the UI at the end of async action
                    
                    self._stopSpinnerAndResumeUI()
                    
                }
        } )
        
    }
    
    
    // MARK: delegate for table view
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reusableCell  = tableView.dequeueReusableCellWithIdentifier(cellReuseId) as! LogItemForBabyTableViewCell
        
        reusableCell.startEndTimeLabel!.text = _logItemsForDisplay[indexPath.row].startTime + "-" + _logItemsForDisplay[indexPath.row].endTime
        
        reusableCell.activityDetailsLabel!.text = _logItemsForDisplay[indexPath.row].content
        
        if let curActivity = activityTypeDictionary[_logItemsForDisplay[indexPath.row].activityType] {
            
            reusableCell.activityTypeLabel!.text = curActivity.name
            reusableCell.activityIcon!.image = UIImage(named: curActivity.imageName)
            
            
        }
        
        
        //reusableCell.numStarsLabel.text = String( _extraInfo[indexPath.row]._stars )
        
        let starImageName = "Stars-" + String( _extraInfo[indexPath.row]._stars ) + ".png"
        
        reusableCell.numStarsImageView.image = UIImage(named: starImageName)
        
        reusableCell.numImagesButton.setTitle( String( _extraInfo[indexPath.row]._picCount), forState: UIControlState.Normal)
        
        
        // set background of cell:  http://www.gfzj.us/tech/2014/12/09/iOS-dev-tips.html
        //cell.layer.contents = (id)[UIImage imageNamed:@"space_bg.jpg"].CGImage;//fill模式
        //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"space_bg.jpg"]];//平铺模式
        
        return reusableCell
    }
    
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            println("deleting the cell ")
            
            // get id
            let logId = _logItemsForDisplay[indexPath.row].uniqueId
            
            // call web api
            _deleteDailyLogForOneBaby(logId, atRow: indexPath.row)
            
        }
    }
    
    
    

}

