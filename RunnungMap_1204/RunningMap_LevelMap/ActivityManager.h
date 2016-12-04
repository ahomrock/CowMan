//
//  ActivityManager.h
//  RunningBoy
//
//  Created by 王柏竣 on 2016/11/12.
//  Copyright © 2016年 Croly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityPoint.h"


@interface ActivityManager : NSObject
@property (nonatomic,strong) NSMutableDictionary * dayPoint;
@property (nonatomic) Boolean comefromtab;
@property (nonatomic,strong) NSString * selecte;                    // table 上點選
@property (nonatomic) NSInteger rows;                               // table 上 row

@property (nonatomic,strong) NSString * act_friend;
@property (nonatomic,strong) NSString * act_level;
@property (nonatomic,strong) NSDate * act_date;
@property (nonatomic,strong) NSString * act_key;
@property (nonatomic,strong) NSString * act_id;



+(instancetype)sharedInstance ;

-(bool)isExistAct_Key:(NSString*)act_keyStr ;
-(void)printAllDatas ;

@end
