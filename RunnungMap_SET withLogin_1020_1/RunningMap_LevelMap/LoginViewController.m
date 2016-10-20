//
//  LoginViewController.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/14.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"



@interface LoginViewController () <UIApplicationDelegate,GIDSignInDelegate,FBSDKLoginButtonDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signInSilently];
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    
    if ([FBSDKAccessToken currentAccessToken] !=nil ) {
        NSLog(@"User already logined");
    } else {
        _fbSDKLoginButton.readPermissions = @[@"email",@"public_profile",@"user_friends"];
        
    }
//    _fbSDKLoginButton = self;
    //增加FB客制按鈕
    //    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    //    loginButton.center = self.view.center;
    //    [self.view addSubview:loginButton];
    
    [self getFirebaseData]; //取得Firebase 裡面的資料
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///=======================================


- (IBAction)googleSignIn:(UIButton *)sender {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if (![GIDSignIn sharedInstance].hasAuthInKeychain) {
        
        //         未登入時
        
        [[GIDSignIn sharedInstance] signIn];
        
        self.loginInLabel.text = [defaults objectForKey:@"fullName"];
        [_googleBtn setTitle:@"Google登出"forState:UIControlStateNormal];
        
//        ViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ncu"];
//        [self showViewController:vc sender:nil];
//        
    } else {
        
        //         已登入時
        
        [[GIDSignIn sharedInstance] signOut];
        
        NSLog(@"Google user Log out!");
        
        
        self.loginInLabel.text = @"您好，請選擇帳號請登入";
        [_googleBtn setTitle:@"Google登入"forState:UIControlStateNormal];
        
        NSString * imageStr = [defaults objectForKey:@"imagestr"];
        
        
//        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
        
        //        self.fbUserFilePhoto.image = image;
        
    }
    
    
}


//FB user 登出提示
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"User logut");
    self.loginInLabel.text = @"您好，請選擇帳號請登入";
}

//登入時回傳
-(BOOL)loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
    return true;
}



//登出按鈕，storyboard Button未做,功能暫留著
- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
    
    NSLog(@"Google user Log out!");
}

#pragma FaceBook fetch users information
//FB User登入時顯示的結果
-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if (error != nil) {
        NSLog(@"Login error !:%@",error);
    } else if (result.isCancelled  ){
        NSLog(@"User Canceled");
    } else {
        if ([result.grantedPermissions containsObject:@"email" ] == false) {
            NSLog(@"User don't provide email");
            return;
        }
        //取得fb使用者資料,並且放入到Firebase裡面
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                           parameters:@{@"fields": @"name,picture, email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 
                 NSLog(@"email is %@", [result objectForKey:@"email"]);
                 NSString * userEmail = [result objectForKey:@"email"];
                 NSLog(@"name is %@", [result objectForKey:@"name"]);
                 NSString * username = [result objectForKey:@"name"];
                 NSLog(@"id is %@", [result objectForKey:@"id"]);
                 NSString * userID = [result objectForKey:@"id"];
                 _loginInLabel.text = username;
                 //取得FB使用者大頭照
                 //                 FBSDKProfilePictureView *profilePictureview = [[FBSDKProfilePictureView alloc]initWithFrame:_fbUserFilePhoto.frame];
                 //                 [profilePictureview setProfileID:result[@"id"]];
                 //                 [self.view addSubview:profilePictureview];
                 
                 NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
                 
                 // 设置日期格式
                 [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];
                 
                 NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
                 
                 // 打印结果：dateString = 年月日 2013/10/16 时间 05:15:43
                 NSLog(@"dateString = %@",dateString);
                 
                 //把FB登入者接到的資料存到save data,firebase ===============================
                 FIRDatabaseReference *ref = [[FIRDatabase database]reference ];
                 //                 NSString *key = [[ref child:@"posts"] childByAutoId].key;
                 NSString *key = [[ref child:@"posts"] childByAutoId].key;
                 NSDictionary *post = @{@"uid": userID,
                                        @"username": username,
                                        @"email": userEmail,
                                        @"date":dateString};
                 
                 NSDictionary *userUpdates = @{[@"/posts/" stringByAppendingString:key]: post};
                 [ref updateChildValues:userUpdates];
                 //   [NSString stringWithFormat:@"/user-posts/%@/%@/", userID, key]: post
                 //======================================================================
                 [defaults setObject:username forKey:@"fullName"];
                 [defaults synchronize];
             }
             else{
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
        
    }
    
}

//取得 firebase裡面的所有資料
#pragma fetch Firebase Data
-(void)getFirebaseData {
    
    
    //連結Firebase 資料庫
    FIRDatabaseReference *ref = [[[FIRDatabase database]reference]child:@"posts"];
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *post = snapshot.value;
//        if (post != nil) {
//            NSLog(@"%lu",post.count);
//        }
        
        //列印和uid同層的資料
        for (NSString * uid in post) {
            
            NSDictionary * each = post[uid];
            NSLog(@"%@",uid);
            NSLog(@"%@",each[@"date"]);
            NSLog(@"%@",each[@"email"]);
            NSLog(@"%@",each[@"username"]);
            
        }
        
    }];
}
//從NSuserDefault 裡面取得在AppDelegate 裡面儲存google user 登入的資料，並做判斷使用者是否登入，隱藏部分按鈕功能
//但是無法即時更新畫面，如果做登入或登出時，需再重新重開APP才能更新畫面
-(void) googleProfileNsuserDefault {
    
    //    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //
    
    //    if (![GIDSignIn sharedInstance].hasAuthInKeychain) {
    //
    ////         未登入時
    //
    //        self.welcome.text = @"您好，請登入";
    //
    //        self.signInButton.hidden = NO;
    //
    ////        self.signOutButton.hidden = YES;
    //
    //
    //
    //    } else {
    //
    ////         已登入時
    //
    //        self.signInButton.hidden = YES;
    //
    ////        self.signOutButton.hidden = NO;
    //
    //        self.welcome.text = [defaults objectForKey:@"fullName"];
    //
    //        NSString * imageStr = [defaults objectForKey:@"imagestr"];
    //
    //
    //        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
    //
    ////        self.fbUserFilePhoto.image = image;
    //        
    //    }
    // [self reloadInputViews];  // 嘗試重讀畫面，但未果
    
}
-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
   
    
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}

//========================================

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
