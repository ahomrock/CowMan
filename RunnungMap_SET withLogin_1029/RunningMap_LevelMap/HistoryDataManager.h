//
//  HistoryDataManager.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/16.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryPoint.h"

/**
 historyPoints store historyPoint (contain Paths, timeStamp, totalTime, mapTitle)
 message for KVO that change message and HistoryViewController.table will reloadDate

 selectPoint when  HistoryViewController.table select the CELL,and selectPoint will save what the USER select to Present the Datas(Paths Title..) to MapViewController 
 */
@interface HistoryDataManager : NSObject

@property(nonatomic,strong)NSMutableArray *historyPoints ;

@property (nonatomic,strong)NSString *message ;
@property(nonatomic,strong)HistoryPoint *selectPoint ;

+ (instancetype)sharedInstance ;

@end
