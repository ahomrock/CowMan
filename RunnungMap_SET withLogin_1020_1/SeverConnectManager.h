//
//  SeverConnectManager.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/23.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryDataManager.h"
#import "LevelMapsManager.h"


@interface SeverConnectManager : NSObject

@property(nonatomic,strong) NSArray *firbaseCoordinate;
@property (strong, nonatomic) NSString * getFirebaseLatitude;
@property (strong, nonatomic) NSString * getFirebaseLongitude;
@property (strong, nonatomic) NSString * getPointCount;

-(void)setMapsData;
-(void)uploadHistoryData;
+ (instancetype)sharedInstance ;
@end
