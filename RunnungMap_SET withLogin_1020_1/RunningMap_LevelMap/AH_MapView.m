//
//  AH_MapView.m
//  TaoyuanParkingRadar
//
//  Created by NO KR on 2016/9/11.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "AH_MapView.h"


@interface AH_MapView() {
    UIColor *line_strokeColor;
}
@end


@implementation AH_MapView

+(instancetype)createWithMKView:(MKMapView*)mapView withVC:(UIViewController*)vc{
    AH_MapView * map = [[AH_MapView alloc] init ] ;

    if (map) {
        map.mapView = mapView ;
        map.mapView.delegate = map;
        map.vc = vc ;

    }

    [map defautSetting] ;
    return map;
}

-(void) defautSetting {
    _historyPoint =[ [HistoryPoint alloc]init ] ;
     //_mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading ;



}

- (void)startLoadMap {

    if(_historyPoint.locationPaths.count > 0) {

        for(int i = 0 ; i < _historyPoint.locationPaths.count ; i++ ) {
            if ( i % 2 == 0)
                line_strokeColor = [UIColor redColor] ;
            else
                line_strokeColor = [UIColor blueColor] ;
            
            if (_historyPoint) {
                [self showLines:_historyPoint.locationPaths[i] withCenter:self.mapCenter] ;
            }
            else
                NSLog(@"FAIL FAIL!!!") ;
        }
    }



}



#pragma mark - MKMapViewDelegate Methods


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    // MKCoordinateRegion region =  mapView.region ;
}


- (void)setRegionWithLat:(CLLocationDegrees)lat withLon:(CLLocationDegrees)lon {

    CLLocationCoordinate2D centerPoint = CLLocationCoordinate2DMake(lat, lon);

    MKCoordinateSpan span = MKCoordinateSpanMake(0.01,0.01);

    MKCoordinateRegion region = MKCoordinateRegionMake(centerPoint, span);

    [_mapView setRegion:region animated:true];
}

- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if(annotation == mapView.userLocation)
        return nil;

    MKPinAnnotationView *resultView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Store"];


    if(resultView==nil) {
        resultView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Store"];
    }
    else {
        resultView.annotation = annotation;
    }


    resultView.canShowCallout = YES;

    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    [rightButton addTarget:self action:@selector(buttonPrssed:) forControlEvents:UIControlEventTouchUpInside];

    resultView.rightCalloutAccessoryView = rightButton;


        resultView.animatesDrop = YES;

        resultView.pinTintColor= [UIColor redColor];


    return resultView;
}

- (void) buttonPrssed:(id)sender {



}
-(void)clear {
   
}


#pragma mark - show Line Method
- (void)showLines :(NSMutableArray*)inputCoordinate withCenter:(CLLocationCoordinate2D)center{
    CLLocationCoordinate2D *pointsCoordinate = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * [inputCoordinate count]);
    for (int i = 0; i < [inputCoordinate count]; i++ ) {
        pointsCoordinate[i] = CLLocationCoordinate2DMake([[inputCoordinate objectAtIndex:i] coordinate].latitude, [[inputCoordinate objectAtIndex:i] coordinate].longitude);
    }

    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:pointsCoordinate count:[inputCoordinate count]];


    MKCoordinateSpan span = MKCoordinateSpanMake(0.01,0.01);
//    _mapView.zoomEnabled = false ;
//    _mapView.scrollEnabled = false ;

//    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 150, 150) ;
    [_mapView setRegion:region animated:false];

    free(pointsCoordinate);

    [self.mapView addOverlay:polyline];


}

//
//- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
//{
//    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
//    circleView.strokeColor = [UIColor blackColor];
//    circleView.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
//    return circleView;
//}
//
- (MKPolylineRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{

    // create a polylineView using polyline overlay object
    MKPolylineRenderer *polylineView = [[MKPolylineRenderer alloc] initWithPolyline:overlay];

    // Custom polylineView
    polylineView.strokeColor =  line_strokeColor;
    polylineView.lineWidth = 6.0;
    polylineView.alpha = 0.6;


    return polylineView;
}

- (void)setMapViewRegionWithCenter:(CLLocationCoordinate2D)center withZoom:(MKCoordinateSpan)zoom{

    //the center of the region we'll move the map to
//    center.latitude ;
//    center.longitude = CENTRAL_PARK_LON;

    //set up zoom level

    zoom.latitudeDelta = .1f; //the zoom level in degrees
    zoom.longitudeDelta = .1f;//the zoom level in degrees

    //stores the region the map will be showing
    MKCoordinateRegion myRegion;
    myRegion.center = center;//the location
    myRegion.span = zoom;//set zoom level


    //programmatically create a map that fits the screen
//    CGRect screen = [[UIScreen mainScreen] bounds];
//    MKMapView *mapView = [[MKMapView alloc] initWithFrame:screen ];
//
//    //set the map location/region
    [_mapView setRegion:myRegion animated:NO];

    _mapView.mapType = MKMapTypeStandard;//standard map(not satellite)

}


@end
