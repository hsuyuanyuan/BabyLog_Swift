//
//  DeselectBabyViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 8/13/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class DeselectBabyViewController: UIViewControllerForWebAPI, UIPickerViewDataSource, UIPickerViewDelegate  {

    var babyPicker = UIPickerView()
    var babyId:Int = 0
    
    
    @IBOutlet weak var chooseBabyTextField: UITextField!
  
    
    
    @IBAction func confirmButtonTapped(sender: UIButton) {
        //_deselectBabyFromClass()
        
 
        navigationController?.popViewControllerAnimated(true)
        
    }
 

    
    func _deselectBabyFromClass() {

        _startSpinnerAndBlockUI()
        
        var requestParams : [String:AnyObject] = [
            "BabyId": babyId

        ]
        
        
        callWebAPI(requestParams, curAPIType: APIType.UserOutClassBaby, postActionAfterSuccessulReturn: nil, postActionAfterAllReturns: { () -> () in
            
            // TODO: Remove the baby info from the local array
            self._retrieveAllStudentsInClass()
            
            // Make sure we are on the main thread, and update the UI.
            dispatch_async(dispatch_get_main_queue()) { //sync or async
                // update some UI
                
                
                
                
                // resume the UI at the end of async action
                
                self._stopSpinnerAndResumeUI()
                
            }
        })
        
        
    }
    
    
    func _retrieveAllStudentsInClass() {
        
        _startSpinnerAndBlockUI()
        
        
        callWebAPI([:], curAPIType: APIType.ListAllBabiesInClass, postActionAfterSuccessulReturn: { (data) -> () in
            // refer to: https://grokswift.com/rest-with-alamofire-swiftyjson/
            if let data: AnyObject = data { //yxu: check if data is nil
                let jsonResult = JSON(data)
                
                self._parseJsonForBabyInfoArray(jsonResult)
                
                self.chooseBabyTextField.text = _babyInfoArray[0].nickName
                
            }
            }, postActionAfterAllReturns: { () -> () in
                
                
                
                self._stopSpinnerAndResumeUI()
                
                
                
        })
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad() // note: forgot to call this => crash, because activityIndicator not shown
        
        chooseBabyTextField.inputView = babyPicker
        
        if (_babyInfoArray.count == 0 ) {
            
            _retrieveAllStudentsInClass()
        }
        

        
        babyPicker.delegate = self
        babyPicker.dataSource = self
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    // picker view
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _babyInfoArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        babyId = _babyInfoArray[row].id
        return _babyInfoArray[row].nickName
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chooseBabyTextField.text = _babyInfoArray[row].nickName
        babyId = _babyInfoArray[row].id
        
        babyPicker.resignFirstResponder()
    }
    
    
}
