//
//  AppDelegate.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/20/15.
//  Copyright © 2015 StreamSaga. All rights reserved.
//

import UIKit


    var mainVC = MainTabBarController() //global main view controller


    //todo: move the sub vc to mainVC class:  add them in viewDidAppear
    // http://stackoverflow.com/questions/26850411/how-add-tabs-programmatically-in-uitabbarcontroller-with-swift
    var logVC = MoreTableViewController()
    var videoVC = MoreTableViewController()
    var msgVC = MoreTableViewController()
    var moreVC = MoreTableViewController() // one tab in the main vc

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?


   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      // Override point for customization after application launch.
    
    
    
    
    

    mainVC.viewControllers = [logVC, videoVC, msgVC, moreVC]
    mainVC.view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height) //yxu: todo: double check a better way to get screen width and height
    mainVC.view.backgroundColor = UIColor.grayColor()
    

    //set up tab bar item in each tab
    logVC.tabBarItem = UITabBarItem(title:"log", image: UIImage(named: "tabicon_log_off"), selectedImage: UIImage(named: "tabicon_log_on"))
    logVC.tabBarItem.tag = 1
    logVC.view.backgroundColor = UIColor.redColor()
    
    videoVC.tabBarItem = UITabBarItem(title:"video", image: UIImage(named: "tabicon_video_off"), selectedImage: UIImage(named: "tabicon_video_on"))
    videoVC.tabBarItem.tag = 2
    videoVC.view.backgroundColor = UIColor.blueColor()

    msgVC.tabBarItem = UITabBarItem(title:"message", image: UIImage(named: "tabicon_message_off"), selectedImage: UIImage(named: "tabicon_message_on"))
    msgVC.tabBarItem.tag = 3
    msgVC.view.backgroundColor = UIColor.greenColor()
    
    
    moreVC.tabBarItem = UITabBarItem(title:"more", image: UIImage(named: "tabicon_class_off"), selectedImage: UIImage(named: "tabicon_class_on"))
    moreVC.tabBarItem.tag = 4
    moreVC.view.backgroundColor = UIColor.yellowColor()
 
    
    
    
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

