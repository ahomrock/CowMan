//
//  NSMutableArray+SortByKey.h
//  RunningBoy
//
//  Created by 王柏竣 on 2016/11/30.
//  Copyright © 2016年 Croly. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSMutableArray (SortByKey)


-(NSMutableArray*)sortByKey:(NSString*)keyString withArray:(NSMutableArray*)keyArray;

@end
