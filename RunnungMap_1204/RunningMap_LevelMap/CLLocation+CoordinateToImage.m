//
//  CLLocation+CoordinateToImage.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/21.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "CLLocation+CoordinateToImage.h"

@implementation CLLocation (CoordinateToImage)


#pragma mark for map Image

-(CGPoint)getPointWithRealLocateA:(CLLocation*)realLocateA
                   witRealLocateB:(CLLocation*)realLocateB
                 withTargetLocate:(CLLocation*)targetLocate
                  withImagePointA:(CGPoint)imagePointA
                  withImagePointB:(CGPoint)imagePointB  {


    double latAB = realLocateA.coordinate.latitude - realLocateB.coordinate.latitude ;
    double latATarget = realLocateA.coordinate.latitude - targetLocate.coordinate.latitude ;
    double lengthAB_x = imagePointA.x - imagePointB.x ;
    double x = imagePointA.x - lengthAB_x*latATarget/latAB ;



    double lonAB = realLocateA.coordinate.longitude - realLocateB.coordinate.longitude ;
    double lonATarget = realLocateA.coordinate.longitude - targetLocate.coordinate.longitude ;
    double lengthAB_y = imagePointA.y - imagePointB.y ;
    double y = imagePointA.y - lengthAB_y*lonATarget/lonAB ;

    return CGPointMake(x, y) ;

}







@end
