//
//  CLLocation+bearing.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/10.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (bearing)


-(double) bearingToLocation:(CLLocation *) destinationLocation ;

@end
