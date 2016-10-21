//
//  CLLocation+CoordinateToImage.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/21.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
@interface CLLocation (CoordinateToImage)

-(CGPoint)getPointWithRealLocateA:(CLLocation*)realLocateA
                   witRealLocateB:(CLLocation*)realLocateB
                 withTargetLocate:(CLLocation*)targetLocate
                  withImagePointA:(CGPoint)imagePointA
                  withImagePointB:(CGPoint)imagePointB ;
@end
