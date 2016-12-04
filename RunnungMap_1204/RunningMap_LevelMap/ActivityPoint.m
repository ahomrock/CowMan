//
//  ActivityPoint.m
//  RunningBoy
//
//  Created by 王柏竣 on 2016/11/12.
//  Copyright © 2016年 Croly. All rights reserved.
//

#import "ActivityPoint.h"

@implementation ActivityPoint

-(instancetype)initWithName:(NSString *)activityName
                  withLevel:(NSString *)activityLevel
                   withDate:(NSDate *)activityDate
                    withKey:(NSString*) activityKey
                     withID:(NSString*) activityID
{
    
    self = [super init];
    
    _activityName = activityName;
    _activityLevel = activityLevel;
    _activityDate = activityDate;
    _actvityKey = activityKey;
    _actvityID = activityID;
    
    return self;
    
}

@end
