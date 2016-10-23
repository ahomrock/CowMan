//
//  SetFirebaseCoordinate.m
//  RunningMap_LevelMap
//
//  Created by 陳育賢 on 2016/10/18.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "SetFirebaseCoordinate.h"
#import <Firebase.h>
@interface SetFirebaseCoordinate ()
@property (nonatomic,strong) NSString * fireBtitle ;
@property (nonatomic,strong) NSString * fireBsubTitle ;
@property (nonatomic,strong) NSString * fireBmapDescription ;
@end

@implementation SetFirebaseCoordinate

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setNCUFirebaseCoordinate {
    FIRDatabaseReference *ref = [[FIRDatabase database]reference ];
    pointCount = @"1";
    latitude = @"24.96843";
    longitude = @"121.195927";
    _fireBtitle = @"NCU" ;
    _fireBsubTitle = @"Zombie in the Montain";
    _fireBmapDescription = @"long time ago, zombie .......";
    NSString *key = [[ref child:@"NCUcoordinate"] childByAutoId].key;
    
    NSDictionary *point = @{@"pointCount": pointCount,
                           @"latitude": latitude,
                           @"longitude": longitude,
                            @"title": _fireBtitle,
                            @"subTitle":_fireBsubTitle,
                            @"mapDescription":_fireBmapDescription
                           };
    
    NSDictionary *userUpdates = @{[@"/NCUcoordinate/" stringByAppendingString:key]: point};

    [ref updateChildValues:userUpdates withCompletionBlock:^(NSError *error, FIRDatabaseReference  *ref){
        if (!error) {
            NSLog(@" 更新成功");
        } else {
            NSLog(@" 更新失敗");
        }
    }];
    
}

//暫存備用，設定Firebase欄位用
- (IBAction)setNCUButton:(UIButton *)sender {
    SetFirebaseCoordinate * sfbc = [SetFirebaseCoordinate new];  ;
    
    [sfbc setNCUFirebaseCoordinate];
    
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
