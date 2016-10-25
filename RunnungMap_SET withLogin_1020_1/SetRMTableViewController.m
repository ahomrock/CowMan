//
//  SetRMTableViewController.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/25.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "SetRMTableViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "LoginViewController.h"

@interface SetRMTableViewController ()
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbLogOutButton;
@property (weak, nonatomic) IBOutlet UIButton *otherLogout;

@end

@implementation SetRMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkAccountNumber];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - account number logout

- (void) checkAccountNumber {

       if ([GIDSignIn sharedInstance].hasAuthInKeychain) {
             //已登入時
                _fbLogOutButton.hidden = true ;
                _otherLogout.hidden = false ;
          
        } else {
             //未登入時
                _otherLogout.hidden = true ;
                _fbLogOutButton.hidden = false ;
       }
}
- (IBAction)fbLogoutBtnPressed:(FBSDKLoginButton *)sender {
    
     [self performSelector:@selector(turnView) withObject:nil afterDelay:3.0] ;
}


- (IBAction)logoutBtnPressed:(UIButton *)sender {
    // present alert check logout or not
    // call login out function
    // if YES -> back to login page
    // else  cancel

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"帳號登出"
                        message:@"請確認帳號是否登出"
                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                               //執行登出方法
                                                         [[GIDSignIn sharedInstance] signOut];
                                                         [self turnView];
                                                         
                                                     }];
    [alert addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    

}

//頁面跳轉
-(void) turnView {
    
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UITabBarController * tabVC = [storyBoard instantiateViewControllerWithIdentifier:@"login"];
    
    [self presentViewController:tabVC animated:true completion:nil];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 9;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消選擇的灰底顏色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
