//
//  AddDailyLogPerBabyViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/5/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit
// import Alamofire  // To support iOS 7.0, followed Mattt's instruction: https://github.com/Alamofire/Alamofire/commit/8e2e5251144a7792e8358e8ff9326bb7aa71ab7a
import AssetsLibrary


class AddDailyLogPerBabyViewController: AddDailyLogViewController, SaveStartsForKidsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    // MARK: data arrays for baby info
    
    @IBOutlet weak var dailyLogPerBabyContainerView: UIView!

    var _idsForKids:[Int]?
    var _starsForKids:[Float]?
    var _namesForKids:[String]?
    
    //Note, in prepareForSegue, cannot access those IBoutlet weak var, which leads to crash
    // therefore, use the following internal variables to be set from prepareForSegue
    
    var _curDailyLog = DailyLogItem(uniqueId: 0, activityType: activityIdMin, content: "", startTime: "", endTime: "")
    
    
    
    func initArraysForKids(arraySize: Int) {
        _idsForKids = [Int](count: arraySize, repeatedValue: 0)
        _namesForKids = [String](count: arraySize, repeatedValue: "__")
        
        if _idsForKids?.count > 0 {
            for index in 0 ..< _idsForKids!.count {
                _idsForKids![index] = _babyInfoArray[index].id
                _namesForKids![index] = _babyInfoArray[index].nickName
            }
        
        }
      
        _starsForKids = [Float](count: arraySize, repeatedValue: 0.0)

    }
    
    
    
    // MARK: delegate for image picker view
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    // MARK: controls
 
    func initActivityInternalInfo(curDailyLog: DailyLogItem) {

        _curDailyLog = curDailyLog
    }
    
    
    func initActivityDisplayInfo() {
        activityTypeTextField.text = activityTypeDictionary[_curDailyLog.activityType]?.name
        startTimeTextField.text = _curDailyLog.startTime
        endTimeTextField.text = _curDailyLog.endTime
        contentTextView.text = _curDailyLog.content
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let scaleX:CGFloat = view.frame.width / dailyLogPerBabyContainerView.frame.width
        
        let scaleY:CGFloat = (view.frame.height - 44 - 20 - 49) / dailyLogPerBabyContainerView.frame.height
        
        print("view width = \(dailyLogPerBabyContainerView.frame.width), view height = \( dailyLogPerBabyContainerView.frame.height)" )
        print("super view width = \(view.frame.width), super view height = \( view.frame.height)" )
        
        
        /*
        http://stackoverflow.com/questions/30503254/get-frame-height-without-navigation-bar-height-and-tab-bar-height-in-deeper-view
        
        */
        
        let scale: CGFloat =   min(scaleX, scaleY)
        
        var t: CGAffineTransform = CGAffineTransformMakeScale(scale, scale)
        
        var translateX = ( dailyLogPerBabyContainerView.frame.width ) * (scale - 1) / 2 / scale;
        if ( dailyLogPerBabyContainerView.frame.height > view.frame.height  ) // for 4s: 320* 480, while teacherContainerView is 340 * 540
        {
            translateX += 40
        }
        
        let translateY = dailyLogPerBabyContainerView.frame.height * (scale - 1) / 2 / scale;
        
        
        t = CGAffineTransformTranslate(t, translateX, translateY)
        
        dailyLogPerBabyContainerView.transform = t
        
        dailyLogPerBabyContainerView.frame = view.bounds
        
        dailyLogPerBabyContainerView.setNeedsLayout()
        
        
        
        
        
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
                
            }
            }, postActionAfterAllReturns: { () -> () in
 
                    
                    // Do any additional setup after loading the view.
                    self.initArraysForKids(_babyInfoArray.count)
                    self.initActivityDisplayInfo()
                    
                    self._stopSpinnerAndResumeUI()
 
        })
        
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showStarRatintgView" //yxu: defined in segue property in Storyboard
        {
            let babyStarVC = segue.destinationViewController as! BabyStarViewController
            babyStarVC.initStarsArray(_babyInfoArray.count, namesForKids: _namesForKids)
            babyStarVC.delegate = self
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
 
    @IBAction func confirmButtonTapped(sender: AnyObject) {
        _uploadCompletedDailyLog()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func chooseImageButtonTapped(sender: AnyObject)  {
        /*
        var imagePickerView = UIImagePickerController()
        imagePickerView.allowsEditing = false
        imagePickerView.delegate = self //yxu: Note: this needs two delegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate
        //imagePickerView.sourceType
        
        presentViewController(imagePickerView, animated: true, completion: nil)
        */
        
        /*
        // multiple image picker
        let imagePicker = DKImagePickerController()

        imagePicker.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
        }
        presentViewController(imagePicker, animated: true, completion: nil)
        */
        
    }

    func imagePickerControllerCancelled() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    func imagePickerControllerDidSelectedAssets(assets: [DKAsset]!) {
        for (index, asset) in assets.enumerate() {
            if let fullImage = asset.fullResolutionImage {
                _imageList.append( fullImage )
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    */
    
    // MARK: delegate for saving star ratings
    func saveStartsForKids(starsForKids: [Float]?) {
        _starsForKids = starsForKids
    }
    
    
    
    // MARK: call web api
    func _uploadCompletedDailyLog() {
        
        if _idsForKids == nil || _starsForKids == nil
        {
            return
        }
        
        if _idsForKids!.count != _starsForKids!.count ||
        _idsForKids!.count == 0 ||
        _starsForKids!.count == 0
        {
            return
        }
        
        
        var idString = String(_idsForKids![0])
        var starString = String(Int(_starsForKids![0]))
        
        for index in 1 ..< _idsForKids!.count {
            idString += ","
            idString += String( _idsForKids![index] )
            
            starString += ","
            starString += String(Int(_starsForKids![index]))
        }
        
        
        // convert images to base64 string
        var imageBase64StrList = [String]()
        
 
        for image in _imageList {
            var imageData = image.mediumQualityJPEGNSData
            if imageData.length > defaultUploadImageSizeLimit {
                imageData = image.lowQualityJPEGNSData
            }
            
            print("image size: \(imageData.length)") // ~100k
            
            let base64Str = imageData.base64EncodedStringWithOptions( NSDataBase64EncodingOptions() )
            //refer here for size on disk and size in mem:
            // http://stackoverflow.com/questions/15656403/inaccurate-nsdata-size-given-in-bytes
            
            imageBase64StrList.append(base64Str)
        }
 
        
        
        
        let requestParams : [String:AnyObject] = [
            "Id": _curDailyLog.uniqueId,
            "StartTime":_curDailyLog.startTime, //"08:00",
            "EndTime":_curDailyLog.endTime, //"09:30",
            "Rand": "",
            "BabyId": idString, // baby ids separated by ,
            "UploadPic": imageBase64StrList,
            "Content": _curDailyLog.content,
            "Stars": starString // stars separated by ,
        ]
        
        print("\(requestParams.description)")
        
        
        callWebAPI(requestParams, curAPIType: APIType.UploadCompleteStatusWithStars, postActionAfterSuccessulReturn: nil, postActionAfterAllReturns: nil)
        

        
    }
 
    
    
}
