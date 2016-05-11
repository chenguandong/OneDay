//
//  WriteNoteVC.m
//  OneDay
//
//  Created by 冠东 陈 on 16/5/5.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import "WriteNoteVC.h"
#import "HYWriteNoteNow.h"
@interface WriteNoteVC ()<HYWriteNoteNowDelegate>

@property(nonatomic,strong)NSData *noteData;

@end

@implementation WriteNoteVC

#pragma mark - lifeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

- (IBAction)writeButtonAction:(id)sender {
    
     HYWriteNoteNow *textVC = [HYWriteNoteNow new];
    
    textVC.hidesBottomBarWhenPushed = YES;
    
    textVC.lastNoteData = _noteData;
    
    textVC.delegate = self;
    
    [self.navigationController pushViewController:textVC animated:YES];
   
}


#pragma mark - NoteVC delegate

- (void)noteEditEnd:(NSData*)noteData{

    if (noteData) {
        self.noteData  = noteData;
    }
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
