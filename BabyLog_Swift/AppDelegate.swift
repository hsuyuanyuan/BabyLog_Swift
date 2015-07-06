//
//  AppDelegate.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/20/15.
//  Copyright © 2015 StreamSaga. All rights reserved.
//

import UIKit

let version = 0.5






//---- global struct // todo: moving to a separate file

var _babyInfoArray = [BabyInfo]()




//---- constants
let defaultNumStars:Float = 3.0

let defaultImg = "login_bg.png"

let userTokenStringInHttpHeader = "Token" as NSObject

let userTokenKeyInUserDefault = "keyForUserToken"

let baseURL = NSURL(string: "http://www.babysaga.cn/") // another option, initWithPath is for local folder

let imageDefaultHead = UIImage(named: "TabBar-KId.png")
//UIImage(named: "KidPhotoBig.png") // default photo for kids without their own photos


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

//todo: how to enforace the sync between dict and array
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


/*
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



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?


   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      // Override point for customization after application launch.
    
    
      return true
   }

   func applicationWillResignActive(application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   }

   func applicationDidEnterBackground(application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   }

   func applicationWillEnterForeground(application: UIApplication) {
      // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   }

   func applicationDidBecomeActive(application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   }

   func applicationWillTerminate(application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   }


}

