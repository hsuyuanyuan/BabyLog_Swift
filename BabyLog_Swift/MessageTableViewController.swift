//
//  MessageTableViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/16/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class MessageTableViewController: UIViewControllerForWebAPI, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        if _babyInfoArray.count == 0 {
            
            _retrieveAllStudentsInClass()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func _retrieveAllStudentsInClass() {
        
        _startSpinnerAndBlockUI()
        
        
        callWebAPI([:], curAPIType: APIType.ListAllBabiesInClass, postActionAfterSuccessulReturn: { (data) -> () in
            // refer to: https://grokswift.com/rest-with-alamofire-swiftyjson/
            if let data: AnyObject = data { //yxu: check if data is nil
                let jsonResult = JSON(data)
                
                self._parseJsonForBabyInfoArray(jsonResult)
                
                self.messageTableView.reloadData()
                
            }
            }, postActionAfterAllReturns: { () -> () in
                
 
                
                self._stopSpinnerAndResumeUI()
                
                
                
        })
        
        
    }
    
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _babyInfoArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell") as! MessageTableViewCell
        
        let babyInfo = _babyInfoArray[indexPath.row]
        
        cell.iconImageView.image = babyInfo.image
        cell.babyNameLabel.text = babyInfo.nickName
        
        
        switch (babyInfo.imageState) {
            //case .Failed, .Downloaded:
            //_stopSpinnerAndResumeUI()
        case .New :
            //_startSpinnerAndBlockUI()
            _startDownloadForImage(babyInfo, indexPath: indexPath) {
               self.messageTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
 
            }
        default:
            break
        }
        
        
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}
