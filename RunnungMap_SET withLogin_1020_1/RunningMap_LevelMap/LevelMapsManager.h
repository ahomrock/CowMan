//
//  LevelMapsManager.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/22.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "LevelMapPoint.h"

@interface LevelMapsManager : LevelMapPoint

@property (nonatomic,strong)NSMutableArray *levelMapPoints ;

+(instancetype)sharedInstance ;



- (void)defaultSetting;
@end
