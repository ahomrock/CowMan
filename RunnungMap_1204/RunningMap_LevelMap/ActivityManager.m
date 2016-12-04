//
//  ActivityManager.m
//  RunningBoy
//
//  Created by 王柏竣 on 2016/11/12.
//  Copyright © 2016年 Croly. All rights reserved.
//

#import "ActivityManager.h"

@implementation ActivityManager

+(instancetype)sharedInstance   {
    
    static ActivityManager * manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ 
        
        manager = [[ActivityManager alloc]init];
        manager.dayPoint = [NSMutableDictionary new];
        manager.selecte = [NSString new];
        manager.rows = 0;
        manager.comefromtab = false;
        manager.act_friend = [NSString new];
        manager.act_level = [NSString new];
        manager.act_date = [NSDate new];
        manager.act_key = [NSString new];
        
        
        
    });
    
    return manager;
    
}



-(bool)isExistAct_Key:(NSString*)act_keyStr {
    bool isExist = false ;
    for(int i = 0 ; i < _dayPoint.allKeys.count ; i ++ ){
        if( [act_keyStr isEqualToString:_dayPoint.allKeys[i]]) {
            isExist = true ;
        }
    }
    
    return isExist ;
}


-(void)printAllDatas {
    
    if(_dayPoint.allKeys.count == 0 ){
        return ;
        
        
        
    }
    
    
    for(int i = 0 ; i < _dayPoint.allKeys.count ; i ++ ){
        NSArray*array = _dayPoint[_dayPoint.allKeys[i] ];
        for(int j = 0 ; j < array.count ; j++) {
            ActivityPoint *point =  array[j];
            NSLog(@"===== PRINT DATA=======") ;
            NSLog(@"zxjkn key :%@", point.actvityKey) ;
            NSLog(@"xkxcjnv %@",point.activityName) ;
            NSLog(@"czxc : %@", point.activityDate) ;
            NSLog(@"czx : %@" , point.activityDate) ;
        }
        array = nil ;
    }
}






@end
