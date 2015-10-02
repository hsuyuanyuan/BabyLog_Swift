//
//  AddDailyLogForOneBabyViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/8/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit



protocol UploadLogForOneBabyDelegate {
    func uploadLogItemForOneBaby(activityItem: DailyLogItem, extraInfo: DailyLogItem_ExtraInfoForBaby)
    
}



class AddDailyLogForOneBabyViewController: AddDailyLogViewController, FloatRatingViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DKImagePickerControllerDelegate {

    
    
    @IBOutlet weak var dailyLogOneBabyContainerView: UIView!
    
    var _babyId = 0
    
    var delegatePerBaby: UploadLogForOneBabyDelegate!
    
    var _numStars = Int(defaultNumStars)
    

    
    
    @IBOutlet weak var starRatingVIew: FloatRatingView!

    
    
    @IBAction func confirmButtonTapped(sender: AnyObject) {
        println("uploading log ")
        
        println("activity = \(activityTypeTextField.text), id = \(activityId) \n\n")
        
        
        // todo: add sanity check:  end time > start time etc
        //   show an alert view if error detected
        
        let activityItem = DailyLogItem(uniqueId: 0, activityType: activityId, content: contentTextView.text, startTime: startTime, endTime: endTime)
        
        let extraInfo = DailyLogItem_ExtraInfoForBaby(stars: _numStars, babyId: _babyId, classId: 0, creatorId: 0, picCount: 0, picPaths: nil, images: _imageList)
        
        delegatePerBaby?.uploadLogItemForOneBaby(activityItem, extraInfo: extraInfo)
        
        navigationController?.popViewControllerAnimated(true)
        //dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        var scaleX:CGFloat = view.frame.width / dailyLogOneBabyContainerView.frame.width
        
        var scaleY:CGFloat = (view.frame.height - 44 - 20 - 49) / dailyLogOneBabyContainerView.frame.height
        
        println("view width = \(dailyLogOneBabyContainerView.frame.width), view height = \( dailyLogOneBabyContainerView.frame.height)" )
        println("super view width = \(view.frame.width), super view height = \( view.frame.height)" )
        
        
        /*
        http://stackoverflow.com/questions/30503254/get-frame-height-without-navigation-bar-height-and-tab-bar-height-in-deeper-view
        
        */
        
        var scale: CGFloat =   min(scaleX, scaleY)
        
        var t: CGAffineTransform = CGAffineTransformMakeScale(scale, scale)
        
        var translateX = ( dailyLogOneBabyContainerView.frame.width ) * (scale - 1) / 2 / scale;
        if ( dailyLogOneBabyContainerView.frame.height > view.frame.height  ) // for 4s: 320* 480, while dailyLogOneBabyContainerView is 340 * 540
        {
            translateX += 40
        }
        
        var translateY = dailyLogOneBabyContainerView.frame.height * (scale - 1) / 2 / scale;
        
        
        t = CGAffineTransformTranslate(t, translateX, translateY)
        
        dailyLogOneBabyContainerView.transform = t
        
        dailyLogOneBabyContainerView.frame = view.bounds
        
        dailyLogOneBabyContainerView.setNeedsLayout()
        
        
        
        
        // Do any additional setup after loading the view.
        starRatingVIew.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: delegate for image picker view
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)

        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            _imageList.append( pickedImage )

        }

        
    }
    
    
    @IBAction func chooseImageButtonTapped(sender: AnyObject)  {
        /*
        var imagePickerView = UIImagePickerController()
        imagePickerView.allowsEditing = false
        imagePickerView.delegate = self //yxu: Note: this needs two delegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate
        //imagePickerView.sourceType
        
        presentViewController(imagePickerView, animated: true, completion: nil)
        */
        
        // multiple image picker
        let imagePicker = DKImagePickerController()
        
        imagePicker.pickerDelegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerCancelled() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidSelectedAssets(assets: [DKAsset]!) {
        for (index, asset) in enumerate(assets) {

            if let fullImage = asset.fullResolutionImage {
                _imageList.append( fullImage )
            }
 
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        _numStars = Int(rating) // TODO: the ! may be dangerous
    }


}
