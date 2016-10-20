//
//  InternetDetection.h
//  RunningMap_LevelMap
//
//  Created by 陳育賢 on 2016/10/15.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface InternetDetection : UIViewController
{
    Reachability *internetReach;
}
- (void) internet ;
@end
