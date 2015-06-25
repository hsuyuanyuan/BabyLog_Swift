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


class LogViewController: UINavigationController {

    override func viewDidAppear(animated: Bool) {
        var refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "buttonMethod") //Use a selector
        logVC.navigationItem.leftBarButtonItem = refreshButton
        
        
        
        
        // teacher's log module
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
        
        
        
    }
    
    

    

}
