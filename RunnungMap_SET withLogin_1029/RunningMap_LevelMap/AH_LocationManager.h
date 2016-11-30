//
//  AH_LocationManager.h
//  TaoyuanParkingRadar
//
//  Created by NO KR on 2016/9/11.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "CLLocation+bearing.h"



@interface AH_LocationManager : NSObject<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager *locationManager ;

@property (nonatomic,strong) UIImageView *arrowImageView;
@property (nonatomic) CLLocationDegrees latitudeOfTargetedPoint;
@property (nonatomic) CLLocationDegrees longitudeOfTargetedPoint;
@property (nonatomic,strong) UILabel *distanceLabel ;

@property NSMutableArray *allLocations ;
@property NSMutableArray *pathsLocations ;

+ (instancetype)create ;
- (BOOL)start ;
- (void)clear ;
- (BOOL)stop ;

-(CLLocation*)getUserLocation ;
-(void)rotateArrowView:(UIView *)view degrees:(CGFloat)degrees;



@end
