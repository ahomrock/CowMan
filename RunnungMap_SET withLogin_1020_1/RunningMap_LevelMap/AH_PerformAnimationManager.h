//
//  AH_PerformAnimationManager.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/11.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define DURATION_DEFAULT 0.4


/**
 Perform Animation when We Need 
 */
@interface AH_PerformAnimationManager : NSObject


- (void)performAnimationWithType:(NSString*)type WithSubType:(NSString*)subType withView:(UIView*)view;

- (void)setDuration:(CFTimeInterval) duration ;


@end
