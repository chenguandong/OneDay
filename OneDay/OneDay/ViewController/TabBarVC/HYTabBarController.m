//
//  HYTabBarController.m
//  OneDay
//
//  Created by 冠东 陈 on 16/5/5.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import "HYTabBarController.h"
#import "NoteListTableViewVC.h"
#import "WriteNoteVC.h"
#import "MapNoteVC.h"
#import "SettingTableViewVC.h"
#import "Constant.h"
@interface HYTabBarController ()

@end

@implementation HYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadTabBarSubView];
}



#pragma mark -- method

-(void)loadTabBarSubView
{
    _noteListVC = [[NoteListTableViewVC alloc]init];
    _writeNoteVC = [[WriteNoteVC alloc]init];
    _mapNoteVC = [[MapNoteVC alloc]init];
    _settingVC = [[SettingTableViewVC alloc]init];
    
    //-------set title
    
    _noteListVC.title = NSLocalizedString(@"note", nil);
    _writeNoteVC.title = NSLocalizedString(@"writeNote", nil);
    _mapNoteVC.title = NSLocalizedString(@"noteMap", nil);
    _settingVC.title = NSLocalizedString(@"setting", nil);
    
    //日记列表
    UINavigationController *noteListNavVC = [[UINavigationController alloc]initWithRootViewController:_noteListVC];
    
    UITabBarItem *noteListTabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"note", nil) image:[UIImage imageNamed:@"tabbar_list"] tag:1];
    
    noteListNavVC.tabBarItem = noteListTabBarItem;
    
    
    //写日记
    UINavigationController *writeNoteNavVc = [[UINavigationController alloc]initWithRootViewController:_writeNoteVC];
    
    
    UITabBarItem *writeNoteTabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"writeNote", nil) image:[UIImage imageNamed:@"tabbar_write"] tag:2];
    
    writeNoteNavVc.tabBarItem = writeNoteTabBarItem;
    
    
    //日记地图
    UINavigationController *mapNoteNavVc = [[UINavigationController alloc]initWithRootViewController:_mapNoteVC];
    
    UITabBarItem *mapNoteTabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"noteMap", nil) image:[UIImage imageNamed:@"tabbar_location"] tag:3];
    
    mapNoteNavVc.tabBarItem = mapNoteTabBarItem;
    
    
    //设置
    UINavigationController *settingNavVc = [[UINavigationController alloc]initWithRootViewController:_settingVC];
    
    UITabBarItem *settingBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"setting", nil) image:[UIImage imageNamed:@"tabbar_setting"] tag:4];
    
    settingNavVc.tabBarItem = settingBarItem;
    

    //localNavVc
    
    [self setViewControllers:@[noteListNavVC,writeNoteNavVc,mapNoteNavVc,settingNavVc] animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
