//
//  NoteDBModel.h
//  OneDay
//
//  Created by 冠东 陈 on 16/5/17.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import <Realm/Realm.h>
#import "TagDBModel.h"
#import "FolderDBModel.h"

@interface NoteDBModel : RLMObject
//日记标题
@property NSString *note_title;

//日记内容
@property NSData   *note_body;

//日记天气
@property NSString *note_weather;

//日记经纬
@property NSNumber<RLMDouble>    *note_lng;

//日记纬度
@property NSNumber<RLMDouble>    *note_lat;

//日记地址
@property NSString              *note_adress;

//是否同步 CloudKit
@property NSNumber<RLMBool>      *note_sync;


//日记标签
@property RLMArray<TagDBModel *><TagDBModel>*note_tag;

//日记日期
@property NSDate    *note_date;

//所属日记本
@property FolderDBModel  *note_folder;

//步数
@property NSString       *note_step;


@end

// This protocol enables typed collections. i.e.:
// RLMArray<NoteDBModel>
RLM_ARRAY_TYPE(NoteDBModel)
