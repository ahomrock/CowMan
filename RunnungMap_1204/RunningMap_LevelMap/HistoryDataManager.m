//
//  HistoryDataManager.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/16.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "HistoryDataManager.h"
#import "AH_SQLiteManager.h"
#import <CoreLocation/CoreLocation.h>
@interface HistoryDataManager()

@end

@implementation HistoryDataManager

+ (instancetype)sharedInstance {
    static HistoryDataManager *hdManager = nil ;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hdManager = [[HistoryDataManager alloc]init ] ;
        hdManager.historyPoints = [NSMutableArray new] ;

    });

    return hdManager ;
}


-(id)init {
    self = [super init] ;
    if (self) {
        _message =@"" ;
        [self setValue:_message forKeyPath:@"message"] ;
    }
    return self ;
}

-(void)setMessage:(NSString *)message {

    [self willChangeValueForKey:@"message"] ;
    _message = message ;
    [self didChangeValueForKey:@"message"] ;
    
}

@end
