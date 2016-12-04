//11111
//  NSNotificationCenter+HardCode.h
//  RunningBoy
//
//  Created by 王柏竣 on 2016/12/2.
//  Copyright © 2016年 Croly. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOT_REMOVE                      @"RemoveData"
#define NOT_RELOAD                      @"ReloadData"
#define ACTIVITY_DATE_KEY               @"activityDate"


// SQL
#define ACT_FRIEND                      @"act_friend"
#define ACT_LEVEL                       @"act_level"
#define ACT_TIME                        @"act_time"
#define ACT_KEY                         @"act_key"
#define ACT_ID                          @"act_id"


#define DBFILENAME @"ActLog.sqlite"
#define ACTIVITY @"CREATE TABLE IF NOT EXISTS activity_table(act_id integer primary key autoincrement,act_friend varchar (200),act_level varchar (200),act_time date,act_key varchar (200))"
#define INSERT_ACTIVITY_SQL @"INSERT INTO activity_table(act_friend,act_level,act_time,act_key) VALUES(?,?,?,?)"

#define SELECT_ACTIVITY_SQL @"SELECT * from activity_table"

#define DELETE_TABLE_SQL @"DELETE FROM activity_table WHERE act_id = 1 "

#define ACT_ID @"SELECT TOP 1 FROM activity_table ORDER BY act_id DESC limit 1"

//SELECT TOP 1 act_id FROM activity_table ORDER BY act_id DESC;
@interface NSNotificationCenter (HardCode)

@end
