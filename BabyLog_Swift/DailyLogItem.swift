//
//  DailyLogItem.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/27/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import Foundation


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
    
    let id: Int
    let content: String
    let startTime: String
    let endTime: String
    //todo: datetime for InDay and CreatedDateTime ??
    
    var description: String {
        return "id: \(id), startTime: \(startTime), endTime: \(endTime), content: \(content)\n"
    }
    
    init(id: Int, content: String?, startTime: String?, endTime: String? ) {
        self.id = id ?? 0
        self.content = content ?? ""
        self.startTime = startTime ?? ""
        self.endTime = endTime ?? ""
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