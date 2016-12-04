//
//  RankingPoint.h
//  LevelRankingCountingTime
//
//  Created by NO KR on 2016/9/24.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RankingPoint : NSObject


@property (nonatomic,assign) NSInteger rankingID ;
@property (nonatomic,strong) NSString *userName ;
@property (nonatomic,strong) NSString *userBestRecord ;
@property (nonatomic,assign) NSInteger rankingByType ;

@end
