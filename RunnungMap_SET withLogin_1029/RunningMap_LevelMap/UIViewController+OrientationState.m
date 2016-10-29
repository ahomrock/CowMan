//
//  UIViewController+OrientationState.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/28.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "UIViewController+OrientationState.h"
#import "AppDelegate.h"

@implementation UIViewController (OrientationState)

-(void) restrictRotation:(BOOL) restriction {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

@end
