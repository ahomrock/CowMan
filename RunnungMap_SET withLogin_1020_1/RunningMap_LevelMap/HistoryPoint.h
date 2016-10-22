//
//  HistoryPoint.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/16.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryPoint : NSObject

@property(nonatomic,strong)NSString *mapTitle ;
@property(nonatomic,strong)NSString *totalTime ;
@property(nonatomic,strong)NSMutableArray *locationPaths ;
@property(nonatomic,strong)NSMutableArray *locationPathTimeStamp ;
@property(nonatomic,strong)NSMutableArray *allLocations ;



@end
