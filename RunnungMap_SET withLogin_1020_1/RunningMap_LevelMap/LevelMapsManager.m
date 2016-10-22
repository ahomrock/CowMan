//
//  LevelMapsManager.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/22.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "LevelMapsManager.h"
#import <CoreLocation/CoreLocation.h>

@implementation LevelMapsManager


+(instancetype)sharedInstance {
    static LevelMapsManager *lmManager = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lmManager = [[LevelMapsManager alloc]init ] ;
        lmManager.levelMapPoints = [NSMutableArray new] ;

    });

    return lmManager ;
}


- (void)defaultSetting {
    LevelMapPoint *point = [LevelMapPoint new] ;
    point.title = @"NCU" ;
    point.subTitle = @"Zombie in the Montain";
    point.mapDescription = @"long time ago, zombie .......";
    point.image = [UIImage imageNamed:@"gameMap_01.jpg"] ;

    CLLocation *location1 = [[CLLocation alloc]initWithLatitude:24.969836 longitude:121.191177];
    CLLocation *location2 = [[CLLocation alloc]initWithLatitude:24.967451 longitude:121.190496];
    CLLocation *location3 = [[CLLocation alloc]initWithLatitude:24.967909 longitude:121.193233];
//    CLLocation *location4 = [[CLLocation alloc]initWithLatitude:22 longitude:33];
//    CLLocation *location5 = [[CLLocation alloc]initWithLatitude:22 longitude:33];
//    CLLocation *location6 = [[CLLocation alloc]initWithLatitude:22 longitude:33];

    [point.targetLocate addObject:location1] ;
    [point.targetLocate addObject:location2] ;
    [point.targetLocate addObject:location3] ;
    [_levelMapPoints addObject:point] ;
}

@end
