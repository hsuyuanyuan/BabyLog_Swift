//
//  AddDailyLogViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/27/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class AddDailyLogViewController: UIViewController {

    
    @IBOutlet weak var activityType: UITextField!
    
    
    @IBOutlet weak var startTime: UITextField!
    
    
    @IBOutlet weak var endTime: UITextField!
    
    var delegate: UploadLogDelegate!
    
    
    @IBAction func uploadLog(sender: UIButton) {
        println("uploading log ")
        
        
        println("activity = \(activityType.text) \n\n")
        
        let activityId = activityType.text.toInt()
        
        delegate?.uploadLogItem(activityId ?? 0)
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /* //yxu: test: this VC already defined in storyboard, but can also be further customized by code here, for example, add a button
        var label = UILabel()
        // yxu: Rect: top left corner: relative to Father view's top left corder
        label.frame = CGRectMake(50, 50, 200, 200)
        label.backgroundColor = UIColor.cyanColor()
        label.text = "Hwllo World"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(16.0)
        
        view.addSubview(label)
        */


    }
    
    
}



/* //sample code
These methods might come in handy to update your view:

[self.view setNeedsLayout];
[self.view setNeedsUpdateConstraints];
[self.view setNeedsDisplay];

*/
        