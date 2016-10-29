//
//  RunInMapView.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/27.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "RunInMapView.h"
#import "CLLocation+CoordinateToImage.h"
#import "HistoryDataManager.h"

#import <CoreLocation/CoreLocation.h>
@interface RunInMapView() {
    HistoryDataManager *hDatamanager ;
    NSArray *allLocates ;
}


@property (strong, nonatomic) CAShapeLayer  *route ;

@property (strong, nonatomic) CAShapeLayer *signpost ;


@end


@implementation RunInMapView


- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image] ;

    if(self) {

        [self.layer addSublayer:self.route];
        [self.layer addSublayer:self.signpost] ;
       // [self setupAnimation];
    }

    return self ;
}


- (void)defaultSetting {
    hDatamanager = [HistoryDataManager sharedInstance] ;
   // allLocates = [hDatamanager.historyPoints[0] allLocations] ;

    CLLocation *loca0 =  [[CLLocation alloc]initWithLatitude:24.966756
                                                   longitude:121.191202 ] ;

    CLLocation *loca1 =  [[CLLocation alloc]initWithLatitude:24.966782
                                                   longitude:121.192157] ;

     CLLocation *loca2 =  [[CLLocation alloc]initWithLatitude:24.967915
                                                    longitude:121.192157] ;

    CLLocation *loca3 =  [[CLLocation alloc]initWithLatitude:24.967915
                                                   longitude:121.193216] ;

     CLLocation *loca4 =  [[CLLocation alloc]initWithLatitude:24.966755
                                                    longitude:121.192642] ;

    CLLocation *loca5 = [ [CLLocation alloc]initWithLatitude:24.966729
                                                   longitude:121.195406] ;
    allLocates = [NSArray arrayWithObjects:loca0,loca1,loca2,loca3,loca4,loca5, nil] ;


    //for(int i = 0 ; i <allLocates.count - 1;i++ ) {
        [self routeWithLocate:allLocates[0] withDestinateLocate:allLocates[5] ];
   // }
    [self.layer addSublayer:self.route];
    [self.layer addSublayer:self.signpost] ;
}


- (CAShapeLayer *)routeWithLocate:(CLLocation*)beginLocate withDestinateLocate:(CLLocation*)destinateLocate{
    if (!_route) {
        _route = [CAShapeLayer layer];


        CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
        CGPoint pathBegin = [self createTargetPointWithLat:beginLocate.coordinate.latitude withLon:beginLocate.coordinate.longitude] ;

        NSLog(@" dfsdfsdvxc : %f,%f" ,pathBegin.x,pathBegin.y) ;



        CGPoint path1 = [self createTargetPointWithLat:[allLocates[1] coordinate].latitude withLon:[allLocates[1] coordinate].longitude] ;


        CGPoint path2 = [self createTargetPointWithLat:[allLocates[2] coordinate].latitude withLon:[allLocates[2] coordinate].longitude] ;


        CGPoint path3 = [self createTargetPointWithLat:[allLocates[3] coordinate].latitude withLon:[allLocates[3] coordinate].longitude] ;


        CGPoint path4 = [self createTargetPointWithLat:[allLocates[4] coordinate].latitude withLon:[allLocates[4] coordinate].longitude] ;
//
//
        CGPoint pathEnd = [self createTargetPointWithLat:destinateLocate.coordinate.latitude withLon:destinateLocate.coordinate.longitude] ;
//

//
        UIBezierPath *path = [UIBezierPath bezierPath];


        [path moveToPoint:CGPointMake(pathBegin.x , pathBegin.y)];

//         起点
//        [path moveToPoint:CGPointMake( 187.368164, 77.232635)];

        // 绘制线条
        [path addLineToPoint:CGPointMake(path1.x, path1.y)];
        [path addLineToPoint:CGPointMake(path2.x, path2.y)];
        [path addLineToPoint:CGPointMake(path3.x, path3.y)];
        [path addLineToPoint:CGPointMake(path4.x, path4.y)];
        [path addLineToPoint:CGPointMake(pathEnd.x, pathEnd.y)];

       // [path addLineToPoint:center] ;

//        NSLog(@"ZXasdascxzc :x %f, y:%f" ,pathEnd.x,p.y) ;

       // [path closePath];//第五条线通过调用closePath方法得到的

        //根据坐标点连线
        [path stroke];
        //[aPath fill];
//        [path appendPath:line] ;
        _route.borderColor = [UIColor blackColor].CGColor;
        _route.lineWidth = 5.f;
        _route.path = path.CGPath;
        _route.fillColor = [UIColor clearColor].CGColor;
        _route.strokeColor = [UIColor whiteColor].CGColor;
    }
    return _route;

}

- (void)setupAnimation {
    self.route.lineWidth = 20.f;
    self.route.strokeStart = 0.5f;
    self.route.strokeEnd = 0.5f;
}

- (void)animationWith:(CGFloat)y {



}




- (CGPoint) createTargetPointWithLat:(CLLocationDegrees)targetLat withLon:(CLLocationDegrees)targetLon {



    CLLocation *tempLocation = [[CLLocation alloc] init];

    CGPoint mapLocateA = CGPointMake(187.500000, 216.000000) ;
    CGPoint mapLocateB = CGPointMake(187.368164, 77.232635);

    CLLocation *realLocateA =[ [CLLocation alloc ]initWithLatitude:24.968279 longitude:121.191944] ;
    CLLocation *realLocateB =[[CLLocation alloc]initWithLatitude:24.968253 longitude: 121.196541] ;

    CLLocation *targetLocate =[[CLLocation alloc]initWithLatitude:targetLat longitude: targetLon] ;

    CGPoint targetPoint = [tempLocation getPointWithRealLocateA:realLocateA
                                                 witRealLocateB:realLocateB
                                               withTargetLocate:targetLocate
                                                withImagePointA:mapLocateA
                                                withImagePointB:mapLocateB ] ;
    return targetPoint ;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
