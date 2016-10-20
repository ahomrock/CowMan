//
//  LevelMapPoint.h
//  LevelRankingCountingTime
//
//  Created by NO KR on 2016/9/24.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "RankingPoint.h"
#import <UIKit/UIKit.h>
@interface LevelMapPoint : RankingPoint

@property (nonatomic,strong) NSString *title ;
@property (nonatomic,strong) NSString *subTitle ;
@property (nonatomic,strong) NSString *mapDescription ;
@property (nonatomic,strong) UILabel * image ;
@property (nonatomic,strong) NSMutableArray * rankingBySpeeds ;

@end
