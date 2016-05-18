//
//  LocationTools.h
//  RedLiving
//
//  Created by chenguandong on 16/1/19.
//  Copyright © 2016年 冠东陈. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LocationModel;
@protocol LocationToolsDelegate <NSObject>

@optional
- (void)onLocationSuccess:(LocationModel*)locationModel;

- (void)onLocationFail;

@end

@interface LocationTools : NSObject

@property(nonatomic,weak)id<LocationToolsDelegate>delegate;

@end
