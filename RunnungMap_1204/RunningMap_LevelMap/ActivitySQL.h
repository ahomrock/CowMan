//
//  ActivitySQL.h
//  RunningBoy
//
//  Created by 王柏竣 on 2016/12/2.
//  Copyright © 2016年 Croly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivitySQL : NSObject

+(instancetype) sharedInstance;

-(void)savePoint;

-(void)delecteAct;

@end
