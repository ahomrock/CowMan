//
//  NSUserDefaults+Extension.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/14.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GROUP_SUITE_NAME @"group.aHom.RunningMapExtensionSharingDefaults"

#define GROUP_GAME_STATE_INTEGER @"group_game_state"
#define GROUP_TARGETINDEX_INTEGER @"group_targetIndex"
#define GROUP_TOTALTARGET_INTEGER @"group_totaltarget"
#define GROUP_TARGET_LAT_DOUBLE @"group_target_lat"
#define GROUP_TARGET_LON_DOUBLE @"group_target_lon"

#define FACEBOOK_LOGIN_IN_UID @"facebook_uid"




typedef NS_ENUM(NSInteger,GAME_STATE) {
    GAME_STATE_GAMING = 0,
    GAME_STATE_NOT_IN_GAME
} ;


@interface NSUserDefaults (Extension)


@end
