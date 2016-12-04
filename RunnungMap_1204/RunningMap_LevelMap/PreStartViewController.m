//
//  PreStartViewController.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/9.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "PreStartViewController.h"
#import "AH_PerformAnimationManager.h"
#import "RunningViewController.h"
#import "AH_PhotoDataManager.h"

#import "AppDelegate.h"

@interface PreStartViewController () {
    AH_PerformAnimationManager *ah_PAManager ;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundMap;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end

@implementation PreStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ah_PAManager = [ AH_PerformAnimationManager new ] ;

    _backgroundMap.image = [AH_PhotoDataManager shareInstance].selectImage ;
    _navItem.title = [AH_PhotoDataManager shareInstance].selectMapTitle ;

    // for Widget
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleJumpToNotification:) name:JUMP_TO_NOTIFICATION object:nil];
}



- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.jumpToParameter != nil)
    {
        [self doJumpTo:appDelegate.jumpToParameter];
    }
    
}

- (void) handleJumpToNotification:(NSNotification*) notify {
    [self doJumpTo:notify.object];
}

- (void) doJumpTo:(NSString*) parameter {
    
    NSString *segueID = [NSString stringWithFormat:@"%@",parameter];
    [self performSegueWithIdentifier:segueID sender:nil];
    NSLog(@"ccc xxx ") ;
    // Clear appDelegate.jumpToParameter
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.jumpToParameter = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

/**
 set the device in Landscape state

 @param sender <#sender description#>
 */
- (IBAction)PresentGameVieweBtnPressed:(UIButton *)sender {


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
