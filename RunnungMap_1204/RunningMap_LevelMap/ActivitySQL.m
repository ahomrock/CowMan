//1111111
//  ActivitySQL.m
//  RunningBoy
//
//  Created by 王柏竣 on 2016/12/2.
//  Copyright © 2016年 Croly. All rights reserved.
//

#import "ActivitySQL.h"
#import "ActivityManager.h"
#import "FMDB.h"
#import "NSNotificationCenter+HardCode.h"
#import "NSMutableArray+SortByKey.h"


@interface ActivitySQL()
{
    NSString * dbFileName;
    
    FMDatabase * db;
    
    
    NSString * name ;
    NSString * level ;
    NSDate * date ;
    NSString * key ;
    NSMutableDictionary * dayPointSQL;
    ActivityManager *actManager;
}

@end

@implementation ActivitySQL

+(instancetype) sharedInstance
{
    static ActivitySQL * manger = nil ;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manger = [[ActivitySQL alloc]init];
        
    });
    
    return manger;
    
}

-(instancetype)init
{
    self = [super init];
    
    NSURL * cachesURL = [[NSFileManager defaultManager]URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject;
    
    NSURL * dbFileURL = [cachesURL URLByAppendingPathComponent:DBFILENAME];
    
    dbFileName = dbFileURL.path;
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! : %@",dbFileName) ;
    db = [FMDatabase databaseWithPath:dbFileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbFileName] == false) {
        
        if ([db open]) {
            
            Boolean success = [self createTable];
            
            NSLog(@"Creat DB Table: %@",success?@"OK":@"Fail");
            [db close] ;
        }
        
    } else {
        
        [self getActivity] ;
    }
    
    return self;
    
}
    
- (bool) createTable
{
    if ([db executeUpdate:ACTIVITY])
    {
        return true;
    }
    return false;
}

-(void) getActivity
{
    if ([db open])
    {
        
        FMResultSet * result = [db executeQuery:SELECT_ACTIVITY_SQL];

        ActivityPoint * point;
        
        NSString * act_friend_sql = @"";
        NSString * act_level_sql = @"";
        NSDate * act_date_sql = 0;
        NSString * act_key_sql = @"";
        NSString * act_ID_sql = @"";
        
        actManager = [ActivityManager sharedInstance];
        
        dayPointSQL = [NSMutableDictionary new];
        
        while ([result next])
        {
            
            act_friend_sql = [result stringForColumn:ACT_FRIEND];
            act_level_sql = [result stringForColumn:ACT_LEVEL];
            act_date_sql = [result dateForColumn:ACT_TIME];
            act_key_sql = [result stringForColumn:ACT_KEY];
            act_ID_sql = [result stringForColumn:ACT_ID];
            
            point = [[ActivityPoint alloc] initWithName:act_friend_sql withLevel:act_level_sql withDate:act_date_sql withKey:act_key_sql withID:act_ID_sql];
            
            NSLog(@"nkjnfjbkdfn  %@  :  %@   %@ ,%@,%@",act_friend_sql,act_level_sql,act_date_sql , act_key_sql,act_ID_sql ) ;
            
            NSMutableArray * pointArraySQL ;
            
            if (!dayPointSQL[act_key_sql])
            {
                
                pointArraySQL = [NSMutableArray new];
                
            }   else    {
                
                pointArraySQL = dayPointSQL[act_key_sql];
                
            }
            
            [pointArraySQL addObject:point];
            
            pointArraySQL = [pointArraySQL sortByKey:ACTIVITY_DATE_KEY withArray:pointArraySQL];

            [dayPointSQL setObject:pointArraySQL forKey:act_key_sql];

            actManager.dayPoint = dayPointSQL;
            
//            [actManager printAllDatas] ;
            
        }
                
        NSLog(@"zxcshbdhbwejh OUT OF WHILE:") ;
//        [ actManager printAllDatas] ;
    }
    
        [db close];
    
}

-(BOOL) saveActivityWithFriend:(NSString*)act_friend
                     WithLevel:(NSString*)act_level
                      WithDate:(NSDate*)act_date
                       WithKey:(NSString*)act_key
{
    if ([db executeUpdate:INSERT_ACTIVITY_SQL,act_friend,act_level,act_date,act_key])
    {
     
        return true;
        
    }
    
    return false;
    
}

-(void) savePoint
{
    
    if ([db open]) {
        
        ActivityManager * actPoint = [ActivityManager sharedInstance];
        
        NSString * act_friend = actPoint.act_friend;
        
        NSString * act_level = actPoint.act_level;
        
        NSDate * act_date = actPoint.act_date;
        
        NSString * act_Key = actPoint.act_key;
        
        bool success = [self saveActivityWithFriend:act_friend WithLevel:act_level WithDate:act_date WithKey:act_Key];
        
        if (success) {
            
            NSLog(@"OK");
            
        }   else    {
            
            NSLog(@"FAIL");
            
        }
        
    }

    [db close];
    
}

-(void) delecteAct
{
    if ([db open]) {
    
        
        
        int value = [actManager.act_id intValue];
        
        [db executeUpdate:@"delete from activity_table WHERE act_id = 11"];
    
        NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",actManager.act_id);
        
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!!%d",value);
        
        
    }
    
    [db close];
    
}



@end
