//
//  TodayViewController.m
//  RunningMap_Gaming
//
//  Created by NO KR on 2016/10/10.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "AH_LocationManager.h"
#import "NSUserDefaults+Extension.h"

#define DegreesToRadians(degrees)(degrees * M_PI / 180.0)


@interface TodayViewController () <NCWidgetProviding> {
    AH_LocationManager *ah_locationPoint; ;
    NSInteger game_state ;
    NSUserDefaults *defaults ;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation TodayViewController


- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
        }
    return self;
}

- (void)userDefaultsDidChange:(NSNotification *)notification {
  [self updateTarget];

}

- (void)updateTarget {


    game_state =  (int)[defaults integerForKey:GROUP_GAME_STATE_INTEGER] ;
    [self settingViewByGameState] ;
    int targetIndex = (int)[defaults integerForKey:GROUP_TARGETINDEX_INTEGER];
    int totalTarget = (int)[defaults integerForKey:GROUP_TOTALTARGET_INTEGER] ;

    _targetLabel.text = [NSString stringWithFormat:@"%d / %d",targetIndex,totalTarget] ;

    ah_locationPoint.latitudeOfTargetedPoint = [defaults doubleForKey:GROUP_TARGET_LAT_DOUBLE];
    ah_locationPoint.longitudeOfTargetedPoint = [defaults doubleForKey:GROUP_TARGET_LON_DOUBLE];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    game_state = GAME_STATE_NOT_IN_GAME ;

    defaults = [[NSUserDefaults alloc] initWithSuiteName: GROUP_SUITE_NAME];

    [self defaultSetting_Loacte] ;
    [self updateTarget];
    self.preferredContentSize = CGSizeMake(320.0, 320.0) ;//for ios9 before

    // for ios10
    if([self.extensionContext respondsToSelector:@selector(widgetLargestAvailableDisplayMode)])
        self.extensionContext.widgetLargestAvailableDisplayMode  = NCWidgetDisplayModeExpanded ;

}
- (void)defaultSetting_Loacte {

  //  _targetLabel.text = [lmManager targetPointLabelTextWithMap:0 withIndex:targetIndex] ;
    ah_locationPoint = [AH_LocationManager create];

    // Add the image to be used as the compass on the GUI
    [ah_locationPoint setArrowImageView:_imageView];
    [ah_locationPoint setDistanceLabel:_distanceLabel] ;

    
        // Set the coordinates of the location to be used for calculating the angle

    [ah_locationPoint start];
    // Do any additional setup after loading the view from its nib.
    [self settingViewByGameState] ;




}

- (IBAction)backToGame:(UIButton *)sender {



}

- (void)settingViewByGameState {
    if (game_state == GAME_STATE_GAMING)
        self.view.hidden = false ;
    else
        self.view.hidden = true ;

}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if(activeDisplayMode == NCWidgetDisplayModeCompact)
        self.preferredContentSize = maxSize ;
    else if (activeDisplayMode == NCWidgetDisplayModeExpanded)
        self.preferredContentSize = CGSizeMake(320 ,800) ;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
