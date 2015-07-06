//
//  AddDailyLogPerBabyViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/5/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit
import Alamofire

class AddDailyLogPerBabyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SaveStartsForKidsDelegate  {

    // MARK: data arrays for baby info
    
    var _idsForKids:[Int]?
    var _starsForKids:[Float]?
    var _namesForKids:[String]?
    
    
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
    
    
    
    // MARK: controls
    
    
    @IBOutlet weak var activityTypeTextField: UITextField!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    //Note, in prepareForSegue, cannot access those IBoutlet weak var, which leads to crash
    // therefore, use the following internal variables to be set from prepareForSegue
    
    var _curDailyLog = DailyLogItem(uniqueId: 0, activityType: activityIdMin, content: "", startTime: "", endTime: "")
    
    func initActivityInternalInfo(curDailyLog: DailyLogItem) {

        _curDailyLog = curDailyLog
    }
    
    
    func initActivityDisplayInfo() {
        activityTypeTextField.text = activityTypeDictionary[_curDailyLog.activityType]?.name
        startTimeTextField.text = _curDailyLog.startTime
        endTimeTextField.text = _curDailyLog.endTime
        contentTextView.text = _curDailyLog.content
    }
    
    
    @IBAction func confirmButtonTapped(sender: AnyObject) {
        _uploadCompletedDailyLog()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func chooseImageButtonTapped(sender: AnyObject)  {
        var imagePickerView = UIImagePickerController()
        imagePickerView.allowsEditing = false
        imagePickerView.delegate = self //yxu: Note: this needs two delegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate
        //imagePickerView.sourceType
        
        presentViewController(imagePickerView, animated: true, completion: nil)
        
        
    }
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initArraysForKids(_babyInfoArray.count)
        initActivityDisplayInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
   
    
    
    // MARK: delegate for image picker view
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        
        
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // imageView.contentMode = .ScaleAspectFit
            // imageView.image = pickedImage
        }
        
        //?? todo: get file name for the image??
        let imageURL = info[UIImagePickerControllerReferenceURL] as? NSURL
        
    }

    
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
        
        
        
        
        var requestParams : [String:AnyObject] = [
            "Id": _curDailyLog.activityType,
            "StartTime":_curDailyLog.startTime, //"08:00",
            "EndTime":_curDailyLog.endTime, //"09:30",
            "Rand": "",
            "BabyId": idString, // baby ids separated by ,
            "PicList": "",
            "Content": _curDailyLog.content,
            "UploadPic": "",//?? how to use? is it pic name
            "Stars": starString // stars separated by ,
        ]
        
        
        let manager = Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Token": _getUserToken()] //todo: retrive the token and put it in the header
        
        
        let data = NSJSONSerialization.dataWithJSONObject(requestParams, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        
        let requestSchedule =  Alamofire.request(.POST, "http://www.babysaga.cn/app/service?method=ClassSchedule.CompleteSchedule", parameters: [:], encoding: .Custom({
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
                self.displayAlert("Login failed", message: error!.description)
            }
            
            
        }
        
    }
 
    
    
}
