//
//  GetFirebaseCoordinate.h
//  RunningMap_LevelMap
//
//  Created by 陳育賢 on 2016/10/18.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetFirebaseCoordinate : UIViewController
@property (strong, nonatomic) NSDictionary * firebaseCoordinate;
@property (strong, nonatomic) NSString * getFirebaseLatitude;
@property (strong, nonatomic) NSString * getFirebaseLongitude;
@property (strong, nonatomic) NSString * getPointCount;
-(void)getFirebaseCoordinate;
@end
