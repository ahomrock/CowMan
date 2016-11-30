//
//  AH_SQLiteManager.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/11/28.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AH_SQLiteManager : NSObject

+(instancetype)sharedInstance ;

- (void)copyHistoryPointToSqlite ;

@end
