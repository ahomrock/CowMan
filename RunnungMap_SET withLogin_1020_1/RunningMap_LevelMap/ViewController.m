//
//  ViewController.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/9/25.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "ViewController.h"
#import "AH_SelectPhotoScrollView.h"
#import "AH_PhotoDataManager.h"
#import "AH_SelectTableView.h"
#import "InternetDetection.h"
#import "GetFirebaseCoordinate.h"

#define MOVE_MAX_Y 466
#define MOVE_MIN_Y 60

@interface ViewController () {
    // SelectPhotoScroll
    AH_PhotoDataManager *mapDataManager ;
    NSInteger mapPhotoIndex ;

    AH_SelectTableView *selectTableView ;

}


// SelectPhotoScroll
@property (strong) UIImageView *mainPhotoView;
@property (weak, nonatomic) IBOutlet AH_SelectPhotoScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *mapTitleBtn;
@property (strong, nonatomic) InternetDetection *net;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _mainPhotoView = [[UIImageView alloc]init] ;
    [_mainPhotoView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height*0.6)] ;
    [_mainScrollView addSubview:_mainPhotoView];
    _mainPhotoView.contentMode = UIViewContentModeScaleAspectFit ;
    [_mapTitleBtn setFrame:CGRectMake(self.view.frame.origin.x, _mainPhotoView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height *0.1)] ;
    [_mainTableView setFrame:CGRectMake(self.view.frame.origin.x, _mainPhotoView.frame.size.height + _mapTitleBtn.frame.size.height, self.view.frame.size.width, self.view.frame.size.height *0.1)] ;

    [self prepareForSelectPhotoScroll] ;
    selectTableView = [AH_SelectTableView startWithTableView:_mainTableView
                                               withImageView:_mainPhotoView] ;

    selectTableView.moveTabNavView = _mapTitleBtn ;
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown];
//    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
//        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    //Internet Decetion
    
//    GetFirebaseCoordinate * getFirebase = [GetFirebaseCoordinate alloc];
//    [getFirebase getFirebaseCoordinate];
    
    _net = [InternetDetection new];
    [_net internet];
    
    
//    

}

- (IBAction)mapSelectBtnPressed:(UIButton *)sender {
    mapDataManager.selectImage =[mapDataManager getImageIndex:mapPhotoIndex] ;
    mapDataManager.index = mapPhotoIndex ;
    if(mapDataManager.index == 0)
        mapDataManager.selectMapTitle = @"NCU" ;
    else if (mapDataManager.index == 1 )
        mapDataManager.selectMapTitle = @"CYCU";
}


#pragma mark - AH_SelectPhotoScroll Methods

- (void)prepareForSelectPhotoScroll {
    mapDataManager = [AH_PhotoDataManager shareInstance];

    mapPhotoIndex = 0 ;

    _mainScrollView.photoImageView = _mainPhotoView ;
    _mainScrollView.photoImageView.image = [mapDataManager getImageIndex:mapPhotoIndex] ;
    [_mainScrollView sendSubviewToBack:_mainScrollView.photoImageView ] ;
  [self setTitleBtnNameWithMapPhotoIndex:mapPhotoIndex] ;
}

- (IBAction)swipeToLeft:(UISwipeGestureRecognizer *)sender {
    mapPhotoIndex = [_mainScrollView swipeToLeftWithIndex:mapPhotoIndex withTotalImage:mapDataManager.getTotalCount] ;
    _mainScrollView.photoImageView.image = [mapDataManager getImageIndex:mapPhotoIndex] ;

    [self setTitleBtnNameWithMapPhotoIndex:mapPhotoIndex] ;


}
- (IBAction)swipeToRight:(UISwipeGestureRecognizer *)sender {
    mapPhotoIndex = [_mainScrollView swipeToRightWithIndex:mapPhotoIndex withTotalImage:mapDataManager.getTotalCount] ;
    _mainScrollView.photoImageView.image = [mapDataManager getImageIndex:mapPhotoIndex] ;

    [self setTitleBtnNameWithMapPhotoIndex:mapPhotoIndex] ;
    
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
//        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void) setTitleBtnNameWithMapPhotoIndex:(NSInteger)index {
    if( index % 2== 0)
        _mapTitleBtn.titleLabel.text = @"N C U" ;
    else if (index %2 == 1)
        _mapTitleBtn.titleLabel.text = @"CYCU" ;
}

//tablevie
//
//CGPoint originalLocation;
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    originalLocation = [touch locationInView:_moveTableNavView];
//}
//
////對畫面進行拖曳動做時所觸發的函式
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//
//    UITouch *touch = [touches anyObject];
//    CGPoint currentLocation = [touch locationInView:_moveTableNavView];
//    CGRect frame = _moveTableNavView.frame;
//    CGRect tableFrame = _mainTableView.frame ;
//
//
//        frame.origin.y += currentLocation.y-originalLocation.y ;
//        tableFrame.origin.y += currentLocation.y-originalLocation.y ;
//        tableFrame.size.height += currentLocation.y-originalLocation.y;
//  if(  (frame.origin.y > MOVE_MIN_Y )  && (frame.origin.y < MOVE_MAX_Y)) {
//       _moveTableNavView.frame = frame ;
//        _mainTableView.frame = CGRectMake(frame.origin.x, frame.origin.y+frame.size.height, frame.size.width, self.view.frame.size.height-frame.origin.y);
//    }
//
//    NSLog(@"aa : %0.0f" ,frame.origin.y) ;
//    //將XY軸的座標資訊正規化後輸出
//    NSString *moveX = [NSString stringWithFormat:@"%0.0f", [touch locationInView:touch.view].x];
//    NSString *moveY = [NSString stringWithFormat:@"%0.0f", [touch locationInView:touch.view].y];
//
//
//    NSLog(@"%@, %@ " , moveX,moveY);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
