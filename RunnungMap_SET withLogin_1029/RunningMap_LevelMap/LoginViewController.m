//
//  LoginViewController.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/14.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "NSUserDefaults+Extension.h"
#import "SetFirebaseCoordinate.h"

@interface LoginViewController () <UIApplicationDelegate,GIDSignInDelegate,FBSDKLoginButtonDelegate>
@property (strong, nonatomic) IBOutlet UILabel *loginSuccessTurnPageLabel;

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

    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    
    [self reloadInputViews];
    [self getFirebaseData]; //取得Firebase 裡面的資料
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)googleSignIn:(UIButton *)sender {
    [[GIDSignIn sharedInstance] signIn];
    _loginSuccessTurnPageLabel.hidden = true ;

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

//頁面跳轉
-(void) turnView {

    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController * tabVC = [storyBoard instantiateViewControllerWithIdentifier:@"tab_bar_controller_begin"];
    
    [self presentViewController:tabVC animated:true completion:nil];
    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([FBSDKAccessToken currentAccessToken].tokenString ||  [GIDSignIn sharedInstance].hasAuthInKeychain) {
        
        _loginSuccessTurnPageLabel.hidden = false ;
        [self turnView];
        
    }
    
}



//登出按鈕，storyboard Button未做,功能暫留著
- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
    
    NSLog(@"Google user Log out!");
}

#pragma FaceBook fetch users information
//FB User登入時顯示的結果
-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
     _loginSuccessTurnPageLabel.hidden = false ;
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if (error != nil) {
        NSLog(@"Login error !:%@",error);
         _loginSuccessTurnPageLabel.hidden = true ;
    } else if (result.isCancelled  ){
        _loginSuccessTurnPageLabel.hidden = true ;
        NSLog(@"User Canceled");
    } else {
        if ([result.grantedPermissions containsObject:@"email" ] == false) {
            NSLog(@"User don't provide email");
            _loginSuccessTurnPageLabel.hidden = true ;
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
   
                 NSString *key = [[ref child:@"posts"] childByAutoId].key;
                 NSDictionary *post = @{@"uid": userID,
                                        @"username": username,
                                        @"email": userEmail,
                                        @"date":dateString};
                 
                 NSDictionary *userUpdates = @{[@"/posts/" stringByAppendingString:key]: post};
                 [ref updateChildValues:userUpdates];
                 
                 FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                                  credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                                  .tokenString];
                 
                 [[FIRAuth auth] signInWithCredential:credential
                                           completion:^(FIRUser *user, NSError *error) {
                                               // ...
                                           }];
                 
            
                 [defaults setObject:username forKey:@"fullName"];
                 [defaults setObject:userEmail forKey:@"email"];
                 [defaults setObject:userID forKey:FACEBOOK_LOGIN_IN_UID];
                 [defaults synchronize];
             }
             else{
                 _loginSuccessTurnPageLabel.hidden = true ;
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
        
    }
    
}

//取得 firebase裡面的使用者的所有資料
#pragma fetch Firebase Data
-(void)getFirebaseData {
    
    
    //連結Firebase 資料庫
    FIRDatabaseReference *ref = [[[FIRDatabase database]reference]child:@"posts"];
    
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *post = snapshot.value;

        
        //列印和uid同層的資料
        for (NSString * uid in post) {
            
            NSDictionary * each = post[uid];
            NSLog(@"%@",uid);
            NSLog(@"%@",each[@"date"]);
            NSString * aa = each[@"date"];
            NSLog(@"%@",each[@"email"]);
            NSLog(@"%@",each[@"username"]);
            
        }
        
    }];
}

-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {

    if ( [GIDSignIn sharedInstance].hasAuthInKeychain) {
        _loginSuccessTurnPageLabel.hidden = false ;
        [self turnView];
       
        
    } else {
        _loginSuccessTurnPageLabel.hidden = true ;
    }
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
