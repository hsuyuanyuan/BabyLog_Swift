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




class DailyLogItem: CustomStringConvertible {
    
    let activityType: Int
    let content: String
    let startTime: String
    let endTime: String
    let uniqueId: Int // 307-308 etc
    // TODO: how about datetime for InDay and CreatedDateTime
    
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


class DailyLogItem_ExtraInfoForBaby {
    
    var _stars = Int(defaultNumStars)
    var _babyId = 0
    var _classId = 0
    var _creatorId = 0
    var _picCount = 0  // TODO: clean up picCount / picPaths / images
    var _picPaths: [String]?
    var _images: [UIImage]?
    
    
    init(stars: Int, babyId: Int, classId: Int, creatorId: Int, picCount: Int, picPaths: [String]?,
        images:[UIImage]? = nil  ) // last parameter images is optional
    {
        self._stars = stars
        self._babyId = babyId
        self._classId = classId
        self._creatorId = creatorId
        self._picCount = picCount
        self._picPaths = picPaths
        self._images = images
    }
    
}






enum ImageState {
    case New, Downloaded, Failed // TODO: add cached later
    
}


class BabyInAndOutTime {
    let id: Int  // baby id in class
    let babyName: String // = "\U5c0f\U5929";
    let imgPath: String
    let inTime: String
    let outTime: String
    
    init(id: Int, babyName: String, imgPath: String, inTime: String, outTime: String) {
        self.id = id
        self.babyName = babyName
        self.imgPath = imgPath
        self.inTime = inTime
        self.outTime =  outTime
    }
    
}


class BabyInfo: CustomStringConvertible {
    let babyName: String
    let nickName: String
    let id: Int  // baby id in class
    let sex: Int //Note: in Json, it is String, not Int. need conversion
    // replace the raw json field with a real URL
    //let headImgName: String = ""
    //let headImgPath: String = ""
    let imageURL: NSURL
    var validImageExtension: Bool = true
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
    

    let intro: String = ""
    let diaryCount: Int = 0
    
    
    // guid / daoxiaoTime / lixiaoTime
    // usercode /userType
    // open

    
    var description: String {
        return "baby name:\(babyName), nick name: \(nickName), sex: \(sex)\n, id: \(id)"
    }
    
    init(babyName: String, nickName: String, sex: Int, id: Int, imageURL: NSURL, validImageExtension: Bool ) {
        self.babyName = babyName
        self.nickName = nickName
        self.sex = sex
        self.id = id
        self.imageURL = imageURL
        self.validImageExtension = validImageExtension
    }
    
}



class BanjiInfo: CustomStringConvertible { // avoid the name classInfo, may conflict with reserved words
    
    var addr: String
    var code: String
    var desc: String
    var id: Int
    var name: String
    
    var password: String
    var quarter: Int
    var school: String
    
    var teacherId: Int
    var teacherName: String
    var year: String
    
    

    var description: String {
        return "class name:\(name), school: \(school), TeacherName: \(teacherName)\n, quarter: \(quarter), year: \(year)"
    }

    
    init(name: String, addr: String, code: String, id: Int, desc: String,  password: String, quarter: Int,
        school: String, teacherId: Int, teacherName: String, year: String) {
            self.name = name
            self.addr = addr
            self.code = code
            self.id = id
            self.desc = desc
            
            self.password = password
            self.quarter = quarter
            self.school = school
            self.teacherId = teacherId
            self.teacherName = teacherName
            self.year = year
    }

}




class TeacherInfo: CustomStringConvertible  {
    // must have
    let name: String
    let id: Int
    let sex: Int
    let BirthDay: String
    let BloodType: String
    
    // optional
    var addrCity: String = ""
    var addrProv: String = ""
    var addrCountry: String = ""
    
    var intro: String = ""
    var nickName: String = ""
    var imageURL: NSURL
    var validImageExtension: Bool = true
    
    var description: String {
        return "teacher name:\(name), nick name: \(nickName), sex: \(sex)\n, id: \(id)"
    }
    
    
    init(name: String, nickName: String, sex: Int, id: Int, imageURL: NSURL, validImageExtension: Bool, birthDay: String, bloodType: String,
        city: String, province: String, country: String, intro: String) {
        self.name = name
        self.nickName = nickName
        self.sex = sex
        self.id = id
        self.imageURL = imageURL
        self.validImageExtension = validImageExtension
        self.BloodType = bloodType
        self.BirthDay = birthDay
        self.addrCity = city
        self.addrProv = province
        self.addrCountry = country
        self.intro = intro
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
        
        if !self.babyInfo.validImageExtension {
            self.babyInfo.imageState = .Failed // do not bother to make api call, if the extension is not even valid
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


