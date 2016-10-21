//
//  RunningScrollView.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/11.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COMPASS_IMG @"compass.png"
#define GAMEMAP_01 @"gameMap_01.jpg"
#define GAMEMAP_02 @"gameMap_02.jpg"


typedef NS_ENUM(NSInteger,ImageState) {
    ImageState_MAP_MAIN,
    ImageState_MAP_SECOND,
    ImageState_COMPASS_MAIN,
    ImageState_COMPASS_SECOND
} ;

@interface RunningScrollView : UIScrollView

@property (nonatomic,strong) UIImageView *mainImageView ;
@property (nonatomic,strong) UIImageView *secondImageView ;
@property (nonatomic,strong) UIView *infView ;

- (instancetype)createImageViewWithGameMap:(NSString*)gameMap ;


- (void)exchageImage ;
- (CGRect) getFrameWithImageState:(ImageState)imageState ;


- (CGPoint)getMapInMainCenterPoint;
@end
