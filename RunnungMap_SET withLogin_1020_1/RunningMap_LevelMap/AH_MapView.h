//
//  AH_MapView.h
//  TaoyuanParkingRadar
//
//  Created by NO KR on 2016/9/11.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "HistoryPoint.h"


@interface AH_MapView : NSObject<MKMapViewDelegate>
@property (strong) MKMapView *mapView;
@property (strong) UIViewController *vc ;
@property (nonatomic,strong) HistoryPoint *historyPoint ;
@property CLLocationCoordinate2D mapCenter ;

+(instancetype)createWithMKView:(MKMapView*)mapView withVC:(UIViewController*)vc;
-(void)defautSetting  ;

- (void)startLoadMap;


-(void)clear ;
- (void)setRegionWithLat:(CLLocationDegrees)lat withLon:(CLLocationDegrees)lon ;

- (void)showLines :(NSMutableArray*)inputCoordinate withCenter:(CLLocationCoordinate2D)center ;
@end
