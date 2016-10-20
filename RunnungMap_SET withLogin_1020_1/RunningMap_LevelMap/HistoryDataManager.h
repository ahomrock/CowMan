//
//  HistoryDataManager.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/16.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryPoint.h"
#import <UIKit/UIKit.h>


@interface HistoryDataManager : NSObject

@property(nonatomic,strong)NSMutableArray *historyPoints ;
@property(nonatomic,strong)UITableView *tableView ;

@property (nonatomic,strong)NSString *message ;
@property(nonatomic,strong)HistoryPoint *selectPoint ;

+ (instancetype)sharedInstance ;

@end
