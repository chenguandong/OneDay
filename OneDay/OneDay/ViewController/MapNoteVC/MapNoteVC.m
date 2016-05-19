//
//  MapNoteVC.m
//  OneDay
//
//  Created by 冠东 陈 on 16/5/5.
//  Copyright © 2016年 10H3Y. All rights reserved.
//

#import "MapNoteVC.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "HYNoteAnnotation.h"
#import <Realm.h>
#import "NoteDBModel.h"
#import <TSClusterMapView.h>
#import "TSDemoClusteredAnnotationView.h"
#import "HYWriteNoteNow.h"
@interface MapNoteVC ()<CLLocationManagerDelegate,MKMapViewDelegate,TSClusterMapViewDelegate>

@property(nonatomic,strong)CLLocationManager *localtionManage;

@property (nonatomic, strong) CLGeocoder *geocoder;

@property (weak, nonatomic) IBOutlet TSClusterMapView *mapView;

@property (nonatomic, strong) CLPlacemark *placemark;

@property (nonatomic)NSMutableArray<HYNoteAnnotation*> *noteAnnotations;

@property (nonatomic)NSMutableArray<NoteDBModel*> *noteDBModels;

@end

@implementation MapNoteVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _geocoder = [[CLGeocoder alloc]init];
        
        _noteAnnotations = @[].mutableCopy;
        
        _noteDBModels = @[].mutableCopy;
    }
    return self;
}

#pragma mark - lifeVC
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
    

    _mapView.delegate = self;
    
   // _mapView.showsUserLocation = YES;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance
    ([_mapView.userLocation coordinate], 3000, 3000);
    [_mapView setRegion:region animated:YES];

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
     [self.localtionManage startUpdatingLocation];
    
    [self allAnnotations];
    
}



- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:YES];
    
    [_localtionManage stopUpdatingLocation];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private method

- (void)allAnnotations{

    
    RLMResults *noteResult =  [NoteDBModel allObjects];
    
    if (noteResult.count!=0) {
        if (_noteAnnotations.count!=0) {
            [_noteAnnotations removeAllObjects];
        }
        
        if (_noteDBModels.count!=0) {
            [_noteDBModels removeAllObjects];
        }
    }
    
    for (NoteDBModel *noteModel in noteResult) {
        
        [_noteDBModels addObject:noteModel];
        
        HYNoteAnnotation *noteAnnotation = [[HYNoteAnnotation alloc]initWithCoordinates:CLLocationCoordinate2DMake([noteModel.note_lat doubleValue], [noteModel.note_lng doubleValue]) title:noteModel.note_title subtitle:noteModel.note_adress];
        [_noteAnnotations addObject:noteAnnotation];
    }
    
    if (_mapView.annotations.count!=0) {
        
        [_mapView removeAllAnnotations];
    }

    
    
    [_mapView addClusteredAnnotations:_noteAnnotations];
    
    [_mapView showAnnotations:_mapView.annotations animated:YES];
}




#pragma mark - mapView delegate


- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{


}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

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
    
    
    [MKMapView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance
        ([_mapView.userLocation coordinate], 1500, 1500);
        [_mapView setRegion:region animated:YES];
        
        //[manager stopUpdatingLocation];
        
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    
    NSLog(@"%@",[NSString stringWithFormat:@"%.3f",currLocation.coordinate.latitude]);
    
    
    NSLog(@"%@",[NSString stringWithFormat:@"%.3f",currLocation.coordinate.longitude]);
    

    
    [self.geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error==nil && (placemarks.count > 0)) {
            // If the placemark is not nil then we have at least one placemark. Typically there will only be one.
            _placemark = [placemarks objectAtIndex:0];
            
            // we have received our current location, so enable the "Get Current Address" button
            NSLog(@"name=%@",_placemark.name);
            
            
            if(_placemark.name.length!=0){
                
                // _note.note_adress = _placemark.name;
                NSLog(@"locality=%@",_placemark.locality);
                
                
                
                //[manager stopUpdatingLocation];
                
                
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
       

        
    }];
    
    
   
    
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    NSLog(@"定位失败");
    [manager stopUpdatingLocation];
    
    
}





#pragma mark - MKMapViewDelegate


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0){
    
    NSLog(@"????");
    
    if([view.annotation isKindOfClass:[HYNoteAnnotation class]]){
    
        NoteDBModel *noteModel  = _noteDBModels[[_noteAnnotations indexOfObject:view.annotation]];
        
        HYWriteNoteNow *textVC = [[HYWriteNoteNow alloc]init];
        
        textVC.hidesBottomBarWhenPushed = YES;
        
        textVC.noteModel = noteModel;
        
        [self.navigationController pushViewController:textVC animated:YES];
    }
    

    
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0){
    
    NSLog(@"@@@@@@@");

}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKAnnotationView *view;
    
    if ([annotation isKindOfClass:[HYNoteAnnotation class]]) {
        view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([HYNoteAnnotation class])];
        if (!view) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                reuseIdentifier:NSStringFromClass([HYNoteAnnotation class])];
            view.image = [UIImage imageNamed:@"StreetLightAnnotation"];
            view.canShowCallout = YES;
            view.centerOffset = CGPointMake(view.centerOffset.x, -view.frame.size.height/2);
        }
    }
    
    
    return view;
}


#pragma mark - ADClusterMapView Delegate

- (MKAnnotationView *)mapView:(TSClusterMapView *)mapView viewForClusterAnnotation:(id<MKAnnotation>)annotation {
    
    TSDemoClusteredAnnotationView * view = (TSDemoClusteredAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([TSDemoClusteredAnnotationView class])];
    if (!view) {
        view = [[TSDemoClusteredAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:NSStringFromClass([TSDemoClusteredAnnotationView class])];
    }
    
    return view;
}

- (void)mapView:(TSClusterMapView *)mapView willBeginBuildingClusterTreeForMapPoints:(NSSet<ADMapPointAnnotation *> *)annotations {
    NSLog(@"Kd-tree will begin mapping item count %lu", (unsigned long)annotations.count);
    
}

- (void)mapView:(TSClusterMapView *)mapView didFinishBuildingClusterTreeForMapPoints:(NSSet<ADMapPointAnnotation *> *)annotations {
    NSLog(@"Kd-tree finished mapping item count %lu", (unsigned long)annotations.count);
   
}

- (void)mapViewWillBeginClusteringAnimation:(TSClusterMapView *)mapView{
    
    NSLog(@"Animation operation will begin");
}

- (void)mapViewDidCancelClusteringAnimation:(TSClusterMapView *)mapView {
    
    NSLog(@"Animation operation cancelled");
}

- (void)mapViewDidFinishClusteringAnimation:(TSClusterMapView *)mapView{
    
    NSLog(@"Animation operation finished");
    
   
   
}

- (void)userWillPanMapView:(TSClusterMapView *)mapView {
    
    NSLog(@"Map will pan from user interaction");
}

- (void)userDidPanMapView:(TSClusterMapView *)mapView {
    
    NSLog(@"Map did pan from user interaction");
}

- (BOOL)mapView:(TSClusterMapView *)mapView shouldForceSplitClusterAnnotation:(ADClusterAnnotation *)clusterAnnotation {
    
    return YES;
}

- (BOOL)mapView:(TSClusterMapView *)mapView shouldRepositionAnnotations:(NSArray<ADClusterAnnotation *> *)annotations toAvoidClashAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    return YES;
}





@end
