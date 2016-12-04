//
//  AH_PerformAnimationManager.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/11.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "AH_PerformAnimationManager.h"



@implementation AH_PerformAnimationManager {
    CFTimeInterval ah_duration ;
}


-(void)performAnimationWithType:(NSString*)type WithSubType:(NSString*)subType withView:(UIView*)view {
    // Prepare Anaimation
    CATransition *transition = [CATransition animation] ;
    transition.duration  = DURATION_DEFAULT ; // ah_duration ;
    transition.timingFunction = [ CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn] ;
    transition.type = type ;
    transition.subtype = subType ;

    [view.layer addAnimation:transition forKey:nil] ;
}

- (void)setDuration:(CFTimeInterval)duration {
    ah_duration = duration ;
}

@end
