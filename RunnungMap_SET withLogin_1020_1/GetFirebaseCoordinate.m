//
//  GetFirebaseCoordinate.m
//  RunningMap_LevelMap
//
//  Created by 陳育賢 on 2016/10/18.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "GetFirebaseCoordinate.h"
#import <Firebase.h>

@interface GetFirebaseCoordinate ()

@end

@implementation GetFirebaseCoordinate

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//取得 firebase裡面的所有資料
#pragma fetch Firebase Data

-(void)getFirebaseCoordinate {
    
  
        //連結Firebase 資料庫
        FIRDatabaseReference *ref = [[[FIRDatabase database]reference]child:@"coordinate"];
        
        [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *post = snapshot.value;
            //讀出Firbase裡的coordinate類別欄資料庫
            _getPointCount = [post objectForKey:@"Email"];
            _getFirebaseLatitude = [post objectForKey:@"latitude"];
            _getFirebaseLongitude = [post objectForKey:@"longitude"];
        
            //列印與存入和pointCount同層的資料
            for (NSString * pointCount in post) {
                
                _firebaseCoordinate = post[pointCount];
                NSLog(@"%@",_firebaseCoordinate[@"pointCount"]);
                NSLog(@"%@",_firebaseCoordinate[@"latitude"]);
                NSLog(@"%@",_firebaseCoordinate[@"longitude"]);
            
                
            }
            
        }];

    
    
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
