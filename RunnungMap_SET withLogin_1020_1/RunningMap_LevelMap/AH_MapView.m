//
//  AH_MapView.m
//  TaoyuanParkingRadar
//
//  Created by NO KR on 2016/9/11.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "AH_MapView.h"
#import "AH_PerformAnimationManager.h"

@interface AH_MapView() {
    UIColor *line_strokeColor;
    HistoryPoint *hPoint ;
    AH_PerformAnimationManager *ahpaManager ;
    
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
    ahpaManager = [AH_PerformAnimationManager new] ;
     //_mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading ;



}

- (void)prepareLoad {
    hPoint = _historyPoint ;

    NSMutableArray *annotations = [NSMutableArray new] ;
    if(hPoint.getTargetLocate.count > 0) {

        for(int i = 0 ; i < hPoint.getTargetLocate.count ; i++ ) {
            NSLog(@"cc : %d", i);
            CLLocation *tempLocate = hPoint.getTargetLocate[i] ;
            MKPointAnnotation *annotation =[ [MKPointAnnotation alloc]init ];

            annotation.title = [NSString stringWithFormat:@"Target:%d",i];
            annotation.subtitle = hPoint.locationPathTimeStamp[i];

            annotation.coordinate = CLLocationCoordinate2DMake(tempLocate.coordinate.latitude, tempLocate.coordinate.longitude);
            NSLog(@".. c %f,%f",annotation.coordinate.latitude,annotation.coordinate.longitude);

            [annotations addObject:annotation] ;

        }
         [self.mapView addAnnotations:annotations] ;
    }

}
- (void)startLoadMap {
    [self prepareLoad] ;
    if(hPoint.locationPaths.count > 0) {

        for(int i = 0 ; i < hPoint.locationPaths.count ; i++ ) {


            if ( i % 2 == 0)
                line_strokeColor = [UIColor redColor] ;
            else
                line_strokeColor = [UIColor blueColor] ;
            
            if (_historyPoint) {
                [self showLines:hPoint.locationPaths[i] withCenter:self.mapCenter] ;

                [self centerMap] ;

            }
            else
                NSLog(@"FAIL FAIL!!!") ;
            NSLog(@" -- - %d " ,i) ;
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
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.01,0.01);
//    _mapView.zoomEnabled = false ;
//    _mapView.scrollEnabled = false ;

//    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 150, 150) ;
//    [_mapView setRegion:region animated:false];

    free(pointsCoordinate);

    [ahpaManager performAnimationWithType:kCATransitionFade WithSubType:kCATransitionFade withView:self.mapView] ;
    [self.mapView addOverlay:polyline];

}



- (MKPolylineRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{

    // create a polylineView using polyline overlay object
    MKPolylineRenderer *polylineView = [[MKPolylineRenderer alloc] initWithPolyline:overlay];

    // Custom polylineView
    polylineView.strokeColor =  line_strokeColor;
    polylineView.lineWidth = 10.0;
    polylineView.alpha = 0.6;


    return polylineView;
}


-(void) centerMap {
    if (hPoint.locationPaths) {
        NSArray * routes =  (NSArray*)hPoint.allLocations ;
        MKCoordinateRegion region;

        CLLocationDegrees maxLat = -90.0;
        CLLocationDegrees maxLon = -180.0;
        CLLocationDegrees minLat = 90.0;
        CLLocationDegrees minLon = 180.0;
        for(int idx = 0; idx < routes.count; idx++) {
            CLLocation* currentLocation = [routes objectAtIndex:idx];
            if(currentLocation.coordinate.latitude > maxLat)
                maxLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.latitude < minLat)
                minLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.longitude > maxLon)
                maxLon = currentLocation.coordinate.longitude;
            if(currentLocation.coordinate.longitude < minLon)
                minLon = currentLocation.coordinate.longitude;
        }
        region.center.latitude     = (maxLat + minLat) / 2.0;
        region.center.longitude    = (maxLon + minLon) / 2.0;
        region.span.latitudeDelta = 0.01;
        region.span.longitudeDelta = 0.01;

        region.span.latitudeDelta  = ((maxLat - minLat)<0.0)?100.0:(maxLat - minLat);
        region.span.longitudeDelta = ((maxLon - minLon)<0.0)?100.0:(maxLon - minLon);
        [_mapView setRegion:region animated:false];
    }
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


-(void)createAnnotation {
    MKPointAnnotation *annotation =[ [MKPointAnnotation alloc]init];

    [_mapView addAnnotation:annotation] ;
}


@end
