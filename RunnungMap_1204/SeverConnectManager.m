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

       // [serverConnectManager setMapsData ];
        [[LevelMapsManager sharedInstance] testDefaultSetting];
    });
    
    return serverConnectManager;
    
}


-(void)setMapsData {
    
    //連結Firebase 資料庫
    FIRDatabaseReference *ref = [[[FIRDatabase database]reference]child:@"NCUcoordinate"];
    
    FIRDatabaseQuery *query = [ref queryOrderedByChild:@"pointCount"];
    
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *coordinate = snapshot.value;
        NSLog(@" query firebase = %@ ",  coordinate );
  
        _firbaseCoordinate = [coordinate allValues] ;

        [LevelMapsManager sharedInstance].levelMapPoints =  [self createLMPointWithDatas:_firbaseCoordinate];
        
        NSLog(@" query firebase = %@ ",  _firbaseCoordinate );
 
        
    }];
    
    
    
    
    
}


// for test
- (NSMutableArray*)createLMPointWithDatas:(NSArray*)datas {
    NSMutableArray *resoultArray = [NSMutableArray new] ;
    
    LevelMapPoint *point = [LevelMapPoint new] ;
    point.title = [_firbaseCoordinate[0] objectForKey:@"title"];
    point.subTitle = [_firbaseCoordinate[0] objectForKey:@"subTitle"];
    point.mapDescription = [_firbaseCoordinate[0] objectForKey:@"mapDescription"];

    point.image = [UIImage imageNamed:@"gameMap_01.jpg"] ;
    point.targetLocate = [NSMutableArray new] ;
    double tempLat = 0;
    double tempLon = 0 ;
    for (int i =0; i<_firbaseCoordinate.count; i++) {

        tempLat = [[_firbaseCoordinate[i] objectForKey:@"latitude"] doubleValue] ;
        tempLon = [[_firbaseCoordinate[i] objectForKey:@"longitude"] doubleValue];
        _getPointCount = [_firbaseCoordinate[i] objectForKey:@"pointCount"];
    
    
        CLLocation *tempLocate = [[CLLocation alloc]initWithLatitude: tempLat longitude: tempLon ];

        [point.targetLocate addObject:tempLocate] ;
    }


    
    [resoultArray addObject:point];
    
    return resoultArray ;
    
}
-(void)uploadHistoryData {
    
    NSUserDefaults * save = [NSUserDefaults standardUserDefaults];
    NSString *fullName = [save objectForKey:@"fullName"];
    NSString *email = [save objectForKey:@"email"];
    NSString * saveTotalTime ;
    NSString * map = @"NCU";
    
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];

    
    NSArray * show ;
    show = [HistoryDataManager sharedInstance].historyPoints;
    
    
    for (int i = 0 ; i < show.count ; i++ ) {
        NSLog(@"TIME : %@",[show[show.count -1]  totalTime] ) ;
        saveTotalTime = [show[show.count -1]  totalTime] ;
        
    }
        NSLog(@"TIME : %@", saveTotalTime) ;
    // SLog(@"scdvf: %@",show);
    
    FIRDatabaseReference *ref = [[FIRDatabase database]reference ];

    NSString *key = [[ref child:@"HistoryData"] childByAutoId].key;

    NSDictionary *point = @{@"UserName": fullName,
                            @"Email": email,
                            @"TotalTime": saveTotalTime,
                            @"Map": map,
                            @"Date": dateString,
                            };

    NSDictionary *uploadHistory = @{[@"/HistoryData/" stringByAppendingString:key]: point};

    [ref updateChildValues:uploadHistory withCompletionBlock:^(NSError *error, FIRDatabaseReference  *ref){
        if (!error) {
            NSLog(@" 更新成功");
        } else {
            NSLog(@" 更新失敗");
        }
    }];
    
    
}

-(void)downloadHistoryData {
    
    
    
}

@end
