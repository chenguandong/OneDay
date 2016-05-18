//
//  DateTools.h
//  OneDay
//
//  Created by 冠东 陈 on 16/5/18.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTools : NSObject
/**
 *  获取星期几的中英文字符
 *
 *  @param date NSDate
 *
 *  @return 星期几
 */
+ (NSString*)weekName:(NSDate*)date;
@end
