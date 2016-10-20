//
//  AH_SelectPhotoScrollView.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/9/25.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AH_SelectPhotoScrollView : UIScrollView


@property (assign,nonatomic) NSInteger targetIndex ;
@property (strong,nonatomic) UIScrollView *mainScrollView ;
@property (strong,nonatomic) UIImageView *photoImageView;




- (void)configureView ;
- (NSInteger)swipeToLeftWithIndex:(NSInteger)index withTotalImage:(NSInteger)total ;
- (NSInteger)swipeToRightWithIndex:(NSInteger)index withTotalImage:(NSInteger)total ;
@end




/*
 Should copy to present ViewController

 @interface ViewController () {
 AH_PhotoDataManager *mapDataManager ;
 NSInteger mapPhotoIndex ;
 }

 @property (weak, nonatomic) IBOutlet UIImageView *mainPhotoView;
 @property (weak, nonatomic) IBOutlet AH_SelectPhotoScrollView *mainScrollView;

 @end

 #pragma mark - AH_SelectPhotoScroll Methods

 - (void)prepareForSelectPhotoScroll {
 mapDataManager = [AH_PhotoDataManager shareInstance];
 _mainScrollView.photoImageDatas = [mapDataManager getImageNamesData] ;
 mapPhotoIndex = 1 ;
 _mainScrollView.photoImageView = _mainPhotoView ;
 _mainScrollView.photoImageView.image = [mapDataManager getImageIndex:1] ;
 }

 - (IBAction)swipeToLeft:(UISwipeGestureRecognizer *)sender {
 mapPhotoIndex = [_mainScrollView swipeToLeftWithIndex:mapPhotoIndex withTotalImage:mapDataManager.getTotalCount] ;
 _mainScrollView.photoImageView.image = [mapDataManager getImageIndex:mapPhotoIndex] ;

 }
 - (IBAction)swipeToRight:(UISwipeGestureRecognizer *)sender {
 mapPhotoIndex = [_mainScrollView swipeToRightWithIndex:mapPhotoIndex withTotalImage:mapDataManager.getTotalCount] ;
 _mainScrollView.photoImageView.image = [mapDataManager getImageIndex:mapPhotoIndex] ;
 }



 */
