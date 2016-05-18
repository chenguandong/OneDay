//
//  TagDBModel.h
//  OneDay
//
//  Created by 冠东 陈 on 16/5/17.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import <Realm/Realm.h>

@interface TagDBModel : RLMObject
//日记标签名称
@property NSString *tagName;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<TagDBModel>
RLM_ARRAY_TYPE(TagDBModel)
