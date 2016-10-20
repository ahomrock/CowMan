//
//  MainViewController.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/18.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "MainViewController.h"
#import "AH_LocationManager.h"

@interface MainViewController () {
    AH_LocationManager *ah_locationPoint;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[AH_LocationManager create] start];


    ah_locationPoint = [AH_LocationManager create];
    [ah_locationPoint clear] ;
    // Add the image to be used as the compass on the GUI
//    [ah_locationPoint setArrowImageView:mainStateView];
//    [ah_locationPoint setDistanceLabel:labelHeading] ;
    // Set the coordinates of the location to be used for calculating the angle
    ah_locationPoint.latitudeOfTargetedPoint = 24.967937;
    ah_locationPoint.longitudeOfTargetedPoint = 121.191774 ;
    [ah_locationPoint start] ;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
