//
//  LocationTools.m
//  RedLiving
//
//  Created by chenguandong on 16/1/19.
//  Copyright © 2016年 冠东陈. All rights reserved.
//

#import "LocationTools.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationModel.h"
#import <UIKit/UIKit.h>
#import "LocationModel.h"
@interface LocationTools ()<CLLocationManagerDelegate>
@property(nonatomic,strong) CLLocationManager *localtionManage;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLPlacemark *placemark;
@property(nonatomic)LocationModel *locationModel;
@end

@implementation LocationTools

- (instancetype)init
{
    self = [super init];
    if (self) {
        _geocoder = [[CLGeocoder alloc]init];
        
        [self initLocation];
    }
    return self;
}

#pragma mark --初始化定位
-(void)initLocation{
    
    if (!self.localtionManage) {
        self.localtionManage = [[CLLocationManager alloc]init];
    }
    
    
    assert(self.localtionManage);
    
    
    
    // iOS 8 introduced a more powerful privacy model: <https://developer.apple.com/videos/wwdc/2014/?id=706>.
    // We use -respondsToSelector: to only call the new authorization API on systems that support it.
    //
    if ([self.localtionManage respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        
       // [self.localtionManage requestWhenInUseAuthorization];
        
        
        // note: doing so will provide the blue status bar indicating iOS
        // will be tracking your location, when this sample is backgrounded
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            //[self.localtionManage requestWhenInUseAuthorization];//?只在前台开启定位
            //[self.localtionManage  requestAlwaysAuthorization];//?在后台也可定位
            [self.localtionManage requestWhenInUseAuthorization];
        }
       
    }
    
    
   
    
    self.localtionManage.delegate = self; // tells the location manager to send updates to this object
    
    //设置定位精准度
    self.localtionManage.desiredAccuracy =kCLLocationAccuracyBest;
    
    // 最小更新距离
    self.localtionManage.distanceFilter = 10.0f;
    

    
    [self.localtionManage startUpdatingLocation];
}


#pragma mark -- locationManager


/*
 *  locationManager:didUpdateLocations:
 *
 *  Discussion:
 *    Invoked when new locations are available.  Required for delivery of
 *    deferred locations.  If implemented, updates will
 *    not be delivered to locationManager:didUpdateToLocation:fromLocation:
 *
 *    locations is an array of CLLocation objects in chronological order.
 */
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0){
    
    
    
    CLLocation * currLocation = [locations lastObject];
    
    if(_locationModel){
        
        _locationModel = nil;

    }
    
    _locationModel = [[LocationModel alloc]init];
    
    _locationModel.lat  = currLocation.coordinate.latitude;
    
    _locationModel.log  = currLocation.coordinate.longitude;
    
    NSLog(@"%@",[NSString stringWithFormat:@"%.3f",currLocation.coordinate.latitude]);
    
    
    NSLog(@"%@",[NSString stringWithFormat:@"%.3f",currLocation.coordinate.longitude]);
    
    
    [self.geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error==nil && (placemarks.count > 0)) {
            // If the placemark is not nil then we have at least one placemark. Typically there will only be one.
            _placemark = [placemarks objectAtIndex:0];
            
            // we have received our current location, so enable the "Get Current Address" button
            NSLog(@"name=%@",_placemark.name);
            
            _locationModel.adressName = _placemark.name;
            
            if(_placemark.name.length!=0){
                
                // _note.note_adress = _placemark.name;
                NSLog(@"locality=%@",_placemark.locality);
                
              
                
                [manager stopUpdatingLocation];
                
                if( [_delegate respondsToSelector:@selector(onLocationSuccess:)]){
                    
                    [_delegate onLocationSuccess:_locationModel];
                }
            }
            /*
            NSLog(@"--------------------------------->");
            
             NSLog(@"thoroughfare=%@",_placemark.thoroughfare);
             NSLog(@"subThoroughfare=%@",_placemark.subThoroughfare);
             NSLog(@"locality=%@",_placemark.locality);
             NSLog(@"subLocality=%@",_placemark.subLocality);
             NSLog(@"administrativeArea=%@",_placemark.administrativeArea);
             NSLog(@"postalCode=%@",_placemark.postalCode);
             NSLog(@"ISOcountryCode=%@",_placemark.ISOcountryCode);
             NSLog(@"country=%@",_placemark.country);
             NSLog(@"inlandWater=%@",_placemark.inlandWater);
             NSLog(@"ocean=%@",_placemark.ocean);
             NSLog(@"areasOfInterest=%@",_placemark.areasOfInterest);
            
             NSLog(@"--------------------------------->");
             */
        }
        else {
            // Handle the nil case if necessary.
            
            if( [_delegate respondsToSelector:@selector(onLocationFail)]){
                
                [manager stopUpdatingLocation];
                
                [_delegate onLocationFail];
            }
        }
        

    }];
    
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    NSLog(@"定位失败");
      [manager stopUpdatingLocation];

    
    
    if( [_delegate respondsToSelector:@selector(onLocationFail)]){
        
       // [_delegate onLocationSuccess:SharedApp.localCityModel];
        
        [_delegate onLocationFail];
    }
    
}


@end
