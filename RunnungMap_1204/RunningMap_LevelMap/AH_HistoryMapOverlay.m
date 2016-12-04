//
//  AH_HistoryMapOverlay.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/28.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "AH_HistoryMapOverlay.h"

@implementation AH_HistoryMapOverlay

@synthesize coordinate;
@synthesize boundingMapRect;

- (instancetype)initWithHistoryMap:(AH_HistoryMapSet *)historyMap {
    self = [super init];
    if (self) {
        boundingMapRect = historyMap.overlayBoundingMapRect;
        coordinate = historyMap.midCoordinate;
    }

    return self;
}
@end
