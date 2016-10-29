//
//  AH_HistoryMapOverlay.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/28.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AH_HistoryMapSet.h"
@class AH_HistoryMapSet ;

@interface AH_HistoryMapOverlay : NSObject<MKOverlay>

- (instancetype)initWithHistoryMap:(AH_HistoryMapSet *)historyMap;


@end
