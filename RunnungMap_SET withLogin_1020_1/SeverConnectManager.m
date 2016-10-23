//
//  SeverConnectManager.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/23.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "SeverConnectManager.h"
#import "HistoryDataManager.h"
#import "LevelMapsManager.h"
#import <Firebase.h>
#import <CoreLocation/CoreLocation.h>
//static dispatch_once_t onceToken;
//dispatch_once(&onceToken, ^{
//    hdManager = [[HistoryDataManager alloc]init ] ;
//    hdManager.historyPoints = [NSMutableArray new] ;
//    
//});
//
//return hdManager ;
@implementation SeverConnectManager
{
    NSArray * tmpArray;
}

+ (instancetype)sharedInstance {
    static SeverConnectManager *serverConnectManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serverConnectManager = [[SeverConnectManager alloc]init];
        serverConnectManager.firbaseCoordinate = [NSArray new];
        
        
    });
    
    return serverConnectManager;
    
}


-(void)setMapsData {
    
    //連結Firebase 資料庫
    FIRDatabaseReference *ref = [[[FIRDatabase database]reference]child:@"NCUcoordinate"];
    
    FIRDatabaseQuery *query = [ref queryOrderedByChild:@"pointCount"];
    
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *coordinate = snapshot.value;
//        NSLog(@" query firebase = %@ ",  coordinate );
  
        _firbaseCoordinate = [coordinate allValues] ;
        NSMutableArray *arrr = [self createLMPointWithDatas:_firbaseCoordinate];
        
        [[LevelMapsManager sharedInstance].levelMapPoints addObject: arrr];
        
        NSLog(@" query firebase = %@ ",  _firbaseCoordinate );
 
        
    }];
    
    
    
    
    
}


// for test
- (NSMutableArray*)createLMPointWithDatas:(NSArray*)datas {
    NSMutableArray *resoultArray = [NSMutableArray new] ;
    
    LevelMapPoint *point = [LevelMapPoint new] ;
    _firseTitle = [_firbaseCoordinate[0] objectForKey:@"title"];
    _firseSubTitle = [_firbaseCoordinate[0] objectForKey:@"subTitle"];
    _firseMapDescription = [_firbaseCoordinate[0] objectForKey:@"subTitle"];
    
    point.title = _firseTitle ;
    point.subTitle = _firseSubTitle;
    point.mapDescription = _firseMapDescription;
    point.image = [UIImage imageNamed:@"gameMap_01.jpg"] ;
    
            for (int i =0; i<_firbaseCoordinate.count; i++) {
    
                _getFirebaseLatitude = [_firbaseCoordinate[i] objectForKey:@"latitude"];
                _getFirebaseLongitude = [_firbaseCoordinate[i] objectForKey:@"longitude"];
                _getPointCount = [_firbaseCoordinate[i] objectForKey:@"pointCount"];
    
    
                CLLocation *tempLocate = [[CLLocation alloc]initWithLatitude: [_getFirebaseLatitude doubleValue] longitude: [_getFirebaseLongitude doubleValue] ];
    
                NSLog(@"latAaaaa: %@",tempLocate);
                [point.targetLocate addObject:tempLocate] ;
            }

//    CLLocation *location1 = [[CLLocation alloc]initWithLatitude:24.970027 longitude:121.193490];
//    CLLocation *location2 = [[CLLocation alloc]initWithLatitude:24.967451 longitude:121.190496];
//    CLLocation *location3 = [[CLLocation alloc]initWithLatitude:24.967909 longitude:121.193233];
    
    
    
//    [point.targetLocate addObject:location2] ;
//    [point.targetLocate addObject:location3] ;
    
    [resoultArray addObject:point];
    
    return resoultArray ;
    
}
-(void)uploadHistoryData {
}

-(void)downloadHistoryData {
}

@end
