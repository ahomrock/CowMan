//
//  MainViewController.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/18.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "MainViewController.h"
#import "NSUserDefaults+Extension.h"
#import "RunningMap_LevelMap-Swift.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface MainViewController ()

@end

@implementation MainViewController


//
//let loadingSquare = AASquaresLoading(target: self.view, size: 40)
//// Customize background
//loadingSquare.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
//// Customize color
//loadingSquare.color = UIColor.whiteColor()
//// Start loading
//loadingSquare.start()
//....
//// Stop loading
//loadingSquare.stop()


- (void)defaultSetting_loadingView {
    AASquaresLoading * loadingSquare = [[AASquaresLoading alloc]initWithTarget:self.view size:50 ] ;
    loadingSquare.backgroundColor = [UIColor blackColor];
    loadingSquare.color = [UIColor whiteColor] ;
    [ loadingSquare start:0] ;
    [loadingSquare stop:10.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];


    [self defaultSetting_loadingView];
    // Do any additional setup after loading the view.
    [self defaultSetting_GROUP] ;
   



}
//設定判斷是登入跳轉
-(void) checkLoginIn {
    if ([FBSDKAccessToken currentAccessToken].tokenString ||  [GIDSignIn sharedInstance].hasAuthInKeychain) {
        [self turnMainView];
        
    } else {
        [self turnLoginView];
    }
}
-(void)viewDidAppear:(BOOL)animated {
    
        [self checkLoginIn];
    
}

//頁面跳轉到主畫面
-(void) turnMainView {
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"SelectMap" bundle:nil];
    UITabBarController * tabVC = [storyBoard instantiateViewControllerWithIdentifier:@"UINavigationController-SelectMapBegin"];
    
    [self presentViewController:tabVC animated:true completion:nil];
    
}
//頁面跳轉到登入畫面
- (void) turnLoginView {
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UITabBarController * tabVC = [storyBoard instantiateViewControllerWithIdentifier:@"login"];
    
    [self presentViewController:tabVC animated:true completion:nil];
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
