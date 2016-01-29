//
//  BabyStarViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/5/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit


protocol SaveStartsForKidsDelegate {
    func saveStartsForKids(starsForKids: [Float]?)
}


class BabyStarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FloatRatingViewDelegate {

    @IBOutlet weak var babyStartContainerView: UIView!

    var _starsForKids: [Float]?
    var _namesForKids: [String]?
    
    @IBOutlet weak var starTableView: UITableView!
    
    var delegate: SaveStartsForKidsDelegate?
    
    func initStarsArray(numKids: Int, namesForKids: [String]? ) {
        _starsForKids = [Float](count: numKids, repeatedValue: defaultNumStars)
        _namesForKids = namesForKids // passed from the presenter view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scaleX:CGFloat = view.frame.width / babyStartContainerView.frame.width
        
        let scaleY:CGFloat = (view.frame.height - 44 - 20 - 49) / babyStartContainerView.frame.height
        
        print("view width = \(babyStartContainerView.frame.width), view height = \( babyStartContainerView.frame.height)" )
        print("super view width = \(view.frame.width), super view height = \( view.frame.height)" )
        
        
        /*
        http://stackoverflow.com/questions/30503254/get-frame-height-without-navigation-bar-height-and-tab-bar-height-in-deeper-view
        
        */
        
        let scale: CGFloat =   min(scaleX, scaleY)
        
        var t: CGAffineTransform = CGAffineTransformMakeScale(scale, scale)
        
        var translateX = ( babyStartContainerView.frame.width ) * (scale - 1) / 2 / scale;
        if ( babyStartContainerView.frame.height > view.frame.height  ) // for 4s: 320* 480, while teacherContainerView is 340 * 540
        {
            translateX += 40
        }
        
        let translateY = babyStartContainerView.frame.height * (scale - 1) / 2 / scale;
        
        
        t = CGAffineTransformTranslate(t, translateX, translateY)
        
        babyStartContainerView.transform = t
        
        babyStartContainerView.frame = view.bounds
        
        babyStartContainerView.setNeedsLayout()
        
        
        
        // Do any additional setup after loading the view.
        starTableView.delegate = self
        starTableView.dataSource = self
        
        
        starTableView.tableFooterView = UIView() //yxu: trick to remove the empty cells in tableView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func confirmButtonTapped(sender: AnyObject) {
        
        print("\(_starsForKids)")
        
        delegate?.saveStartsForKids(_starsForKids)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _babyInfoArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BabyStarCell") as! BabyStarTableViewCell
        
        // add customization here
        cell.babyNameLabel.text = _babyInfoArray[indexPath.row].nickName
        cell.babyStarRatingView.tag = indexPath.row // identify the rating view with the index in the baby info array
        cell.babyStarRatingView.delegate = self
        
        return cell
    }
    
    // MARK: delegate for star rating view
    
    /* // update the number in real time, not used here
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
    self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    */
    
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        _starsForKids![ratingView.tag] = rating // TODO: the ! may be dangerous
        
    }

 
    
}

