//
//  LoginViewController.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/14.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Firebase/Firebase.h>

@import Firebase;
@import FirebaseDatabase ;

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *loginInLabel;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbSDKLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *googleBtn;

@end
