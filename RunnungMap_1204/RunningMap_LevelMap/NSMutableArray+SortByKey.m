//
//  NSMutableArray+SortByKey.m
//  RunningBoy
//
//  Created by 王柏竣 on 2016/11/30.
//  Copyright © 2016年 Croly. All rights reserved.
//

#import "NSMutableArray+SortByKey.h"

@implementation NSMutableArray (SortByKey)


-(NSMutableArray*)sortByKey:(NSString *)keyString withArray:(NSMutableArray *)keyArray {
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyString ascending:TRUE];
    
    [keyArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return keyArray ;
}

@end
