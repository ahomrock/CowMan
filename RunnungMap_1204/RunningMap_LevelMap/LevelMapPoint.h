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

@property(nonatomic,strong)NSString *map_id;
@property (nonatomic,strong) NSString *title ;
@property (nonatomic,strong) NSString *subTitle ;
@property (nonatomic,strong) NSString *mapDescription ;
@property (nonatomic,strong) NSString *map_targetLocate_id ;
@property (nonatomic,strong) NSString *map_imageFileName ;
@property (nonatomic,strong) NSString *map_selectMapFileName ;


@property (nonatomic,strong) NSMutableArray *targetLocate ;

@property (nonatomic,strong) UIImage * image ;
@property (nonatomic,strong) NSMutableArray * rankingBySpeeds ;

@end
