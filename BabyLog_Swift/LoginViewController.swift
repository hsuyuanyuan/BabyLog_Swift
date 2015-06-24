//
//  ViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/20/15.
//  Copyright © 2015 StreamSaga. All rights reserved.
//

import UIKit
import Alamofire

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
         
         UIApplication.sharedApplication().beginIgnoringInteractionEvents() // prevent the user messing up the ui
        
        
        // login module
        var dictionaryExample : [String:AnyObject] = ["Username":userNameTextField.text, "Password":passwordTextField.text] // TestAccount: ["Username":"Test222", "Password":"222222"]
        
        //let dataExample : NSData = NSKeyedArchiver.archivedDataWithRootObject(dictionaryExample)
        let data = NSJSONSerialization.dataWithJSONObject(dictionaryExample, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        
        Alamofire.request(.POST, "http://www.babysaga.cn/app/service?method=user.login", parameters: [:], encoding: .Custom({
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
                    println("Succeeded in login")
                    
                    //todo: jump to the new view
                    
                    
                } else {
                    println("Failed to login")
                    let errStr = (JSON as! NSDictionary)["Error"] as! String
                    self.displayAlert("Login failed", message: "Status Code = \(statusCode), Error = \(errStr)")
                }
                
                
                //todo: persiste to UserDefault
                
                
            } else {
                self.displayAlert("Login failed", message: error!.description)
            }
            
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
        }
        
        
        
         
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




// ------- sample code 

/*
var dictionaryExample : [String:AnyObject] = ["Username":"Test1", "Password":"1111"]

//let dataExample : NSData = NSKeyedArchiver.archivedDataWithRootObject(dictionaryExample)
let data = NSJSONSerialization.dataWithJSONObject(dictionaryExample, options: NSJSONWritingOptions.PrettyPrinted, error: nil)

Alamofire.request(.POST, "http://www.babysaga.cn/app/service?method=user.login", parameters: [:], encoding: .Custom({
(convertible, params) in
var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
mutableRequest.HTTPBody = data
return (mutableRequest, nil)
})).responseJSON() {
(request, response, JSON, error) in
println("we did get the response")
println(JSON) //yxu: output the unicode
println((JSON as! NSDictionary)["Error"]!) //yxu: output Chinese: http://stackoverflow.com/questions/26963029/how-can-i-get-the-swift-xcode-console-to-show-chinese-characters-instead-of-unic
println(request)
println(response)
println(error)
}
*/


/* signup module
var dictionaryExample : [String:AnyObject] = ["Username":"Test222", "Password":"222222", "ShenFen":"2","Email":"hsuyuanyuan@gmail.com"]

//let dataExample : NSData = NSKeyedArchiver.archivedDataWithRootObject(dictionaryExample)
let data = NSJSONSerialization.dataWithJSONObject(dictionaryExample, options: NSJSONWritingOptions.PrettyPrinted, error: nil)

Alamofire.request(.POST, "http://www.babysaga.cn/app/service?method=user.register", parameters: [:], encoding: .Custom({
(convertible, params) in
var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
mutableRequest.HTTPBody = data
return (mutableRequest, nil)
})).responseJSON() {
(request, response, JSON, error) in
println("we did get the response")
println(JSON) //yxu: output the unicode
println((JSON as! NSDictionary)["Error"]!) //yxu: output Chinese: http://stackoverflow.com/questions/26963029/how-can-i-get-the-swift-xcode-console-to-show-chinese-characters-instead-of-unic
println(request)
println(response)
println(error)
}
*/
