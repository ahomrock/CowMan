//
//  RunningViewController.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/9.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "RunningViewController.h"
#import "AH_LocationManager.h"
#import "AH_MapView.h"
#import "AH_PerformAnimationManager.h"
#import "RunningScrollView.h"

#import "CountDownViewController.h"

#import "HistoryDataManager.h"
#import "HistoryViewController.h"

#import "AH_PhotoDataManager.h"
#import "CLLocation+CoordinateToImage.h"

#import "LevelMapsManager.h"

#import "NSUserDefaults+Extension.h"
#import "RunningMap_LevelMap-Swift.h"

#import "SeverConnectManager.h"

#define MAP_INDEX 0
typedef NS_ENUM(NSInteger, MapLocateSIGN) {
    MapLocateSIGN_FORLOCATE_A ,
    MapLocateSIGN_FORLOCATE_B,
    MapLocateSIGN_TARGET
};

@interface RunningViewController (){
    IBOutlet UILabel *labelHeading;

    AH_LocationManager *ah_locationPoint;
    AH_MapView *ah_mapView ;
    UIImageView *secondStateView;
    UIImageView *mainStateView;

    AH_PerformAnimationManager *ah_PAManager ;

    HistoryPoint *historyPoint ;
    
    LevelMapsManager *lmManager ;

    int targetIndex ;
}


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *mapTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *targetPointLabel;
@property (weak, nonatomic) IBOutlet RunningScrollView *mainScrollView;


@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;

// StopWatchLabel
@property (weak, nonatomic) IBOutlet UILabel *stopWatchLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnStartPauseStopWatch;
@end


@implementation RunningViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    ah_PAManager = [[AH_PerformAnimationManager alloc]init ] ;
    [self defautSetting_StopWatch];
    [self defaultSetting_view];
    [self defaultSetting_Location] ;
    historyPoint =[ [HistoryPoint alloc]init ] ;

    [self defaultSetting_CountingDown];
}

- (void)defaultSetting_CountingDown {

    mzCountingDownLabel = [[MZTimerLabel alloc] initWithLabel:_countDownLabel andTimerType:MZTimerLabelTypeTimer];
    [mzCountingDownLabel setCountDownTime:3];
    mzCountingDownLabel.resetTimerAfterFinish = YES;
    mzCountingDownLabel.delegate = self;
    mzCountingDownLabel.timeFormat = @"ss" ;

    [self startCountDownWithDelegate:nil] ;
}

- (IBAction)startCountDownWithDelegate:(id)sender {

    if(![mzCountingDownLabel counting]){
        [mzCountingDownLabel start];
    }
}

- (void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
//
//
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Gaming" message:@"GO" preferredStyle:UIAlertControllerStyleAlert] ;
//    UIAlertAction *go = [UIAlertAction actionWithTitle:@"ok" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }] ;
//
//    [alert addAction: go] ;
//    [self presentViewController:alert animated:true completion:nil] ;
//
//

    _countDownLabel.hidden = true ;
    [self startOrResumeStopwatch:nil] ;
}





- (void)defautSetting_StopWatch{
    mzStopWatchLabel = [[MZTimerLabel alloc] initWithLabel:_stopWatchLabel andTimerType:MZTimerLabelTypeStopWatch];
    mzStopWatchLabel.timeFormat = @"HH:mm:ss SS";
}

- (void)defaultSetting_view{
    [_mainScrollView setScrollEnabled:false ];

    ah_mapView = [AH_MapView createWithMKView:_mapView withVC:self] ;

    _mainScrollView = [_mainScrollView createImageViewWithGameMap:[self selectedMap]] ;
    mainStateView = _mainScrollView.mainImageView ;
    secondStateView = _mainScrollView.secondImageView  ;

    _mapView.hidden = true ;
}

- (void)defaultSetting_Location {

    targetIndex = 0 ;

    ah_locationPoint = [AH_LocationManager create];
    [ah_locationPoint clear] ;
    // Create the First TargetPoint
    lmManager = [LevelMapsManager sharedInstance] ;

    //if(lmManager.levelMapPoints[MAP_INDEX] == nil )
     //   [lmManager testDefaultSetting] ;


    CLLocation *theTarget = [lmManager.levelMapPoints[MAP_INDEX] targetLocate][targetIndex] ;
  //  [historyPoint.getTargetLocate addObject:theTarget] ;

    //NSLog(@"zczxcas :%f",theTarget.coordinate.latitude) ;



    [self createTargetPointWithLat:theTarget.coordinate.latitude withLon:theTarget.coordinate.longitude] ;
    // Create the image for the compass

    NSString *targetLabelTitle = [NSString stringWithFormat:@"%d / %d",targetIndex,(int)[[lmManager.levelMapPoints[MAP_INDEX] targetLocate] count]] ;
    _targetPointLabel.text = targetLabelTitle ;

    [self passDataToWidgetWithTarget:theTarget] ;


    // Add the image to be used as the compass on the GUI
    [ah_locationPoint setArrowImageView:mainStateView];
    [ah_locationPoint setDistanceLabel:labelHeading] ;
    // Set the coordinates of the location to be used for calculating the angle
    ah_locationPoint.latitudeOfTargetedPoint = theTarget.coordinate.latitude;
    ah_locationPoint.longitudeOfTargetedPoint = theTarget.coordinate.longitude ;
    [ah_locationPoint start] ;



}

- (void)loadTargetData {

}

- (void) createTargetPointWithLat:(CLLocationDegrees)targetLat withLon:(CLLocationDegrees)targetLon {



    CLLocation *tempLocation = [[CLLocation alloc] init];

    CGPoint mapLocateA = CGPointMake(150.0, 120.0) ;
    CGPoint mapLocateB = CGPointMake(100.0, 150.0);

    CLLocation *realLocateA =[ [CLLocation alloc ]initWithLatitude:24.968539 longitude:121.192830] ;
    CLLocation *realLocateB =[[CLLocation alloc]initWithLatitude:24.969689 longitude: 121.191453] ;

     CLLocation *targetLocate =[[CLLocation alloc]initWithLatitude:targetLat longitude: targetLon] ;

    CGPoint targetPoint = [tempLocation getPointWithRealLocateA:realLocateA
                                                 witRealLocateB:realLocateB
                                               withTargetLocate:targetLocate
                                                withImagePointA:mapLocateA
                                                withImagePointB:mapLocateB ] ;

    UIImage *locateImg = [UIImage imageNamed:@"compass.png"] ;


    // add targetView in the map
    UIImageView *targetView = [[UIImageView alloc]initWithFrame: CGRectMake(targetPoint.x,targetPoint.y, 50, 50)] ;
    targetView.image = locateImg ;
    targetView.tag = MapLocateSIGN_TARGET ;
    targetView.hidden = true ;
    for(int i = 0 ; i < mainStateView.subviews.count ; i++ ) {
        if (mainStateView.subviews[i].tag == MapLocateSIGN_TARGET) {
            mainStateView.subviews[i].frame = targetView.frame ;
            return ;
        }
    }

    [mainStateView addSubview:targetView];


}

-(NSString*)selectedMap{

    if( (int)[AH_PhotoDataManager shareInstance].index  == 0 ) {
      _mapTitleLabel.text = @"NCU" ;
      return GAMEMAP_01 ;
    }
    else if( (int)[AH_PhotoDataManager shareInstance].index  == 1 ) {
      _mapTitleLabel.text = @"CYCU" ;
      return GAMEMAP_02 ;
    }

    return GAMEMAP_01 ; // if not Return DefaultMap
}

/**
 Change MainImageView and SecondImageVige With compass and map
 */
- (IBAction)secondImageSwipeDown:(UISwipeGestureRecognizer *)sender {
    [ah_locationPoint rotateArrowView:mainStateView degrees:0] ;
    [ah_locationPoint rotateArrowView:secondStateView degrees:0] ;

    [ah_PAManager performAnimationWithType:kCATransitionPush WithSubType:kCATransitionFade withView:mainStateView] ;
    [ah_PAManager performAnimationWithType:kCATransitionPush WithSubType:kCATransitionFromBottom withView:secondStateView] ;

    if(mainStateView.tag == ImageState_COMPASS_MAIN) {
        [ah_locationPoint setArrowImageView:secondStateView];
        for( int i = 0 ; i < mainStateView.subviews.count ; i++ )
            mainStateView.subviews[i].hidden = false ;

    }

    else if(secondStateView.tag == ImageState_COMPASS_SECOND) {
        [ah_locationPoint setArrowImageView:mainStateView];
        for( int i = 0 ; i < mainStateView.subviews.count ; i++ )
            mainStateView.subviews[i].hidden = true ;
    }


    [_mainScrollView exchageImage];
    _mainScrollView.bounces = false ;

}



#pragma mark - StopWatch Methods
- (IBAction)startOrResumeStopwatch:(id)sender {

    if([mzStopWatchLabel counting]){
        [mzStopWatchLabel pause];
        [_btnStartPauseStopWatch setTitle:@"Resume" forState:UIControlStateNormal];
    }else{
        [mzStopWatchLabel start];
        [_btnStartPauseStopWatch setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (IBAction)resetStopWatch:(id)sender {
    [mzStopWatchLabel reset];

    if(![mzStopWatchLabel counting]){
        [_btnStartPauseStopWatch setTitle:@"Start" forState:UIControlStateNormal];
    }
}



#pragma mark - Navigation Bar Method

- (IBAction)getTheTargetBtnPressed:(UIBarButtonItem *)sender {

    if ( ah_locationPoint == nil || ah_locationPoint.pathsLocations == nil )
        return ;

    [historyPoint.locationPaths addObject:ah_locationPoint.pathsLocations ] ;
    [historyPoint.locationPathTimeStamp addObject:_stopWatchLabel.text] ;


  //  CLLocation *theTarget = [lmManager.levelMapPoints[0] targetLocate][targetIndex] ;
    [historyPoint.getTargetLocate addObject:ah_locationPoint.getUserLocation] ;

    targetIndex++ ;


    NSString *targetLabelTitle = [NSString stringWithFormat:@"%d / %d",targetIndex,(int)[[lmManager.levelMapPoints[MAP_INDEX] targetLocate] count]] ;
    _targetPointLabel.text = targetLabelTitle ;

    if (targetIndex < [lmManager.levelMapPoints[MAP_INDEX] targetLocate].count) {
        
        CLLocation *theTarget = [lmManager.levelMapPoints[MAP_INDEX] targetLocate][targetIndex] ;
        [self passDataToWidgetWithTarget:theTarget];

        [self createTargetPointWithLat:theTarget.coordinate.latitude withLon:theTarget.coordinate.longitude] ;
        ah_locationPoint.latitudeOfTargetedPoint = theTarget.coordinate.latitude;
        ah_locationPoint.longitudeOfTargetedPoint = theTarget.coordinate.longitude ;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"GET" message:@"YOU GET THE TARGET" preferredStyle:UIAlertControllerStyleAlert] ;
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil] ;
        [alert addAction:ok] ;
        [self presentViewController:alert animated:true completion:nil] ;
    } else {

        [self startOrResumeStopwatch:nil] ;

        historyPoint.totalTime = _stopWatchLabel.text ;
        historyPoint.mapTitle = _mapTitleLabel.text ;
        for(int i = 0 ; i < ah_locationPoint.allLocations.count ; i++ )
            [historyPoint.allLocations addObject:ah_locationPoint.allLocations[i] ];

        [[HistoryDataManager sharedInstance].historyPoints addObject:historyPoint] ;
        [[HistoryDataManager sharedInstance] setMessage:[NSString stringWithFormat:@"%lu",(unsigned long)[HistoryDataManager sharedInstance].historyPoints.count ]] ;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"GET" message:@"FINISH" preferredStyle:UIAlertControllerStyleAlert] ;
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self giveUpBtnPressed:nil] ;
            [[SeverConnectManager sharedInstance] uploadHistoryData];
            
        }] ;


        [alert addAction:ok] ;
        [self presentViewController:alert animated:true completion:nil] ;

    }
}



- (IBAction)giveUpBtnPressed:(UIBarButtonItem *)sender {


    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:GROUP_SUITE_NAME];

    [sharedDefaults setInteger:GAME_STATE_NOT_IN_GAME  forKey:GROUP_GAME_STATE_INTEGER];

    [sharedDefaults synchronize];

    [self dismissViewControllerAnimated:true completion:nil] ;

}


- (void)passDataToWidgetWithTarget:(CLLocation*)targetLocate {

    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:GROUP_SUITE_NAME];


    [sharedDefaults setInteger:targetIndex  forKey:GROUP_TARGETINDEX_INTEGER];
    [sharedDefaults setInteger:GAME_STATE_GAMING  forKey:GROUP_GAME_STATE_INTEGER];
    [sharedDefaults setInteger: [lmManager.levelMapPoints[MAP_INDEX] targetLocate].count forKey:GROUP_TOTALTARGET_INTEGER ] ;
    [sharedDefaults setDouble:targetLocate.coordinate.latitude forKey:GROUP_TARGET_LAT_DOUBLE];
    [sharedDefaults setDouble:targetLocate.coordinate.longitude forKey:GROUP_TARGET_LON_DOUBLE];
    [sharedDefaults synchronize];

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
