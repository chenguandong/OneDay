//
//  FolderDBModel.h
//  OneDay
//
//  Created by 冠东 陈 on 16/5/18.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import <Realm/Realm.h>

@interface FolderDBModel : RLMObject
//日记标签名称
@property NSString *folderName;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<FolderDBModel>
RLM_ARRAY_TYPE(FolderDBModel)
