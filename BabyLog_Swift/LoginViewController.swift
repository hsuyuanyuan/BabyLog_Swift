//
//  ViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/20/15.
//  Copyright © 2015 StreamSaga. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

   
   
   @IBOutlet weak var userNameTextField: UITextField!
   
   
   @IBOutlet weak var passwordTextField: UITextField!
   
   func displayAlert(title: String, message: String ) {
      
      let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
      
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
         self.dismissViewControllerAnimated(true, completion: nil) //yxu?: is self the alert or the LoginViewController??
      }))
      
      self.presentViewController(alert, animated: true, completion: nil)
      
   }
   
   @IBAction func logInAccount(sender: UIButton) {

      
      if (userNameTextField.text == "") || ( passwordTextField.text == "")
      {
         displayAlert("Error in form", message: "Please enter a valid account or password")

      } else {
      
         let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
         
         activityIndicator.center = self.view.center
         activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
         activityIndicator.hidesWhenStopped = true
         self.view.addSubview(activityIndicator)
         activityIndicator.startAnimating()
         
         UIApplication.sharedApplication().beginIgnoringInteractionEvents()
         // prevent the user messing up the ui
         
      }
   }
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      //Try1: image does not fit into screen
      // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_bg")!)
      
      //Try2: 
      /*
      let imageView = UIImageView(image: UIImage(named: "login_bg")!)
      imageView.frame = CGRectMake(0, 20, self.view.bounds.width, self.view.bounds.height);
      self.view.addSubview(imageView)
*/
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }


}

