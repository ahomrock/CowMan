//
//  AppDelegate.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/9/25.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "AppDelegate.h"





@interface AppDelegate ()

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //Facebook & Google 必要程式碼
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);

    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;

    [FBSDKLoginButton class];
    [FIRApp configure];

    

    return YES;
}


-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error != nil) {
        NSLog(@"Looks like we got a sign-in error: %@",error);
    } else {

        //要取得google user 登入資料只能透過這裡的方法取得登入資料

        NSString *userId = user.userID;                  // For client-side use only!
        //        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *fullName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        NSLog(@"Wow!Our users signed in!:%@",user);
        // NSLog(@"Users idToken: %@",idToken);
        NSLog(@"Users userId: %@",userId);
        NSLog(@"Users familyName: %@",familyName);
        NSLog(@"Users Fullname: %@",fullName);
        NSLog(@"Users givenName: %@",givenName);
        NSLog(@"Users email: %@",email);

        //    取得使用者的大頭照，把取得的連結存入到NSUserDefault 再到ViewController 那邊取出給Image 物件
       
        


 //       NSUInteger dimension = round(thumbSize.width * [[UIScreen mainScreen] scale]); //設定頭像大小


//        NSURL *imageURL = [user.profile imageURLWithDimension:dimension];
        //把NSURL轉成字串型別
//        NSString *imagestr = [imageURL absoluteString];
  //      NSLog(@"NSURL連結：%@ :",imageURL);

        //宣告一個日期變數
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
        // 设置日期格式
        [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];

        // 列印结果：dateString = 年月日 2013/10/16 时间 05:15:43
        NSLog(@"dateString = %@",dateString);
        //把FB登入者接到的資料存到firebasesave;Save Google User's data to firebase ===============================
        FIRDatabaseReference *ref = [[FIRDatabase database]reference ];
        NSString *key = [[ref child:@"posts"] childByAutoId].key;
        NSDictionary *post = @{@"uid": userId,
                               @"username": fullName,
                               @"email": email,
                               @"date":dateString};
        NSDictionary *userUpdates = @{[@"/posts/" stringByAppendingString:key]: post};
        [ref updateChildValues:userUpdates];
        //===========================================================
        //部分資料存到NSUserDefaults 至另一類別使用
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
 //       [defaults setObject:imagestr  forKey:@"imagestr"];
        [defaults setObject:email forKey:@"email"];
        [defaults setObject:fullName forKey:@"fullName"];
        [defaults synchronize];
        
        
        


    }


}



- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error != nil) {
        NSLog(@"Looks like we got a sign-in error: %@",error);
    }
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{


    if([[FBSDKApplicationDelegate sharedInstance] application:application
                                                      openURL:url
                                            sourceApplication:sourceApplication
                                                   annotation:annotation])
    {
        return YES;
    }

    return [[GIDSignIn sharedInstance]handleURL:url
                              sourceApplication:sourceApplication
                                     annotation:annotation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    

}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
   
}




//////////

// for Widget 

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    NSLog(@"Containing App Receive: %@",url.description);

    NSString *path = url.absoluteString;

    NSString *parameter = [path stringByReplacingOccurrencesOfString:@"widget_RunningMapGaming://" withString:@""];
    NSLog(@"dddd %@",parameter) ;

    self.jumpToParameter = parameter;

    [[NSNotificationCenter defaultCenter] postNotificationName:JUMP_TO_NOTIFICATION object:parameter];

    return true;
}

// for


-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.restrictRotation)
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskAll;
}

-(void) restrictRotation:(BOOL) restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}




@end
