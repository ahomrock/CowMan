//
//  MainViewController.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/18.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "MainViewController.h"
#import "NSUserDefaults+Extension.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self defaultSetting_GROUP] ;
}

- (void)defaultSetting_GROUP {

    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:GROUP_SUITE_NAME];

    [sharedDefaults setInteger:GAME_STATE_NOT_IN_GAME  forKey:GROUP_GAME_STATE_INTEGER];

    [sharedDefaults synchronize];

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
