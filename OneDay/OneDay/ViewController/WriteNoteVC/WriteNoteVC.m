//
//  WriteNoteVC.m
//  OneDay
//
//  Created by 冠东 陈 on 16/5/5.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import "WriteNoteVC.h"
#import "HYWriteNoteNow.h"

@interface WriteNoteVC ()


@property (weak, nonatomic) IBOutlet UIButton *writeNoteButton;

@end

@implementation WriteNoteVC

#pragma mark - lifeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    _writeNoteButton.layer.borderColor = [UIColor blackColor].CGColor;
    _writeNoteButton.layer.cornerRadius = 75;
    
    _writeNoteButton.layer.borderWidth = 2.;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

- (IBAction)writeButtonAction:(id)sender {
    
    

    
    HYWriteNoteNow *textVC = [[HYWriteNoteNow alloc]init];
    
    textVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:textVC animated:YES];
   
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
