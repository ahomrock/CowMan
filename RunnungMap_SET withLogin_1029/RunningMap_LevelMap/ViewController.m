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

#import "InternetDetection.h"
#import "SeverConnectManager.h"


#define MOVE_MAX_Y 466
#define MOVE_MIN_Y 60

@interface ViewController () {
    // SelectPhotoScroll
    AH_PhotoDataManager *mapDataManager ;
    NSInteger mapPhotoIndex ;

    SeverConnectManager * scManager;

    int scrollingLength ;
}


// SelectPhotoScroll
@property (strong) UIImageView *mainPhotoView;
@property (weak, nonatomic) IBOutlet AH_SelectPhotoScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UIButton *mapTitleBtn;
@property (strong, nonatomic) InternetDetection *net;
@property (weak, nonatomic) IBOutlet UITextView *mapDescriptionTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  
    // Do any additional setup after loading the view, typically from a nib.
    _mainPhotoView = [[UIImageView alloc]init] ;
    CGPoint originalPoint = self.view.frame.origin ;
    CGSize originalSize = self.view.frame.size ;

    [_mainPhotoView setFrame:CGRectMake(originalPoint.x, originalPoint.y , originalSize.width, originalSize.height*0.5)] ;
    [_mainScrollView addSubview:_mainPhotoView];

    _mainPhotoView.contentMode = UIViewContentModeScaleAspectFit ;

    [_mapTitleBtn setFrame:CGRectMake(originalPoint.x, _mainPhotoView.frame.size.height, originalSize.width, originalSize.height *0.1)] ;

    [_mapDescriptionTextView setFrame:CGRectMake(originalPoint.x+originalSize.width*0.2, _mapTitleBtn.frame.origin.y+_mapTitleBtn.frame.size.height+5, originalSize.width*0.6, originalSize.height *0.2)] ;
    _mapDescriptionTextView.layoutManager.allowsNonContiguousLayout = NO;
    NSRange bottom = NSMakeRange(0 , 1);
    [_mapDescriptionTextView scrollRangeToVisible:bottom];

    [self prepareForSelectPhotoScroll] ;


    _net = [InternetDetection new];
    [_net internet];


    scManager = [SeverConnectManager sharedInstance];


}


-(void)viewDidAppear:(BOOL)animated {
//    _mapDescriptionTextView.text = text;


//    scrollingLength = 0 ;
//    [UITextView beginAnimations:@"textView" context:nil];
//    [UITextView setAnimationDuration:10.f];
//
//    _mapDescriptionTextView.layoutManager.allowsNonContiguousLayout = NO;
//    NSRange bottom = NSMakeRange(_mapDescriptionTextView.text.length-1 , 1);
//    [_mapDescriptionTextView scrollRangeToVisible:bottom];
//    [UITextView commitAnimations];
//    [self performSelector:@selector(scrollTextViewToBottom) withObject:nil afterDelay:10.0] ;
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

}

- (void) setTitleBtnNameWithMapPhotoIndex:(NSInteger)index {
    if( index % 2== 0)
        _mapTitleBtn.titleLabel.text = @"N C U" ;
    else if (index %2 == 1)
        _mapTitleBtn.titleLabel.text = @"CYCU" ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
