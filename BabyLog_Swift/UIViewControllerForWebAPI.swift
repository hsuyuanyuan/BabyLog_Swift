//
//  UIViewControllerForWebAPI.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/9/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit
// import Alamofire // To support iOS 7.0, followed Mattt's instruction: https://github.com/Alamofire/Alamofire/commit/8e2e5251144a7792e8358e8ff9326bb7aa71ab7a




// share functions across the views:  http://stackoverflow.com/questions/27050580/how-are-global-functions-defined-in-swift
class UIViewControllerForWebAPI: UIViewController {
    
    // MARK: user token
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
    

    
    
    // MARK: spinner and UI
    var activityIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up spinner
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
 
    }
    
    
    func _startSpinnerAndBlockUI(){
        // block the UI before async action
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents() // prevent the user messing up the ui
    
    }
    
    
    func _stopSpinnerAndResumeUI() {
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    
    }
    
    
    func displayAlert(title: String, message: String ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil) //yxu?: is self the alert or the LoginViewController??
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
 
    // MARK: call web api
    func callWebAPI(requestParams: [String:AnyObject], curAPIType: APIType, postActionAfterSuccessulReturn: ((data: AnyObject?)->())?, postActionAfterAllReturns: (()->())?, bForLogInOrRegister: Bool = false) {
        
        let curAPI = APICommonPrefix + curAPIType.description
        
        
        if !bForLogInOrRegister {
            let manager = Manager.sharedInstance
            manager.session.configuration.HTTPAdditionalHeaders = [
                "Token": _getUserToken()] //todo: retrive the token and put it in the header
        }
        
        let data = NSJSONSerialization.dataWithJSONObject(requestParams, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        
 
        
        let requestSchedule =  //Alamofire.
            request(.POST, curAPI, parameters: [:], encoding: .Custom({
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

                println((JSON as! NSDictionary)["Error"]!) //yxu: output Chinese: http://stackoverflow.com/questions/26963029/how-can-i-get-the-swift-xcode-console-to-show-chinese-characters-instead-of-unic
                
                let statusCode = (JSON as! NSDictionary)["StatusCode"] as! Int
                if statusCode  == 200 {
                    println("Succeeded in making the api call: " + curAPIType.description )
                    
                    postActionAfterSuccessulReturn?(data: JSON)
                    
                    
                } else {
                    let errStr = (JSON as! NSDictionary)["Error"] as! String
                    self.displayAlert(curAPIType.description + " failed", message: "Status Code = \(statusCode), Error = \(errStr)")
                }
                
                
            } else {
                self.displayAlert( curAPIType.description + " failed", message: error!.description)
            }
            
            
            
            postActionAfterAllReturns?()
            
            
            
        }
        
        
    }
    

    
    
    // refer to: http://stackoverflow.com/questions/26672547/swift-handling-json-with-alamofire-swiftyjson
    // refer to: http://www.raywenderlich.com/82706/working-with-json-in-swift-tutorial
    func _parseJsonForBabyInfoArray(result: JSON) {
        
        if let babyInformationArray = result["BabyList"].array {
            
            var kids = [BabyInfo]()
            
            for babyInformation in babyInformationArray {
                
                var kidId: Int = babyInformation["Id"].int!
                var kidName: String = babyInformation["BabyName"].string!
                var kidNickName: String = babyInformation["Nickname"].string!
                var kidSex: Int = babyInformation["Sex"].string?.toInt() ?? 0
                var headImg = babyInformation["HeadImg"].string ?? ""
                var headImgPath = babyInformation["HeadImgpath"].string ?? ""
                
                //let headImg = "302bf297-6646-4945-8867-d0ed17c7c111.jpg";
                //var headImgPath = "~/Uploads/000014FilePath/";
                // http://www.babysaga.cn/Uploads/000014FilePath/302bf297-6646-4945-8867-d0ed17c7c111.jpg
                let range = headImgPath.startIndex ..< advance(headImgPath.startIndex, 2)
                headImgPath.removeRange(range)
                
                
                println("\(headImg.pathExtension)")
                var bValidImageExtension = true
                if headImg.pathExtension == "" {
                    bValidImageExtension = false
                }
                
                let url = NSURL(string: headImgPath + headImg, relativeToURL: baseURL )
                
                var newKid = BabyInfo(babyName: kidName, nickName: kidNickName, sex: kidSex, id: kidId, imageURL: url!, validImageExtension: bValidImageExtension)
                kids.append(newKid)
            }
            
            _babyInfoArray = kids
        }
        
        // TODO: caching
        
    }
    
    
    
    let pendingOperations = PendingOperations()
    
    func _startDownloadForImage(babyInfo: BabyInfo, indexPath: NSIndexPath, UpdataUI: ()->() ){
        
        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ImageDownloader(babyInfo: babyInfo)
        
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                //self.classCollectionView.reloadItemsAtIndexPaths([indexPath])
                UpdataUI()
            })
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    
    
    
    
}

