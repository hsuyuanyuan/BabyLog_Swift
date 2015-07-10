//
//  ClassViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/3/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit
import Alamofire


//refer to collection view tutorial:
// http://www.raywenderlich.com/78550/beginning-ios-collection-views-swift-part-1

class ClassViewController: UIViewControllerForWebAPI, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout // UICollectionViewDelegate
{

    @IBOutlet weak var classCollectionView: UICollectionView!
 
    
    let reuseIdentifier = "babyInfoCell"
    let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    
    let pendingOperations = PendingOperations()
    
 
    
    // MARK: view management
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // set up collection view
        //classCollectionView.delegate = self
        classCollectionView.dataSource = self
        classCollectionView.backgroundColor = UIColor.whiteColor()
        // retrieve the students for current class
        _retrieveAllStudentsInClass()
        
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
    
    func _retrieveAllStudentsInClass() {
        
        _startSpinnerAndBlockUI()
       
        
        callWebAPI([:], curAPIType: APIType.ListAllBabiesInClass, postActionAfterSuccessulReturn: { (data) -> () in
            // refer to: https://grokswift.com/rest-with-alamofire-swiftyjson/
            if let data: AnyObject = data { //yxu: check if data is nil
                let jsonResult = JSON(data)
                
                ClassViewController._parseJsonForBabyInfoArray(jsonResult)
                
            }
        }, postActionAfterAllReturns: { () -> () in
            // Make sure we are on the main thread, and update the UI.
            dispatch_async(dispatch_get_main_queue()) { //sync or async
                // update some UI
                
                self.classCollectionView.reloadData() //yxu: reloadData must be called on main thread. otherwise it does not work!!!
                
                println("updating the collection view")
                // resume the UI at the end of async action
                
                self._stopSpinnerAndResumeUI()
                
            }
        })
        

        
    }
    
    
    // refer to: http://stackoverflow.com/questions/26672547/swift-handling-json-with-alamofire-swiftyjson
    // refer to: http://www.raywenderlich.com/82706/working-with-json-in-swift-tutorial
    class func _parseJsonForBabyInfoArray(result: JSON) {
        
        if let babyInformationArray = result["BabyList"].array {
            
            var kids = [BabyInfo]()
            
            for babyInformation in babyInformationArray {

                var kidId: Int = babyInformation["Id"].int!
                var kidName: String = babyInformation["BabyName"].string!
                var kidNickName: String = babyInformation["Nickname"].string!
                var kidSex: Int = babyInformation["Sex"].string?.toInt() ?? 0
                var headImg = babyInformation["HeadImg"].string ?? ""
                var headImgPath = babyInformation["HeadImgpath"].string ?? ""
                
                //let headImg = "302bf297-6646-4945-8867-d0ed17c7c111.jpg";
                //var headImgPath = "~/Uploads/000014FilePath/";
                // http://www.babysaga.cn/Uploads/000014FilePath/302bf297-6646-4945-8867-d0ed17c7c111.jpg
                let range = headImgPath.startIndex ..< advance(headImgPath.startIndex, 2)
                headImgPath.removeRange(range)
                
                let url = NSURL(string: headImgPath + headImg, relativeToURL: baseURL )
    
                var newKid = BabyInfo(babyName: kidName, nickName: kidNickName, sex: kidSex, id: kidId, imageURL: url!)
                kids.append(newKid)
            }

            _babyInfoArray = kids
        }
        
        // TODO: caching
        
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
        
        cell.backgroundColor = UIColor.whiteColor()

        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 2.0
        
        // image downloading
        let babyInfo = _babyInfoArray[indexPath.row]
        
        //cell.babyImageView.image = babyInfo.image
        cell.babyImageButton.setBackgroundImage( babyInfo.image, forState: UIControlState.Normal) //yxu: tried setImage first. not working, show blue block
        cell.babyImageButton.tag = babyInfo.id
        
        //let imageData = NSData(contentsOfURL: url!)
        //cell.babyImageView.image = UIImage(data:imageData!)

        switch (babyInfo.imageState) {
        //case .Failed, .Downloaded:
            //_stopSpinnerAndResumeUI()
        case .New :
            //_startSpinnerAndBlockUI()
            _startDownloadForImage(babyInfo, indexPath: indexPath)
        default:
            break
        }
        
        
        return cell
    }
    
    
    func _startDownloadForImage(babyInfo: BabyInfo, indexPath: NSIndexPath){

        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ImageDownloader(babyInfo: babyInfo)
        
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.classCollectionView.reloadItemsAtIndexPaths([indexPath])
            })
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        
        pendingOperations.downloadQueue.addOperation(downloader)
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
    
}
