//
//  DateTools.m
//  OneDay
//
//  Created by 冠东 陈 on 16/5/18.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import "DateTools.h"
#import <NSDate+DateTools.h>
@implementation DateTools



+ (NSString*)weekName:(NSDate*)date{
    
    switch ([date weekday]) {
        case 1:
            return NSLocalizedString(@"Mon", nil);
            break;
        case 2:
            return NSLocalizedString(@"Tue", nil);
            break;
        case 3:
            return NSLocalizedString(@"Wed", nil);
            break;
        case 4:
            return NSLocalizedString(@"Thu", nil);
            break;
        case 5:
            return NSLocalizedString(@"Fri", nil);
            break;
        case 6:
            return NSLocalizedString(@"Sat", nil);
            break;
        case 7:
            return NSLocalizedString(@"Sun", nil);
            break;
            
        default:
            break;
    }
    
    return @"";
}


@end
