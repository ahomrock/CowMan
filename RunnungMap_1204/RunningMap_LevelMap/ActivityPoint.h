//
//  ActivityPoint.h
//  RunningBoy
//
//  Created by 王柏竣 on 2016/11/12.
//  Copyright © 2016年 Croly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityPoint : NSObject
@property (nonatomic,strong) NSString * activityName;
@property (nonatomic,strong) NSString * activityLevel;
@property (nonatomic,strong) NSDate * activityDate;
@property (nonatomic,strong) NSString * actvityKey;
@property (nonatomic,strong) NSString * actvityID;


-(instancetype)initWithName:(NSString*) activityName
                  withLevel:(NSString*) activityLevel
                   withDate:(NSDate*)   activityDate
                    withKey:(NSString*) activityKey
                     withID:(NSString*) activityID;

@end
