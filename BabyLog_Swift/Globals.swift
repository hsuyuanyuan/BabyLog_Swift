//
//  Globals.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/9/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//


import UIKit
 


let version = 0.5

//  ***************************
// TODO: add locking to pretect it, as it is used by multiple VCs

var _babyInfoArray = [BabyInfo]()

var _teacherInfo: TeacherInfo?


//  ***************************


var _bitMaskForLeaveTime: Int = 0x1000


enum InOutType: Int {
    case Arrival = 1
    case Leaving = 2
    
}

// constants for web api
let APICommonPrefix = "http://www.babysaga.cn/app/service?method="

enum APIType: String, Printable {
    
    case AddDairyForOneBaby = "Diary.IOSInputDiary"
    case GetDairyForOneBaby = "diary.tdaydiary"
    case DelDairyForOneBaby = "Diary.DelDiary"
    
    case ListAllBabiesInClass = "user.ListClassBaby"
    
    case ListAllBabiesInAndOutTime = "TeacherManage.ListBanjiBabyInAndOut"
    case SetInAndOutTimeForOneBaby = "TeacherManage.InOutSchoolTime"
    
    
    case DeleteScheduleForClass = "ClassSchedule.DeleteSchedule"
    case AddScheduleForClass = "ClassSchedule.InputScheduleJson"
    case GetScheduleForClass = "ClassSchedule.GetListSchedule"
    case UploadCompleteStatusWithStars = "ClassSchedule.CompleteSchedule"
    
    case UserLogIn = "user.login"
    case UserRegistration = "user.register"
    case UserGetInfo = "user.GetUserInfo"
    case UserUpdateInfo = "user.UpdateUserInfo"
    case UserOutClassBaby = "User.TeacherOutClassBaby"

    
    var description: String {
        return self.rawValue
    }
}




// constants
 
let defaultUploadImageSizeLimit = 1048576 //1024 * 1024



let defaultStringForOutTime = "离校时间"
let defaultStringForInTime = "到校时间"

let defaultNumStars:Float = 3.0 // this is from the float rating view. default 3 stars

let defaultImg = "login_bg.png"

let baseURL = NSURL(string: "http://www.babysaga.cn/") // another option, initWithPath is for local folder

let imageDefaultHead = UIImage(named: "Tab Bar-KId@3x.png")  // default photo for kids without their own photos


let userTokenStringInHttpHeader = "Token" as NSObject

let userTokenKeyInUserDefault = "keyForUserToken"


let activityIdMin = 1 // first activity id, not zero

let activityTypeDictionary = [
    1:ActivityType(id: 1, name: "大便", imageName: "activity_1.png"),
    2:ActivityType(id: 2, name: "小便", imageName: "activity_2.png"),
    3:ActivityType(id: 3, name: "睡觉", imageName: "activity_3.png"),
    4:ActivityType(id: 4, name: "午睡", imageName: "activity_4.png"),
    5:ActivityType(id: 5, name: "吃饭", imageName: "activity_5.png"),
    6:ActivityType(id: 6, name: "零食", imageName: "activity_6.png"),
    7:ActivityType(id: 7, name: "室内个人活动", imageName: "activity_7.png"),
    8:ActivityType(id: 8, name: "室内集体活动", imageName: "activity_8.png"),
    9:ActivityType(id: 9, name: "室外个人活动", imageName: "activity_9.png"),
    10:ActivityType(id: 10, name: "室外集体活动", imageName: "activity_10.png"),
    11:ActivityType(id: 11, name: "洗漱", imageName: "activity_11.png"),
    12:ActivityType(id: 12, name: "其他", imageName: "activity_12.png"),
    13:ActivityType(id: 13, name: "起床", imageName: "activity_13.png"),
    14:ActivityType(id: 14, name: "洗澡", imageName: "activity_14.png"),
    15:ActivityType(id: 15, name: "生病", imageName: "activity_15.png"),
    20:ActivityType(id: 20, name: "到校", imageName: "activity_20.png"),
    30:ActivityType(id: 30, name: "离校", imageName: "activity_30.png"),
]


// TODO: how to enforace the sync between dict and array
var activityTypeArray = [
    ActivityType(id: 1, name: "大便", imageName: "activity_1.png"),
    ActivityType(id: 2, name: "小便", imageName: "activity_2.png"),
    ActivityType(id: 3, name: "睡觉", imageName: "activity_3.png"),
    ActivityType(id: 4, name: "午睡", imageName: "activity_4.png"),
    ActivityType(id: 5, name: "吃饭", imageName: "activity_5.png"),
    ActivityType(id: 6, name: "零食", imageName: "activity_6.png"),
    ActivityType(id: 7, name: "室内个人活动", imageName: "activity_7.png"),
    ActivityType(id: 8, name: "室内集体活动", imageName: "activity_8.png"),
    ActivityType(id: 9, name: "室外个人活动", imageName: "activity_9.png"),
    ActivityType(id: 10, name: "室外集体活动", imageName: "activity_10.png"),
    ActivityType(id: 11, name: "洗漱", imageName: "activity_11.png"),
    ActivityType(id: 12, name: "其他", imageName: "activity_12.png"),
    ActivityType(id: 13, name: "起床", imageName: "activity_13.png"),
    ActivityType(id: 14, name: "洗澡", imageName: "activity_14.png"),
    ActivityType(id: 15, name: "生病", imageName: "activity_15.png"),
    ActivityType(id: 20, name: "到校", imageName: "activity_20.png"),
    ActivityType(id: 30, name: "离校", imageName: "activity_30.png"),
]


/* // TODO: think about localization
1:ActivityType(id: 1, name: "DaBian", imageName: "activity_1.jpg"),
2:ActivityType(id: 2, name: "XiaoBian", imageName: "activity_2.jpg"),
3:ActivityType(id: 3, name: "ShuiJiao", imageName: "activity_3.jpg"),
4:ActivityType(id: 4, name: "WuShui", imageName: "activity_4.jpg"),
5:ActivityType(id: 5, name: "ChiFan", imageName: "activity_5.jpg"),
6:ActivityType(id: 6, name: "LingShi", imageName: "activity_6.jpg"),
7:ActivityType(id: 7, name: "ShiNeiGeRenHuoDong", imageName: "activity_7.jpg"),
8:ActivityType(id: 8, name: "ShiNeiJiTiHuoDong", imageName: "activity_8.jpg"),
9:ActivityType(id: 9, name: "ShiWaiGeRenHuoDong", imageName: "activity_9.jpg"),
10:ActivityType(id: 10, name: "ShiWaiJiTiHuoDong", imageName: "activity_10.jpg"),
11:ActivityType(id: 11, name: "XiSu", imageName: "activity_11.jpg"),
12:ActivityType(id: 12, name: "QiTa", imageName: "activity_12.jpg"),
13:ActivityType(id: 13, name: "QiChuang", imageName: "activity_13.jpg"),
14:ActivityType(id: 14, name: "XiZao", imageName: "activity_14.jpg"),
15:ActivityType(id: 15, name: "ShengBing", imageName: "activity_15.jpg"),
20:ActivityType(id: 20, name: "DaoXiao", imageName: "activity_20.jpg"),
30:ActivityType(id: 30, name: "LiXiao", imageName: "activity_30.jpg"),
*/




extension NSDate {
    var formattedHHMM: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return  formatter.stringFromDate(self)
    }
    
    var formattedYYYYMMDD: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd" //formatter.dateFormat = "EEEE, dd MMM yyyy HH:mm:ss Z"
        return formatter.stringFromDate(self)
    }
}



extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}


// refer to: http://stackoverflow.com/questions/29726643/how-to-compress-of-reduce-the-size-of-an-image-before-uploading-to-parse-as-pffi
extension UIImage {
    var highestQualityJPEGNSData:NSData { return UIImageJPEGRepresentation(self, 1.0) }
    var highQualityJPEGNSData:NSData    { return UIImageJPEGRepresentation(self, 0.75)}
    var mediumQualityJPEGNSData:NSData  { return UIImageJPEGRepresentation(self, 0.5) }
    var lowQualityJPEGNSData:NSData     { return UIImageJPEGRepresentation(self, 0.25)}
    var lowestQualityJPEGNSData:NSData  { return UIImageJPEGRepresentation(self, 0.0) }
}



// refer to: http://rajiev.com/resize-uiimage-in-swift/
extension UIImage {
    public func resize(size:CGSize, completionHandler:(resizedImage:UIImage, data:NSData)->()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            var newSize:CGSize = size
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageData = UIImageJPEGRepresentation(newImage, 0.5)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(resizedImage: newImage, data:imageData)
            })
        })
    }
}






/* =============== RongCloud
Note: how to get the token for a test user?
1. go to https://developer.rongcloud.cn/apitool/cLJ6Ys7T2JiHAH0T0w==
2. userid = 1, name = Test111, portraitUri = empty
3. copy the return token

获取用户 Token 并连接的流程如下： 1， 首先，您的 App 查询您的应用程序服务器， 2， 然后，您的应用程序服务器再访问融云服务器获取，最后返回给 App， 3， App 用返回的 Token 直接连接融云服务器登录。 详细描述请参考 Server 开发指南 中的身份认证服务小节。

为了方便您进行测试开发，我们还提供了 API 调试工具，以便您不用部署服务器端程序，即可直接获得测试开发所需的 Token。请访问 融云开发者平台，打开您想测试的应用，在左侧菜单中选择“API 调试”即可。融云拥有业内最丰富功能的开发者后台服务，我们建议所有开发者先熟悉后台的功能。

*/
let userTokens  = ["", "YosJ8u4R9BDqhiG3IZKQ+VIPIEx22OKrNk+hkytiK3ZE0cslnXRrmjK+u6BZOb3YUbhmXbiLhAET627UJzV7Og==", "jELDaCGEl2zDl2PxC+0pAg7Sb0qRD+ExST5W71Ob8Ref2OQLwZvwE0XkoygJS8+BJBQWVCcMMduw/WfGu1LNZg=="]
let userIds  = [0, 1, 2 ]
let userNames = ["", "Test111", "Test222" ]


//Note: two versions: one for simulator, the other for the real phone, so they can talk to each other
// this is for simulator
let curUser = 1
let nextUser = 2

/*
// for phone
let curUser = 2
let nextUser = 1

=======================  */
