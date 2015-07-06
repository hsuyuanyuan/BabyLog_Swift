//
//  DailyLogItem.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/27/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import Foundation
import UIKit

class ActivityType {
    
    let id: Int
    let name: String
    let imageName: String
    
    init(id:Int, name:String, imageName:String) {
        self.id = id
        self.name = name
        self.imageName = imageName
    }

}




class DailyLogItem: Printable {
    
    let activityType: Int
    let content: String
    let startTime: String
    let endTime: String
    let uniqueId: Int // 307-308 etc
    //todo: datetime for InDay and CreatedDateTime ??
    
    var description: String {
        return "uniqueId:\(uniqueId), id: \(activityType), startTime: \(startTime), endTime: \(endTime), content: \(content)\n"
    }
    
    init(uniqueId: Int, activityType: Int, content: String?, startTime: String?, endTime: String? ) {
        self.uniqueId = uniqueId
        self.activityType = activityType ?? 0
        self.content = content ?? ""
        self.startTime = startTime ?? ""
        self.endTime = endTime ?? ""
    }
    
}


enum ImageState {
    case New, Downloaded, Failed // TODO: add cached later
    
}


class BabyInfo: Printable {
    
    // must have
    let babyName: String
    let nickName: String
    let sex: Int //Note: in Json, it is String, not Int. need conversion
    // replace the raw json field with a real URL
    //let headImgName: String = ""
    //let headImgPath: String = ""
    let imageURL: NSURL
    var imageState = ImageState.New
    var image = imageDefaultHead // image is owned by the babyInfo object, not by the view cell
    

    // optional
    let address: String = ""
    let city: String = ""
    let cityId: Int = 0
    let province: String = ""
    let proviceId: Int = 0
    let country:String = ""
    
    let birthday: String = ""
    let bloodType: String = ""
    let telNumber: String = ""
    
    let id: Int  // student id in class
    let intro: String = ""
    
    let diaryCount: Int = 0
    
    
    // guid / daoxiaoTime / lixiaoTime
    // usercode /userType
    // open

    
    var description: String {
        return "baby name:\(babyName), nick name: \(nickName), sex: \(sex)\n, id: \(id)"
    }
    
    init(babyName: String, nickName: String, sex: Int, id: Int, imageURL: NSURL ) {
        self.babyName = babyName
        self.nickName = nickName
        self.sex = sex
        self.id = id
        self.imageURL = imageURL
    }
    
}



// async downloading
// refer to: http://www.raywenderlich.com/76341/use-nsoperation-nsoperationqueue-swift

class PendingOperations {
    lazy var downloadsInProgress =  [NSIndexPath : NSOperation]()
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "image download queue"
        queue.maxConcurrentOperationCount = 2
        return queue
    }() //yxu ?? swift grammar
 
}


class ImageDownloader: NSOperation {
    
    let babyInfo: BabyInfo
    
    init(babyInfo: BabyInfo) {
        self.babyInfo = babyInfo
    }
    
    override func main() {
        
        if self.cancelled {
            return
        }
        
        let imageData = NSData(contentsOfURL: self.babyInfo.imageURL)
        
        if self.cancelled {
            return
        }
        
        if imageData?.length > 0 {
            self.babyInfo.image = UIImage(data:imageData!)
            self.babyInfo.imageState = .Downloaded
        } else {
            self.babyInfo.imageState = .Failed
            
        }
        
    }
}



/*
输出：List<ScheduleDto>
ScheduleDto：：
int Id 日程序号
DateTime CreatedDateTime 建立的时间（不起什么作用）
string Content 日程的备注说明
string StartTime 开始时间
string EndTime 结束时间
DateTime InDay 日期
int ByCreateClass 所属哪个班级的日程
int DiaryType 日程的类型
string EntryTime 时间段（开始时间 “-” 结束时间）



ScheduleList =     (
{
ByCreateClass = 41;
Content = "This is a test";
CreatedDateTime = "/Date(1435250595933)/";
DiaryType = 1;
EndTime = "09:30";
EntryTime = "08:00-09:30";
Guid = "<null>";
Id = 305;
Imgfile = "<null>";
Imgpath = "~/content/diaryimg/youxi.jpg";
InDay = "/Date(1435161600000)/";
Open = 0;
Orders = 1;
PicList =             (
);
StartTime = "08:00";
Status = 0;
},


{
ByCreateClass = 41;
Content = "This is a test";
CreatedDateTime = "/Date(1435250717757)/";
DiaryType = 1;
EndTime = "09:30";
EntryTime = "08:00-09:30";
Guid = "<null>";
Id = 306;
Imgfile = "<null>";
Imgpath = "~/content/diaryimg/youxi.jpg”; //http://www.babysaga.cn//content/diaryimg/youxi.jpg
InDay = "/Date(1435161600000)/";
Open = 0;
Orders = 1;
PicList =             (
);
StartTime = "08:00";
Status = 0;
},


{
ByCreateClass = 41; 所属哪个班级的日程
Content = "This is a test";
CreatedDateTime = "/Date(1435250900590)/"; 建立的时间（不起什么作用）
DiaryType = 1; 日程的类型
EndTime = "09:30"; 结束时间
EntryTime = "08:00-09:30"; 时间段（开始时间 “-” 结束时间）
Guid = "<null>";
Id = 307; 日程序号
Imgfile = "<null>";
Imgpath = "~/content/diaryimg/youxi.jpg";
InDay = "/Date(1435161600000)/";
Open = 0;
Orders = 1;
PicList =             (
);
StartTime = "08:00";
Status = 0;
}
);


*/