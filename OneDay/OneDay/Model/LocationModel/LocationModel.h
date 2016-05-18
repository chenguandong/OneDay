//
//  LocationModel.h
//  OneDay
//
//  Created by 冠东 陈 on 16/5/16.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject

//城市名称
@property(nonatomic,copy)NSString *adressName;

//纬度
@property(nonatomic,assign)double lat;

//经度
@property(nonatomic,assign)double log;


@end
