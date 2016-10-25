//
//  LevelMapsManager.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/22.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "LevelMapPoint.h"

@interface LevelMapsManager : LevelMapPoint
{
    
    int numberFIRpoint;
}
@property (nonatomic,strong) NSMutableArray *levelMapPoints ;
@property (strong, nonatomic) NSDictionary * firebaseCoordinate;
@property (strong, nonatomic) NSString * getFirebaseLatitude;
@property (strong, nonatomic) NSString * getFirebaseLongitude;
@property (strong, nonatomic) NSString * getPointCount;

+(instancetype)sharedInstance ;

- (void)testDefaultSetting ;

// - (void)defaultSetting;


-(NSString*)targetPointLabelTextWithMap:(int)map withIndex:(int)targetIndex ;
@end
