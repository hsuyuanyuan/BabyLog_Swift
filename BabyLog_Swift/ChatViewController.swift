//
//  ChatListViewController.swift
//  TestRongCloud1
//
//  Created by Yuan Xu on 7/12/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit


class ChatViewController: RCConversationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.edgesForExtendedLayout = UIRectEdge.All
        //self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight!, right: 0.0)
        
        
        /* //this prevent the tabbar to cover the tableview space
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 90)];
        footer.backgroundColor = [UIColor clearColor];
        myTableView.tableFooterView = footer;
        */
        
        let footer = UIView(frame: CGRectMake(0,0,1,90))
        footer.backgroundColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
        conversationType = RCConversationType.ConversationType_PRIVATE
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        println("In viewDidLoad")
    }
    
    
    
    func initRongyunIDandName(rongyunId: String, rongyunName: String) {
        targetId = rongyunId
        userName = rongyunName
        title = rongyunName
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startConversationButtonTapped(sender: AnyObject) {

            /*
            var converstaionVC = RCConversationViewController()
            converstaionVC.conversationType = RCConversationType.ConversationType_PRIVATE
            converstaionVC.targetId = String(userIds[nextUser])
            converstaionVC.userName = userNames[nextUser]
            converstaionVC.title = userName
            self.navigationController?.pushViewController(converstaionVC, animated: true)
        */
        
    }



    /*
    override func onSelectedTableRow(conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, atIndexPath indexPath: NSIndexPath!) {
        
        var converstaionVC = RCConversationViewController()
        converstaionVC.conversationType = model.conversationType
        converstaionVC.targetId = model.targetId
        converstaionVC.userName = model.conversationTitle
        converstaionVC.title = model.conversationTitle
        self.navigationController?.pushViewController(converstaionVC, animated: true)
        
    }
    */
    
    
    /*
    // TO REMOVE: test RongCloud web api
    
    func callRongCloudTestAPIFunc() {
        
        
        let curAPI = "http://api.cn.ronghub.com/user/getToken.json"
        
        
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            
            "Content-Type": "application/x-www-form-urlencoded",
            "App-Key": "mgb7ka1nb5rjg"
        ]
        // refer to: http://stackoverflow.com/questions/28526743/how-to-use-alamofire-with-custom-headers-for-post-request
        
        
        
        
        /*  // Json format in body
        var requestParams : [String:AnyObject] = [
        "userId":"343233", //"08:00",
        "name":"Test333", //"09:30",
        
        ]
        
        let data = NSJSONSerialization.dataWithJSONObject(requestParams, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        */
        
        // form in body
        let bodyStr:String = "userId=4&name=Test444"
        let data = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let requestSchedule =  Alamofire.request(.POST, curAPI, parameters: [:], encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = data
            return (mutableRequest, nil)
        })).responseJSON() {
            (request, response, JSON, error) in
            
            
            println("we did get the response")
            println(JSON) //yxu: output the unicode
            println(request)
            println(response)
            println(error)
            
            
            if error == nil {  //: error means http error. The api specific logic error is contained inside JSON
                
                //println((JSON as! NSDictionary)["Error"]!) //yxu: output Chinese: http://stackoverflow.com/questions/26963029/how-can-i-get-the-swift-xcode-console-to-show-chinese-characters-instead-of-unic
                
                if JSON != nil {
                    
                    if let statusCode = (JSON as! NSDictionary)["StatusCode"] as? Int {
                        if statusCode  == 200 {
                            println("Succeeded in making the api call: "   )
                            
                        } else {
                            let errStr = (JSON as! NSDictionary)["Error"] as! String
 
                        }
                    }
                }
                
                
            } else {
 
            }
            
            
            
            
            
            
        }
        
    }
    
    */
    
}
