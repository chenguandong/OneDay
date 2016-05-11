//
//  YYTextEditExample.h
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYWriteNoteNowDelegate <NSObject>

@optional
- (void)noteEditEnd:(NSData*)noteData;

@end

@interface HYWriteNoteNow : UIViewController

@property(nonatomic,weak)id<HYWriteNoteNowDelegate>delegate;

@property(nonatomic,strong)NSData *lastNoteData;

@end
