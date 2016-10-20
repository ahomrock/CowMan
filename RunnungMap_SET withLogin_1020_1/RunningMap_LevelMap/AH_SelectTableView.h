//
//  AH_SelectTableView.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/9/25.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

typedef NS_ENUM(NSInteger,TableStateTYPE_) {
    TableStateTYPE_onTOP,
    TableStateTYPE_onBottom
};
@interface AH_SelectTableView : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView ;
@property (nonatomic,strong)UIImageView *imageView ;

+(instancetype)startWithTableView:(UITableView*)tableView withImageView:(UIImageView*)imageView ;

@end
