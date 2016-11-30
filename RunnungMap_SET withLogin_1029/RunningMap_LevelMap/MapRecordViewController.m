//
//  MapRecordViewController.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/15.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "MapRecordViewController.h"
#import <MapKit/MapKit.h>
#import "AH_MapView.h"
#import "HistoryDataManager.h"


#import "UIViewController+OrientationState.h"



#define MAP01_CENTER  CLLocationCoordinate2DMake(24.967879, 121.192148)

@interface MapRecordViewController (){
    AH_MapView *ah_mapView ;

}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@end

@implementation MapRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ah_mapView = [AH_MapView createWithMKView:_mapView withVC:self] ;
//    [self restrictRotation:false];

}
- (IBAction)stopBtnPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:true] ;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
    //[self refreshBtnPressed:nil] ;
    [self setMap] ;
    if([_mapView respondsToSelector:@selector(camera)]) {
        MKMapCamera *newCamara = [[_mapView camera]copy] ;
        [newCamara setHeading:90.0] ;
        [_mapView setCamera:newCamara animated:NO] ;
    }


    [_mapView  setRotateEnabled:false ] ;
    [_mapView setZoomEnabled:false] ;
    [_mapView setScrollEnabled:false] ;



//    [self setMap] ;

}
- (IBAction)pinchGesture:(UIPinchGestureRecognizer *)sender {


//    if (sender.scale > 0 )
//        [_mapView setZoomEnabled:true] ;
}
- (void)setMap {
    CLLocationCoordinate2D center = MAP01_CENTER ;
    ah_mapView.mapCenter = center ;
    ah_mapView.historyPoint = [HistoryDataManager sharedInstance].selectPoint;
   // [ah_mapView prepareLoad] ;
    [ah_mapView startLoadMap] ;
    //[self.mapView reloadInputViews];
}

- (IBAction)refreshBtnPressed:(UIBarButtonItem *)sender {
    [self setMap] ;
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
