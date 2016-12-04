//
//  AH_PhotoDataManager.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/9/25.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AH_PhotoDataManager : NSObject


@property(nonatomic,strong) NSDictionary *info ;
@property(nonatomic,strong) UIImage *selectImage ;
@property NSInteger index ;
@property(nonatomic,strong) NSString *selectMapTitle ;


+(instancetype) shareInstance ;


-(NSInteger) getTotalCount ;
-(NSString*) getFilenameByIndex:(NSInteger)index ;
-(UIImage*) getImageIndex:(NSInteger)index ;
-(NSMutableArray*) getImageNamesData ;
@end
