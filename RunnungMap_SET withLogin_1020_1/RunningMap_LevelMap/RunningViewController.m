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
//
//typedef NS_ENUM(NSInteger, MainState) {
//    MainState_MapImage,
//    MainState_Compass,
//    SecondState
//};

@interface RunningViewController (){
    IBOutlet UILabel *labelHeading;

    AH_LocationManager *ah_locationPoint;
    AH_MapView *ah_mapView ;
    UIImageView *secondStateView;
    UIImageView *mainStateView;

    AH_PerformAnimationManager *ah_PAManager ;

    HistoryPoint *historyPoint ;
    NSString *mapTitle ;
}




@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *mapTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *targetPointLabel;

@property (weak, nonatomic) IBOutlet RunningScrollView *mainScrollView;


// StopWatchLabel
@property (weak, nonatomic) IBOutlet UILabel *stopWatchLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnStartPauseStopWatch;
@end


@implementation RunningViewController


- (void) countDown {
    CGRect countDownViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
    UIView *cd_view = [[UIView alloc]initWithFrame:countDownViewFrame ] ;
    cd_view.backgroundColor = [UIColor blackColor] ;
  //  [self.view addSubview:cd_view] ;
    //[cd_view performSelector:@selector(handleTimer:) withObject:self afterDelay:3.0] ;

//    CountDownViewController *cdVC = [[UIViewController alloc] initWithNibName:@"CountDownViewController" bundle:nil ];
//    [self presentViewController:cdVC animated:true completion:nil] ;
//[

}

- (void)handleTimer:(UIImageView *)sender {
    //[view stopAnimating] ;
    //[sender removeFromSuperview]  ;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    ah_PAManager = [[AH_PerformAnimationManager alloc]init ] ;

   // [self countDown] ;

    // Timer Label
    mzStopWatchLabel = [[MZTimerLabel alloc] initWithLabel:_stopWatchLabel andTimerType:MZTimerLabelTypeStopWatch];
    mzStopWatchLabel.timeFormat = @"HH:mm:ss SS";


    [self startOrResumeStopwatch:nil] ;



    ah_mapView = [AH_MapView createWithMKView:_mapView withVC:self] ;

    _mainScrollView = [_mainScrollView createImageViewWithGameMap:[self selectedMap]] ;
    mainStateView = _mainScrollView.mainImageView ;
    secondStateView = _mainScrollView.secondImageView  ;

    _mapView.hidden = true ;

    UIImage *imagePoint = [UIImage imageNamed:@"compass.png"] ;

    UIImageView *imagePointView = [[UIImageView alloc]initWithFrame: CGRectMake(100, 150, 50, 50)] ;
    imagePointView.image = imagePoint ;
    imagePointView.hidden = true ;
    [mainStateView addSubview:imagePointView] ;

//     Create the image for the compass


    ah_locationPoint = [AH_LocationManager create];
    [ah_locationPoint clear] ;
    // Add the image to be used as the compass on the GUI
    [ah_locationPoint setArrowImageView:mainStateView];
    [ah_locationPoint setDistanceLabel:labelHeading] ;
    // Set the coordinates of the location to be used for calculating the angle
    ah_locationPoint.latitudeOfTargetedPoint = 24.967937;
    ah_locationPoint.longitudeOfTargetedPoint = 121.191774 ;
    [ah_locationPoint start] ;

//    (CLLocationCoordinate2D coordinate)

    CLLocationCoordinate2D coordinate =CLLocationCoordinate2DMake(ah_locationPoint.latitudeOfTargetedPoint, ah_locationPoint.longitudeOfTargetedPoint) ;


    MKPointAnnotation *point  = [[MKPointAnnotation alloc]init] ;
    point.coordinate = coordinate ;
    [_mapView addAnnotation:point] ;



    historyPoint =[ [HistoryPoint alloc]init ] ;

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

 @param sender <#sender description#>
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
    if(ah_locationPoint.allLocations.count > 0 ) {
          [historyPoint.locationPaths addObject:ah_locationPoint.allLocations ] ;
        [historyPoint.locationPathTimeStamp addObject:_stopWatchLabel.text] ;
    }

  //  NSLog(@"mmkk : %@", historyPoint.locationPathTimeStamp.lastObject);
//
//    for (int i = 0 ; i <historyPoint.locationPaths.count; i++)
//        NSLog(@"cccc ccvv:%f",[historyPoint.locationPaths[i] coordinate].latitude );



    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"GET" message:@"YOU GET THE TARGET" preferredStyle:UIAlertControllerStyleAlert] ;
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil] ;
    [alert addAction:ok] ;
    [self presentViewController:alert animated:true completion:nil] ;
}

- (IBAction)giveUpBtnPressed:(UIBarButtonItem *)sender {

    historyPoint.totalTime = _stopWatchLabel.text ;
    historyPoint.mapTitle = mapTitle ;


    [[HistoryDataManager sharedInstance].historyPoints addObject:historyPoint] ;
    [[HistoryDataManager sharedInstance] setMessage:[NSString stringWithFormat:@"%lu",(unsigned long)[HistoryDataManager sharedInstance].historyPoints.count ]] ;
    
//    [[HistoryDataManager sharedInstance]coreDataManagerInit ] ;
//    [[HistoryDataManager sharedInstance]SaveToCoreData ] ;
//    HistoryViewController *vc =  self.tabBarController.childViewControllers[1] ;
//    [ vc.tableView reloadData ] ;
    NSMutableArray *nn = [HistoryDataManager sharedInstance].historyPoints ;
    NSLog(@"xx xqww:%@",[nn.lastObject totalTime ]) ;
    NSLog(@"COUNT : %lu",(unsigned long)nn.count) ;
    [self dismissViewControllerAnimated:true completion:nil] ;

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
