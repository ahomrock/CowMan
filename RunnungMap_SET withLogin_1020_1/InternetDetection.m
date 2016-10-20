//
//  InternetDetection.m
//  RunningMap_LevelMap
//
//  Created by 陳育賢 on 2016/10/15.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "InternetDetection.h"


@implementation InternetDetection


//偵測網路連線並做提示
- (void) internet {
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"無法存取伺服器，請檢查網路是否連線" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
        
        return;
    }
    
}



@end
