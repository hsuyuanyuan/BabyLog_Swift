//
//  AddDailyLogPerBabyViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/5/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

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
    var _activityStr: String?
    var _startTime: String?
    var _endTime: String?
    var _contentStr: String?
    
    func initActivityInternalInfo(activityStr: String?, startTime: String, endTime: String, contentStr: String?) {
        _activityStr = activityStr
        _startTime = startTime
        _endTime = endTime
        _contentStr = contentStr
    }
    
    
    func initActivityDisplayInfo() {
        activityTypeTextField.text = _activityStr
        startTimeTextField.text = _startTime
        endTimeTextField.text = _endTime
        contentTextView.text = _contentStr
    }
    
    
    @IBAction func confirmButtonTapped(sender: AnyObject) {
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
    
}
