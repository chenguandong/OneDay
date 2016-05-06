//
//  HYTabBarController.h
//  OneDay
//
//  Created by 冠东 陈 on 16/5/5.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import "BaseTabBarController.h"

@class NoteListTableViewVC;

@class WriteNoteVC;

@class MapNoteVC;

@class SettingTableViewVC;

@interface HYTabBarController : BaseTabBarController

@property(nonatomic,strong)NoteListTableViewVC *noteListVC;

@property(nonatomic,strong)WriteNoteVC *writeNoteVC;

@property(nonatomic,strong)MapNoteVC *mapNoteVC;

@property(nonatomic,strong)SettingTableViewVC *settingVC;


@end
