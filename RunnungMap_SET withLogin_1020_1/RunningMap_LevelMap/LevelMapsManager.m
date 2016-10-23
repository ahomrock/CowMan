//
//  LevelMapsManager.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/22.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "LevelMapsManager.h"
#import "GetFirebaseCoordinate.h"
#import <Firebase.h>
#import <CoreLocation/CoreLocation.h>
#import "SeverConnectManager.h"
@implementation LevelMapsManager
{
    double runLatDou ;
    double runLonDou ;
    CLLocationDegrees cllocationlati ;
    CLLocationDegrees cllocationlone ;
    SeverConnectManager * scm ;
    
}

+(instancetype)sharedInstance {
    static LevelMapsManager *lmManager = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lmManager = [[LevelMapsManager alloc]init ] ;
        lmManager.levelMapPoints = [NSMutableArray new] ;

    });
    
    // for test
//    [lmManager testDefaultSetting] ;
    
    // for real
//    [lmManager defaultSetting] ;
    

    return lmManager ;
}


- (void)defaultSetting {
    LevelMapPoint *point = [LevelMapPoint new] ;
    point.title = @"NCU" ;
    point.subTitle = @"Zombie in the Montain";
    point.mapDescription = @"long time ago, zombie .......";
    point.image = [UIImage imageNamed:@"gameMap_01.jpg"] ;
    
  
    

   
            
            CLLocation *location1 = [[CLLocation alloc]initWithLatitude:24.970027 longitude:121.193490];
            //      CLLocation *location2 = [[CLLocation alloc]initWithLatitude:24.967451 longitude:121.190496];
            //      CLLocation *location3 = [[CLLocation alloc]initWithLatitude:24.967909 longitude:121.193233];
            CLLocation *location4 = [[CLLocation alloc]initWithLatitude:runLatDou longitude:runLonDou];
            //    CLLocation *location5 = [[CLLocation alloc]initWithLatitude:22 longitude:33];
            //    CLLocation *location6 = [[CLLocation alloc]initWithLatitude:22 longitude:33];
            
            [point.targetLocate addObject:location1] ;
            //            [point.targetLocate addObject:location2] ;
            //            [point.targetLocate addObject:location3] ;

  
    
            [point.targetLocate addObject:location4] ;

    
            NSLog(@"location1: %@",location1);
            NSLog(@"location4: %@",location4);
    
            [_levelMapPoints addObject:point];
    



}

// for test
- (void)testDefaultSetting {
    LevelMapPoint *point = [LevelMapPoint new] ;
    point.title = @"NCU" ;
    point.subTitle = @"Zombie in the Montain";
    point.mapDescription = @"long time ago, zombie .......";
    point.image = [UIImage imageNamed:@"gameMap_01.jpg"] ;

    CLLocation *location1 = [[CLLocation alloc]initWithLatitude:24.970027 longitude:121.193490];
    CLLocation *location2 = [[CLLocation alloc]initWithLatitude:24.967451 longitude:121.190496];
    CLLocation *location3 = [[CLLocation alloc]initWithLatitude:24.967909 longitude:121.193233];


    [point.targetLocate addObject:location1] ;
    [point.targetLocate addObject:location2] ;
    [point.targetLocate addObject:location3] ;

    [_levelMapPoints addObject:point];
}


-(NSString*)targetPointLabelTextWithMap:(int)map withIndex:(int)targetIndex {
//    CLLocation *theTarget = [self.levelMapPoints[0] targetLocate][targetIndex] ;
//
    // Create the image for the compass

    NSString *targetLabelTitle = [NSString stringWithFormat:@"%d / %d",targetIndex,(int)[[self.levelMapPoints[0] targetLocate] count]] ;
    return targetLabelTitle ;
}
@end
