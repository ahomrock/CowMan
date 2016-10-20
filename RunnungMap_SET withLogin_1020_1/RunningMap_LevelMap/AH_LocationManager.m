//
//  AH_LocationManager.m
//  TaoyuanParkingRadar
//
//  Created by NO KR on 2016/9/11.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "AH_LocationManager.h"


#define RadiansToDegrees(radians)(radians * 180.0/M_PI)
#define DegreesToRadians(degrees)(degrees * M_PI / 180.0)


#define HORIZONTAL_ACCURACY_MAX 150


#define USER_TARGET_DISTANCE 30
//float angle;

@interface AH_LocationManager() {
    CLLocationDistance distance ;
    CLLocation *userLocation ;
    CLLocation *targetLocation ;
}

@end

@implementation AH_LocationManager


+ (instancetype)create {
    AH_LocationManager * loc = [[AH_LocationManager alloc] init ] ;

    if (loc) {
        loc.locationManager = [CLLocationManager new];
        loc.locationManager.delegate = loc;
        [loc.locationManager requestAlwaysAuthorization];
        loc.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;     // 取得精確度
        loc.locationManager.activityType = CLActivityTypeFitness; //選擇行動方式
        //loc.locationManager.distanceFilter = 100.0f;
    }
    return loc;
}
-(BOOL)start {
    _allLocations = [NSMutableArray new];

    if([CLLocationManager headingAvailable]==YES) {
        [_locationManager startUpdatingHeading];
        [_locationManager startUpdatingLocation] ;
        return true ;
    }
    else
        return false ;


}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    if(locations.lastObject.horizontalAccuracy > 0 && locations.lastObject.horizontalAccuracy < HORIZONTAL_ACCURACY_MAX ) {
        CLLocation *currentLocation = locations.lastObject;

        [_allLocations addObject:currentLocation ] ;
        [self performNotificationForLocation] ;

        userLocation = currentLocation ;
        targetLocation =  [[CLLocation alloc] initWithLatitude:self.latitudeOfTargetedPoint longitude:self.longitudeOfTargetedPoint] ;



        distance = [userLocation distanceFromLocation:targetLocation] ;
    }
//
//    NSLog(@"distance %f", distance) ;
//    if ( distance < USER_TARGET_DISTANCE )
//        _distanceLabel.textColor = [UIColor redColor] ;
//    else
//        _distanceLabel.textColor = [UIColor whiteColor] ;
//    _distanceLabel.text = [NSString stringWithFormat:@"%f,",distance] ;
//


   // [[NSNotificationCenter defaultCenter] removeObserver:self];

}


- (void) performNotificationForLocation{
    if (_allLocations.count > 0) {
        NSDictionary *locDic = @{@"locdic":_allLocations.lastObject} ;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotiLocations" object:self userInfo:locDic] ;
    }

// get the Notification Location
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocations:) name:@"NotiLocations" object:nil] ;
//
//    mapView = [AH_MapView createWithMKView:_mainView withVC:self]  ;
//
//-(void) getLocations:(NSNotification*) userInfo {
//    NSDictionary *locsDic = [userInfo userInfo] ;
//    _nowLocate =locsDic[@"locdic"] ;
//}

}

#pragma mark - Compass Methods - LocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    // Use the true heading if it is valid.
    CLLocationDirection direction = newHeading.magneticHeading;
    CGFloat radians = -direction / 180.0 * M_PI;

   CGFloat angle = RadiansToDegrees(radians);

    double targetBear = [userLocation bearingToLocation:targetLocation] ;

     [self rotateArrowView:_arrowImageView degrees:(angle + targetBear )] ;

    NSInteger compassImageAngle = angle + targetBear ;

    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.aHom.RunningMapExtensionSharingDefaults"];

    [sharedDefaults setInteger:compassImageAngle forKey:@"compassImageAngle"];
    [sharedDefaults synchronize];



    // (!!) This is crucial.
//    _distanceLabel.text = [NSString stringWithFormat:@"%f,%f,d:%f",angle,targetBear,distance] ;


}

-(void)clear {
    _allLocations = [NSMutableArray new] ;
}

-(void)rotateArrowView:(UIView *)view degrees:(CGFloat)degrees
{
    CGAffineTransform transform = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    view.transform = transform;
}


#pragma mark for map Image
-(CGPoint)getPointWithCoordinate:(CLLocationCoordinate2D)coordinate withView:(UIView*)view {
    CGPoint point = CGPointMake(0, 0);
    return point ;
}


@end