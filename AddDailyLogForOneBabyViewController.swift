//
//  AddDailyLogForOneBabyViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/8/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit


//yxu: delegate to pass the date picked from calendar, back to table view
protocol UploadLogForOneBabyDelegate {
    func uploadLogItemForOneBaby(activityItem: DailyLogItem, extraInfo: DailyLogItem_ExtraInfoForBaby)
    
}



class AddDailyLogForOneBabyViewController: AddDailyLogViewController, FloatRatingViewDelegate {

    var _babyId = 0
    
    var delegatePerBaby: UploadLogForOneBabyDelegate!
    
    var _numStars = 0
    
    
    @IBOutlet weak var starRatingVIew: FloatRatingView!
    
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        if segue.identifier == "showStarRatintgView" //yxu: defined in segue property in Storyboard
        {
            let babyStarVC = segue.destinationViewController as! BabyStarViewController
            babyStarVC.initStarsArray(_babyInfoArray.count, namesForKids: _namesForKids)
            babyStarVC.delegate = self
        }
*/
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    @IBAction func confirmButtonTapped(sender: AnyObject) {
        println("uploading log ")
        
        println("activity = \(activityTypeTextField.text), id = \(activityId) \n\n")
        
        
        // todo: add sanity check:  end time > start time etc
        //   show an alert view if error detected
        
        let activityItem = DailyLogItem(uniqueId: 0, activityType: activityId, content: contentTextView.text, startTime: startTime, endTime: endTime)
        
        //?? TODO: babyId??
        let extraInfo = DailyLogItem_ExtraInfoForBaby(stars: _numStars, babyId: _babyId, classId: 0, creatorId: 0, picCount: 0, picPaths: nil)
        
        delegatePerBaby?.uploadLogItemForOneBaby(activityItem, extraInfo: extraInfo)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        starRatingVIew.delegate = self
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
    
    
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        _numStars = Int(rating) // TODO: the ! may be dangerous
    }


}
