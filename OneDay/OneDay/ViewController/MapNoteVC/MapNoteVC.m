//
//  MapNoteVC.m
//  OneDay
//
//  Created by 冠东 陈 on 16/5/5.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import "MapNoteVC.h"
#import <CoreLocation/CoreLocation.h>
@interface MapNoteVC ()<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager *localtionManage;

@end

@implementation MapNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!self.localtionManage) {
        self.localtionManage = [[CLLocationManager alloc]init];
    }
    
    
    assert(self.localtionManage);
    
    
    
    // iOS 8 introduced a more powerful privacy model: <https://developer.apple.com/videos/wwdc/2014/?id=706>.
    // We use -respondsToSelector: to only call the new authorization API on systems that support it.
    //
    if ([self.localtionManage respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        
        [self.localtionManage requestWhenInUseAuthorization];
        
        
        // note: doing so will provide the blue status bar indicating iOS
        // will be tracking your location, when this sample is backgrounded
    }
    
    self.localtionManage.delegate = self; // tells the location manager to send updates to this object
    
    //设置定位精准度
    self.localtionManage.desiredAccuracy =kCLLocationAccuracyBest;
    
    // 最小更新距离
    self.localtionManage.distanceFilter = 10.0f;
    
    
    [self.localtionManage startUpdatingLocation];
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
