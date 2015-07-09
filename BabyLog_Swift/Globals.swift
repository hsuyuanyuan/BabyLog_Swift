//
//  Globals.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/9/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//


import UIKit
import Alamofire


let version = 0.5


// TODO: add locking to pretect it, as it is used by multiple VCs
var _babyInfoArray = [BabyInfo]()



// constants for web api
let APICommonPrefix = "http://www.babysaga.cn/app/service?method="

enum APIType: String, Printable {
    
    case AddDairyForOneBaby = "Diary.IOSInputDiary"
    case GetDairyForOneBaby = "diary.tdaydiary"
    
    case ListAllBabiesInClass = "user.ListClassBaby"
    
    case DeleteScheduleForClass = "ClassSchedule.DeleteSchedule"
    case AddScheduleForClass = "ClassSchedule.InputScheduleJson"
    case GetScheduleForClass = "ClassSchedule.GetListSchedule"
    case UploadCompleteStatusWithStars = "ClassSchedule.CompleteSchedule"
    
    var description: String {
        return self.rawValue
    }
}




// constants
let defaultNumStars:Float = 3.0

let defaultImg = "login_bg.png"

let baseURL = NSURL(string: "http://www.babysaga.cn/") // another option, initWithPath is for local folder

let imageDefaultHead = UIImage(named: "TabBar-KId.png")  // default photo for kids without their own photos


let userTokenStringInHttpHeader = "Token" as NSObject

let userTokenKeyInUserDefault = "keyForUserToken"


let activityIdMin = 1 // first activity id, not zero

let activityTypeDictionary = [
    1:ActivityType(id: 1, name: "大便", imageName: "activity_1.jpg"),
    2:ActivityType(id: 2, name: "小便", imageName: "activity_2.jpg"),
    3:ActivityType(id: 3, name: "睡觉", imageName: "activity_3.jpg"),
    4:ActivityType(id: 4, name: "午睡", imageName: "activity_4.jpg"),
    5:ActivityType(id: 5, name: "吃饭", imageName: "activity_5.jpg"),
    6:ActivityType(id: 6, name: "零食", imageName: "activity_6.jpg"),
    7:ActivityType(id: 7, name: "室内个人活动", imageName: "activity_7.jpg"),
    8:ActivityType(id: 8, name: "室内集体活动", imageName: "activity_8.jpg"),
    9:ActivityType(id: 9, name: "室外个人活动", imageName: "activity_9.jpg"),
    10:ActivityType(id: 10, name: "室外集体活动", imageName: "activity_10.jpg"),
    11:ActivityType(id: 11, name: "洗漱", imageName: "activity_11.jpg"),
    12:ActivityType(id: 12, name: "其他", imageName: "activity_12.jpg"),
    13:ActivityType(id: 13, name: "起床", imageName: "activity_13.jpg"),
    14:ActivityType(id: 14, name: "洗澡", imageName: "activity_14.jpg"),
    15:ActivityType(id: 15, name: "生病", imageName: "activity_15.jpg"),
    20:ActivityType(id: 20, name: "到校", imageName: "activity_20.jpg"),
    30:ActivityType(id: 30, name: "离校", imageName: "activity_30.jpg"),
]


// TODO: how to enforace the sync between dict and array
var activityTypeArray = [
    ActivityType(id: 1, name: "大便", imageName: "activity_1.jpg"),
    ActivityType(id: 2, name: "小便", imageName: "activity_2.jpg"),
    ActivityType(id: 3, name: "睡觉", imageName: "activity_3.jpg"),
    ActivityType(id: 4, name: "午睡", imageName: "activity_4.jpg"),
    ActivityType(id: 5, name: "吃饭", imageName: "activity_5.jpg"),
    ActivityType(id: 6, name: "零食", imageName: "activity_6.jpg"),
    ActivityType(id: 7, name: "室内个人活动", imageName: "activity_7.jpg"),
    ActivityType(id: 8, name: "室内集体活动", imageName: "activity_8.jpg"),
    ActivityType(id: 9, name: "室外个人活动", imageName: "activity_9.jpg"),
    ActivityType(id: 10, name: "室外集体活动", imageName: "activity_10.jpg"),
    ActivityType(id: 11, name: "洗漱", imageName: "activity_11.jpg"),
    ActivityType(id: 12, name: "其他", imageName: "activity_12.jpg"),
    ActivityType(id: 13, name: "起床", imageName: "activity_13.jpg"),
    ActivityType(id: 14, name: "洗澡", imageName: "activity_14.jpg"),
    ActivityType(id: 15, name: "生病", imageName: "activity_15.jpg"),
    ActivityType(id: 20, name: "到校", imageName: "activity_20.jpg"),
    ActivityType(id: 30, name: "离校", imageName: "activity_30.jpg"),
]


/* // TODO: think about localization
1:ActivityType(id: 1, name: "DaBian", imageName: "activity_1.jpg"),
2:ActivityType(id: 2, name: "XiaoBian", imageName: "activity_2.jpg"),
3:ActivityType(id: 3, name: "ShuiJiao", imageName: "activity_3.jpg"),
4:ActivityType(id: 4, name: "WuShui", imageName: "activity_4.jpg"),
5:ActivityType(id: 5, name: "ChiFan", imageName: "activity_5.jpg"),
6:ActivityType(id: 6, name: "LingShi", imageName: "activity_6.jpg"),
7:ActivityType(id: 7, name: "ShiNeiGeRenHuoDong", imageName: "activity_7.jpg"),
8:ActivityType(id: 8, name: "ShiNeiJiTiHuoDong", imageName: "activity_8.jpg"),
9:ActivityType(id: 9, name: "ShiWaiGeRenHuoDong", imageName: "activity_9.jpg"),
10:ActivityType(id: 10, name: "ShiWaiJiTiHuoDong", imageName: "activity_10.jpg"),
11:ActivityType(id: 11, name: "XiSu", imageName: "activity_11.jpg"),
12:ActivityType(id: 12, name: "QiTa", imageName: "activity_12.jpg"),
13:ActivityType(id: 13, name: "QiChuang", imageName: "activity_13.jpg"),
14:ActivityType(id: 14, name: "XiZao", imageName: "activity_14.jpg"),
15:ActivityType(id: 15, name: "ShengBing", imageName: "activity_15.jpg"),
20:ActivityType(id: 20, name: "DaoXiao", imageName: "activity_20.jpg"),
30:ActivityType(id: 30, name: "LiXiao", imageName: "activity_30.jpg"),
*/




extension NSDate {
    var formattedHHMM: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return  formatter.stringFromDate(self)
    }
    
    var formattedYYYYMMDD: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd" //formatter.dateFormat = "EEEE, dd MMM yyyy HH:mm:ss Z"
        return formatter.stringFromDate(self)
    }
}




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
    
    
    func callWebAPI(requestParams: [String:AnyObject], curAPIType: APIType, postActionAfterSuccessulReturn: ((data: AnyObject?)->())?, postActionAfterAllReturns: (()->())?) {
        
        let curAPI = APICommonPrefix + curAPIType.description
        
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Token": _getUserToken()] //todo: retrive the token and put it in the header
        
        
        let data = NSJSONSerialization.dataWithJSONObject(requestParams, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        
        
        let requestSchedule =  Alamofire.request(.POST, curAPI, parameters: [:], encoding: .Custom({
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
                    
                    postActionAfterSuccessulReturn?(data: JSON)
                    
                    
                } else {
                    println("Failed to get response")
                    let errStr = (JSON as! NSDictionary)["Error"] as! String
                    
                }
                
                
            } else {
                self.displayAlert( curAPIType.description + " failed", message: error!.description)
            }
            
            
            
            postActionAfterAllReturns?()
            
            
            
        }
        
        
    }
    
    
}

