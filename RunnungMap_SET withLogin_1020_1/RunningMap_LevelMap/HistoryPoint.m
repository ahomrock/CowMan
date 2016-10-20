//
//  HistoryPoint.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/16.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "HistoryPoint.h"

@implementation HistoryPoint



- (instancetype)init {
    self = [super init] ;
    self.locationPaths = [NSMutableArray new];
    self.locationPathTimeStamp = [NSMutableArray new] ;
    return self ;
}

@end
