//
//  AddLogItemViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/27/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit
import Alamofire


//yxu: delegate to pass the date picked from calendar, back to table view
protocol UploadLogDelegate {
    func uploadLogItem(activityId: Int)
}

class AddLogItemViewController: UIViewController {
    
    
    var delegate: UploadLogDelegate!
    
    var label:UILabel!
    var activityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // add label
        label = UILabel()
        // yxu: Rect: top left corner: relative to Father view's top left corder
        label.frame = CGRectMake(10, 70, 100, 20)
        label.backgroundColor = UIColor.cyanColor()
        label.text = "activity"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(16.0)
        view.addSubview(label)
        
        
        // add text field
        activityTextField = UITextField()
        activityTextField.frame = CGRectMake(110, 70, 100, 20)
        activityTextField.borderStyle = UITextBorderStyle.RoundedRect
        activityTextField.placeholder = "enter text";
        view.addSubview(activityTextField)
        
        
        // add button
        var button = UIButton()
        button.frame = CGRectMake(label.frame.minX, 300, 60, 20 )
        button.backgroundColor = UIColor.redColor()
        button.setTitle("Upload", forState: UIControlState.Normal)
        button.setTitle("Uploading", forState: UIControlState.Highlighted)
        button.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.greenColor(), forState: UIControlState.Highlighted)
        button.layer.cornerRadius = 10.0 //yxu: change to round cornered
        
        //yxu: add ":" at the end to change the function signature to use Sender as the first parameter
        button.addTarget(self, action: "uploadButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(button)
        
        
    }
    
    // target for Upload button
    func uploadButtonPressed() {
        println("activity = \(activityTextField.text) \n\n")
 
        let activityId = activityTextField.text.toInt()
        
        delegate?.uploadLogItem(activityId ?? 0)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    

}
