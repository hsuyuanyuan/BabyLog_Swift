//
//  ClassViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/3/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit
// import Alamofire // // To support iOS 7.0, followed Mattt's instruction: https://github.com/Alamofire/Alamofire/commit/8e2e5251144a7792e8358e8ff9326bb7aa71ab7a


//refer to collection view tutorial:
// http://www.raywenderlich.com/78550/beginning-ios-collection-views-swift-part-1

class ClassViewController: UIViewControllerForWebAPI, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout, SetInAndOutTimeDelegate // UICollectionViewDelegate
{

    @IBOutlet weak var classCollectionView: UICollectionView!
 
    
    let reuseIdentifier = "babyInfoCell"
    let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    

    
    var _BabyInAndOutTimeList = [BabyInAndOutTime]()
    
 
    
    // MARK: view management
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // set up collection view
        //classCollectionView.delegate = self
        classCollectionView.dataSource = self
        classCollectionView.backgroundColor = UIColor.whiteColor()
        
        
        
        // retrieve the students for current class
        _retrieveAllStudentsAndRetrieveInAndOutTime()
        
        // refer to: http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: call web api
    func _retrieveAllStudentsAndRetrieveInAndOutTime() {
        
        _startSpinnerAndBlockUI()
        
        
        callWebAPI([:], curAPIType: APIType.ListAllBabiesInClass, postActionAfterSuccessulReturn: { (data) -> () in
                // refer to: https://grokswift.com/rest-with-alamofire-swiftyjson/
                if let data: AnyObject = data { //yxu: check if data is nil
                    
                    let jsonResult = JSON(data)
                    
                    self._parseJsonForBabyInfoArray(jsonResult)
                    
                    self._retrieveExistingInAndOutTime()
                    
                }
            }, postActionAfterAllReturns: { () -> () in
 
                    
                    self._stopSpinnerAndResumeUI()
 
        })
    }
    
    
    
    
    func _retrieveExistingInAndOutTime() {
        
        let curDate = NSDate()
        let strCurDate = curDate.formattedYYYYMMDD
        
 
        var requestParams : [String:AnyObject] = [ //todo: add sanity check for the date string
            "day": strCurDate
        ]
        
        _startSpinnerAndBlockUI()
        callWebAPI(requestParams, curAPIType: APIType.ListAllBabiesInAndOutTime, postActionAfterSuccessulReturn: { (data) -> () in
                if let data: AnyObject = data { //yxu: check if data is nil
                    let jsonResult = JSON(data)
                    
                     self._parseJsonForExistingInAndOutTime(jsonResult)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.classCollectionView.reloadData() //yxu: Note: not working property. Must use main queue
                    }
                }
            
            
            
            
            }, postActionAfterAllReturns: { () -> () in

                self._stopSpinnerAndResumeUI()
                
                
        } )
        
    }
    
    /*
    Babyid = 14;
    Babyname = "\U59dc\U660e\U5e0c";
    Day = "2015-07-15";
    Img = "http://www.babysaga.cn/Uploads/000014FilePath/9d3e5491-bf2a-4545-9ee8-7544357102c6.jpg";
    Intime = "\U5230\U6821\U65f6\U95f4";
    Outtime = "\U79bb\U6821\U65f6\U95f4";

    */
    
    
    func _parseJsonForExistingInAndOutTime(result: JSON) {
        
        if let InAndOutTimeArray = result["list"].array {
            
            var BabyInAndOutTimeList = [BabyInAndOutTime]()
            
            for InAndOutTime in InAndOutTimeArray {
                
                var kidId: Int = InAndOutTime["Babyid"].int!
                var kidName: String = InAndOutTime["Babyname"].string ?? ""
                var kidImgPath: String = InAndOutTime["Img"].string ?? ""
                var kidInTime: String =  InAndOutTime["Intime"].string ?? ""
                var kidOutTime: String = InAndOutTime["Outtime"].string ?? ""

                
                var newInAndOutTime = BabyInAndOutTime(id: kidId, babyName: kidName, imgPath: kidImgPath, inTime: kidInTime, outTime: kidOutTime)
                
                BabyInAndOutTimeList.append(newInAndOutTime)
            }
            
            _BabyInAndOutTimeList = BabyInAndOutTimeList
        }
        
        
        
    }
    
    
    
    
    // MARK: delegate for data source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1 // only 1 section => 1 class per teacher account
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _babyInfoArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ClassBabyInfoCollectionViewCell
        
        // delegate
        cell.delegate = self
        
        // visuals
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 2.0
        
        // image downloading
        let babyInfo = _babyInfoArray[indexPath.row]
        
        //cell.babyImageView.image = babyInfo.image
        cell.babyImageButton.setBackgroundImage( babyInfo.image, forState: UIControlState.Normal) //yxu: tried setImage first. not working, show blue block
        cell._babyId = babyInfo.id
        cell._row = indexPath.row
        
        if _BabyInAndOutTimeList.count > indexPath.row {
            
            let inAndOutTime =  _BabyInAndOutTimeList[indexPath.row]
        
            //TODO: verify inAndOutTime.id == babyInfo.id
            

                if inAndOutTime.inTime == "" {
                    cell.arriveTime = defaultStringForInTime
                } else {
                    cell.arriveTime = inAndOutTime.inTime
                }
                // cell.arriveTimeButton?.sendActionsForControlEvents(UIControlEvents.TouchUpInside) // refer to: http://stackoverflow.com/questions/27413059/how-can-i-simulate-a-button-press-in-swift-ios8-using-code
 
            
 
                if inAndOutTime.outTime == "" {
                    cell.leaveTime = defaultStringForOutTime
                } else {
                    cell.leaveTime = inAndOutTime.outTime
                }
                // cell.leaveTimeButton?.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
 
        }
    
        

        switch (babyInfo.imageState) {
        //case .Failed, .Downloaded:
            //_stopSpinnerAndResumeUI()
        case .New :
            //_startSpinnerAndBlockUI()
            _startDownloadForImage(babyInfo, indexPath: indexPath) {
                self.classCollectionView.reloadItemsAtIndexPaths([indexPath])
            }
            
 
            
        default:
            break
        }
        
        
        return cell
    }
    
    

    
    
    
    // MARK: delegate for layout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }


    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDailyLogForOneBaby" //yxu: defined in segue property in Storyboard
        {
            let logForBabyVC = segue.destinationViewController as! LogTabForOneBabyViewController
            let babyButton = sender as! UIButton
            logForBabyVC._babyId = babyButton.tag
        }
    }
    
    
    func SetInAndOutTime(babyId: Int, time: String, inOutType: InOutType, row: Int) {
   
        
        var requestParams : [String:AnyObject] = [ //todo: add sanity check for the date string
            "BabyId": babyId,
            "Time": time,
            "InputType": inOutType.rawValue // convert enum to Int
        ]
        
        callWebAPI(requestParams, curAPIType: APIType.SetInAndOutTimeForOneBaby, postActionAfterSuccessulReturn: { (data) -> () in
                var indexPath = NSIndexPath(forItem: row, inSection: 0)
            
                // update local data
                let prevInOutTime = self._BabyInAndOutTimeList[row]
                if inOutType == InOutType.Arrival {
                    let newInOutTime = BabyInAndOutTime(id: prevInOutTime.id, babyName: prevInOutTime.babyName, imgPath: prevInOutTime.imgPath, inTime: time, outTime: prevInOutTime.outTime)
                    
                    self._BabyInAndOutTimeList[row] = newInOutTime
                } else  {
                    let newInOutTime = BabyInAndOutTime(id: prevInOutTime.id, babyName: prevInOutTime.babyName, imgPath: prevInOutTime.imgPath, inTime: prevInOutTime.inTime, outTime: time)
                    
                    self._BabyInAndOutTimeList[row] = newInOutTime
                }
            
                self.classCollectionView.reloadItemsAtIndexPaths( [indexPath] ) //reloadItemsAtIndexPaths  indexPathsForVisibleItems
            
            }, postActionAfterAllReturns: { () -> () in
                
                
        } )
        
        
        
        
    }
    
}
