//
//  AH_SelectPhotoScrollView.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/9/25.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "AH_SelectPhotoScrollView.h"
#import "AH_PhotoDataManager.h"

@interface AH_SelectPhotoScrollView()<UIScrollViewDelegate> 

@end

@implementation AH_SelectPhotoScrollView


- (void)configureView {
    // Update the user interface for the detail item.
    if(_photoImageView == nil || _targetIndex == -1 )
        return ;
//
//    UIImage *image = _photoImageDatas[_targetIndex] ;
//    _photoImageView.image = image;
//    _mainScrollView.contentSize = image.size ;
//    _mainScrollView.maximumZoomScale = 5.0 ;
//    _mainScrollView.minimumZoomScale = 1.0 ;
//    _mainScrollView.zoomScale = 1.0 ;

}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    return _photoImageView ;
}



- (NSInteger)swipeToLeftWithIndex:(NSInteger)index withTotalImage:(NSInteger)total {
    // Prepare Anaimation

    [self performAnimationWithSubType:kCATransitionFromRight] ;

    // Move to next photo
    index += 1 ;
    if (index == total )
        index = 0 ;

    [self configureView]  ;

    return index ;


}
- (NSInteger)swipeToRightWithIndex:(NSInteger)index withTotalImage:(NSInteger)total {

    [self performAnimationWithSubType:kCATransitionFromLeft] ;

    //Move to previous photo

    index -= 1 ;
    if (index <0 )
        index = total - 1  ;

    [self configureView] ;
    return index ;
}

-(void)performAnimationWithSubType:(NSString*)subType {
    // Prepare Anaimation
    CATransition *transition = [CATransition animation] ;
    transition.duration  = 0.2 ;
    transition.timingFunction = [ CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn] ;
    transition.type = kCATransitionPush ;
    transition.subtype = subType ;

    [_photoImageView.layer addAnimation:transition forKey:nil] ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
