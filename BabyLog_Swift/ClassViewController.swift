//
//  ClassViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/3/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit
import Alamofire

class ClassViewController: UIViewController, UICollectionViewDelegate //, UICollectionViewDataSource
{

    @IBOutlet weak var classCollectionView: UICollectionView!
    var activityIndicator:UIActivityIndicatorView!
    
    let resueIdentifier = "studentCell"
    let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    
    var _babyInfoArray = [BabyInfo]()
    
    
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

        // Do any additional setup after loading the view.
        
        // set up spinner
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
        // set up table view
        classCollectionView.delegate = self
        //classCollectionView.dataSource = self
        
        // retrieve the students for current class
        _retrieveAllStudentsInClass()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: call web api
    
    func _retrieveAllStudentsInClass() {
        
        _startSpinnerAndBlockUI()
       
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            userTokenStringInHttpHeader: _getUserToken()]
 
        let requestSchedule =  Alamofire.request(.POST, "http://www.babysaga.cn/app/service?method=user.ListClassBaby", parameters: [:], encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
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
                        
                        self._parseJsonForBabyInfoArray(jsonResult)
                        
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
                
                self.classCollectionView.reloadData() //yxu: reloadData must be called on main thread. otherwise it does not work!!!
                
                println("updating the collection view")
                // resume the UI at the end of async action
                
                self._stopSpinnerAndResumeUI()
                
            }

            
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

                var newKid = BabyInfo(babyName: kidName, nickName: kidNickName, sex: kidSex, id: kidId)
                kids.append(newKid)
            }

            _babyInfoArray = kids
        }
        
        // TODO: caching
        
    }
    
    
    
    

}
