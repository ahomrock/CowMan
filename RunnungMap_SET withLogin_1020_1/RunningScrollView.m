//
//  RunningScrollView.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/11.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "RunningScrollView.h"


@interface RunningScrollView() {
    CGSize compassImageSize ;
    CGSize mapImageSize ;
}
@end


@implementation RunningScrollView

- (instancetype)createImageViewWithGameMap:(NSString*)gameMap {
    UIImage *compassImage = [UIImage imageNamed:COMPASS_IMG] ;
    compassImageSize = compassImage.size ;
    UIImage* mapImage = [UIImage imageNamed:gameMap] ;
    mapImageSize = mapImage.size ;

    _mainImageView = [[UIImageView alloc]initWithImage:compassImage ];
      _mainImageView.tag = ImageState_COMPASS_MAIN ;

   float ratio = compassImageSize.height / compassImageSize.width ;
   float frameWidth = self.frame.size.width*0.4 ;
   float frameHeight = frameWidth * ratio ;

    _mainImageView.frame =  CGRectMake(0, self.frame.origin.y + self.frame.size.height*0.17, frameWidth, frameHeight) ;
    [self addSubview:_mainImageView];

    _secondImageView = [[UIImageView alloc]initWithImage:mapImage ];
      _secondImageView.tag = ImageState_MAP_SECOND ;

    float secondRatio = mapImageSize.height / mapImageSize.width ;
    float secondFrameWidth = self.frame.size.width*0.17;
    float secondFrameHeight = secondFrameWidth * secondRatio ;

    _secondImageView.frame =CGRectMake(0, 0, secondFrameWidth, secondFrameHeight) ;

    [self addSubview:_secondImageView];

    return self ;
}


/**
 Exchage mainImageView and secondImageView
 */
-(void)exchageImage {
    UIImage *tempImage = _mainImageView.image ;
    _mainImageView.image = _secondImageView.image ;
    _secondImageView.image = tempImage ;
    tempImage = nil ;


    if(_mainImageView.tag == ImageState_COMPASS_MAIN ) {

        _mainImageView.tag = ImageState_MAP_MAIN ;
        _mainImageView.frame = [self getFrameWithImageState:ImageState_MAP_MAIN] ;
        _secondImageView.tag = ImageState_COMPASS_SECOND ;
        _secondImageView.frame = [self getFrameWithImageState:ImageState_COMPASS_SECOND] ;
        NSLog(@"A");
    }
    else if (_mainImageView.tag == ImageState_MAP_MAIN ){

        _mainImageView.tag = ImageState_COMPASS_MAIN  ;
        _mainImageView.frame = [self getFrameWithImageState:ImageState_COMPASS_MAIN] ;
        _secondImageView.tag = ImageState_MAP_SECOND ;
        _secondImageView.frame = [self getFrameWithImageState:ImageState_MAP_SECOND] ;
        NSLog(@"B");
    }

}



/**
 @param imageState : compass and map in which State

 @return : the Frame for ImageView
 */
-(CGRect) getFrameWithImageState:(ImageState)imageState {

    CGRect zero = CGRectZero ;

    float ratio,frameWidth,frameHeight ;

    if ( imageState == ImageState_MAP_MAIN) {
        ratio = mapImageSize.height / mapImageSize.width ;
        frameWidth = self.frame.size.width*1 ;
        frameHeight = frameWidth * ratio ;
        return CGRectMake(0, self.frame.origin.y + self.frame.size.height*0.3, frameWidth, frameHeight) ;
    }
    else if (imageState == ImageState_MAP_SECOND) {
        ratio = mapImageSize.height / mapImageSize.width ;
        frameWidth = self.frame.size.width*0.45 ;
        frameHeight = frameWidth * ratio ;
        return  CGRectMake(0, 0, frameWidth, frameHeight) ;
    }
    else if (imageState == ImageState_COMPASS_MAIN) {
        ratio = compassImageSize.height / compassImageSize.width ;
        frameWidth = self.frame.size.width*1 ;
        frameHeight = frameWidth * ratio ;
        return CGRectMake(0, self.frame.origin.y + self.frame.size.height*0.3, frameWidth, frameHeight) ;
    }
    else if (imageState == ImageState_COMPASS_SECOND) {
        ratio = compassImageSize.height / compassImageSize.width ;
        frameWidth = self.frame.size.width*0.5 ;
        frameHeight = frameWidth * ratio ;
        return CGRectMake(0, 0, frameWidth, frameHeight) ;
    }

    return zero ;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
