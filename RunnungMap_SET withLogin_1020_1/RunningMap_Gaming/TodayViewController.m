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
#import "LevelMapsManager.h"
#define DegreesToRadians(degrees)(degrees * M_PI / 180.0)


@interface TodayViewController () <NCWidgetProviding> {
    AH_LocationManager *ah_locationPoint; ;
    LevelMapsManager *lmManager ;
    int game_state ;
    int targetIndex ;
    
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

    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName: GROUP_SUITE_NAME];
    game_state =  (int)[defaults integerForKey:GROUP_GAME_STATE_INTEGER] ;
    [self settingViewByGameState] ;
    targetIndex = (int)[defaults integerForKey:GROUP_TARGETINDEX_INTEGER];
    _targetLabel.text = [lmManager targetPointLabelTextWithMap:0 withIndex:targetIndex] ;

    CLLocation *theTarget = [lmManager.levelMapPoints[0] targetLocate][targetIndex] ;
    ah_locationPoint.latitudeOfTargetedPoint = theTarget.coordinate.latitude;
    ah_locationPoint.longitudeOfTargetedPoint = theTarget.coordinate.longitude ;

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    targetIndex = 0 ;
    lmManager = [LevelMapsManager sharedInstance] ;
    [self defaultSetting_Loacte] ;
    [self updateTarget];
    
    self.preferredContentSize = CGSizeMake(320.0, 320.0) ;//for ios9 before

    // for ios10
    if([self.extensionContext respondsToSelector:@selector(widgetLargestAvailableDisplayMode)])
        self.extensionContext.widgetLargestAvailableDisplayMode  = NCWidgetDisplayModeExpanded ;

}
- (void)defaultSetting_Loacte {

    _targetLabel.text = [lmManager targetPointLabelTextWithMap:0 withIndex:targetIndex] ;
    ah_locationPoint = [AH_LocationManager create];

    // Add the image to be used as the compass on the GUI
    [ah_locationPoint setArrowImageView:_imageView];
    [ah_locationPoint setDistanceLabel:_distanceLabel] ;
        // Set the coordinates of the location to be used for calculating the angle

    [ah_locationPoint start];
    // Do any additional setup after loading the view from its nib.

    self.view.hidden = true ;


}

- (IBAction)backToGame:(UIButton *)sender {
    NSLog(@"HERE") ;
    NSURL *url = [NSURL URLWithString:@"widget_RunningMapGaming://resumeGame"];

    [self.extensionContext openURL:url
                 completionHandler:^(BOOL success) {
                     NSLog(@"openURL Done.");
                 }];


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
