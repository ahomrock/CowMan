//
//  LevelMapsManager.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/22.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "LevelMapsManager.h"
#import <CoreLocation/CoreLocation.h>
#import "GetFirebaseCoordinate.h"
#import <Firebase.h>

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
    
    
    
    
    
//    GetFirebaseCoordinate * getFirCoordinate = [GetFirebaseCoordinate alloc];
//    
    //連結Firebase 資料庫
    FIRDatabaseReference *ref = [[[FIRDatabase database]reference]child:@"coordinate"];
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *coordinate = snapshot.value;
        //讀出Firbase裡的coordinate類別欄資料庫

            
            for (NSString * pointCount in coordinate) {
                _firebaseCoordinate = coordinate[pointCount];
//                NSLog(@"%@",_firebaseCoordinate[@"pointCount"]);
//                NSLog(@"%@",_firebaseCoordinate[@"latitude"]);
//                NSLog(@"%@",_firebaseCoordinate[@"longitude"]);
                
                _getPointCount = [coordinate objectForKey:@"pointCount"];
                _getFirebaseLatitude = [coordinate objectForKey:@"latitude"];
                _getFirebaseLongitude = [coordinate objectForKey:@"longitude"];
                
                numberFIRpoint = [ _getPointCount intValue];
                numberFIRLatitude = [ _getFirebaseLatitude doubleValue];
                numberFIRLongitude = [_getFirebaseLongitude doubleValue];
                
                
                NSLog(@"where is Latitude %f:",numberFIRLatitude);
                NSLog(@"where is Longitude %f:",numberFIRLongitude );

            }
        

        
        
//        列印與存入和pointCount同層的資料

        
    }];

//            
            CLLocation *location1 = [[CLLocation alloc]initWithLatitude:24.970027 longitude:121.193490];
//            CLLocation *location2 = [[CLLocation alloc]initWithLatitude:24.967451 longitude:121.190496];
//            CLLocation *location3 = [[CLLocation alloc]initWithLatitude:24.967909 longitude:121.193233];
//                CLLocation *location4 = [[CLLocation alloc]initWithLatitude:numberFIRLatitude longitude:numberFIRLongitude];
            //    CLLocation *location5 = [[CLLocation alloc]initWithLatitude:22 longitude:33];
            //    CLLocation *location6 = [[CLLocation alloc]initWithLatitude:22 longitude:33];
            
            [point.targetLocate addObject:location1] ;
//            [point.targetLocate addObject:location2] ;
//            [point.targetLocate addObject:location3] ;
//            [point.targetLocate addObject:location4] ;
    

    
    
    [_levelMapPoints addObject:point];
    

//
//
////    NSString * getFirebaseLatitude;
////    NSString * getFirebaseLongitude;
////    NSString * getPointCount;

////    GetFirebaseCoordinate * getFirCoordinate = [GetFirebaseCoordinate alloc];
////    
////    for (NSString * pointCount in getFirCoordinate.firebaseCoordinate) {
////        
////        NSDictionary * each = getFirCoordinate.firebaseCoordinate[pointCount];
////        //讀出Firbase裡的coordinate類別欄資料庫
////        getPointCount = each[@"pointCount"];
////        getFirebaseLatitude = each[@"latitude"];
////        getFirebaseLongitude = each[@"longitude"];
////        
//        numberLatitude = [getFirCoordinate.getFirebaseLatitude integerValue];
//        numberLongitude = [getFirCoordinate.getFirebaseLongitude integerValue];
//        NSLog(@"%@",each[@"pointCount"]);
//        NSLog(@"%@",each[@"latitude"]);
//        NSLog(@"%@",each[@"longitude"]);

    
            

    
}

@end
