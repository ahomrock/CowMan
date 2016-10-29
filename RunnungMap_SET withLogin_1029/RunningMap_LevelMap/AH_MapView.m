//
//  AH_MapView.m
//  TaoyuanParkingRadar
//
//  Created by NO KR on 2016/9/11.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "AH_MapView.h"
#import "AH_PerformAnimationManager.h"
#import "AH_HitoryMapOverlayView.h"




@interface AH_MapView() {
    UIColor *line_strokeColor;
    float line_Width ;

    HistoryPoint *hPoint ;
    AH_PerformAnimationManager *ahpaManager ;
    AH_HistoryMapOverlay *ah_overlay ;


}

@property(strong,nonatomic)AH_HistoryMapSet *old_map ;
@end


@implementation AH_MapView

+(instancetype)createWithMKView:(MKMapView*)mapView withVC:(UIViewController*)vc{
    AH_MapView * map = [[AH_MapView alloc] init ] ;

    if (map) {
        map.mapView = mapView ;
        map.mapView.delegate = map;
        map.vc = vc ;
        [map mapSetting] ;

        [map addOverlay]  ;

    }

    //[map defautSetting] ;
    return map;
}



-(void) defautSetting {
    line_Width = 0;
    _historyPoint =[ [HistoryPoint alloc]init ] ;
    ahpaManager = [AH_PerformAnimationManager new] ;
     //_mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading ;


    CAShapeLayer  *ba =[CAShapeLayer layer];
    ba.frame =  self.mapView.frame;


    MKZoomScale zoom = 20 ;
    [_mapView setContentScaleFactor:zoom] ;

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(60, 60, 300, 400) cornerRadius:5.0];
//
//
//    // [path closePath];//第五条线通过调用closePath方法得到的
//    UIImage *image = [UIImage imageNamed:@"gameMap_01.jpg"] ;
//    UIScrollView *scrollView =[ [UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)] ;
//
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.mapView.frame ];
//
//    imageView.image = image ;
//    imageView.contentMode = UIViewContentModeScaleAspectFill ;
//    imageView.alpha = 0.5 ;
//    imageView.backgroundColor = [UIColor blackColor] ;
//
//   // [scrollView addSubview:imageView] ;
//    [self.mapView addSubview:imageView ] ;

//    //根据坐标点连线
//    [path stroke];
    //[aPath fill];
    //        [path appendPath:line] ;
    ba.borderColor = [UIColor blackColor].CGColor;
    ba.lineWidth = 5.f;
    ba.path = path.CGPath;
    ba.fillColor = [UIColor clearColor].CGColor;
    ba.strokeColor = [UIColor whiteColor].CGColor;
//_mapView.im


   // [ _mapView.layer addSublayer:ba ] ;
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

             //   [self centerMap] ;

            }
            else
                NSLog(@"FAIL FAIL!!!") ;
            NSLog(@" -- - %d " ,i) ;
        }
    }

    [self setRegionWithLat:ah_overlay.coordinate.latitude-0.002 withLon:(ah_overlay.coordinate.longitude)] ;



}




#pragma mark - MKMapViewDelegate Methods


- (void)setRegionWithLat:(CLLocationDegrees)lat withLon:(CLLocationDegrees)lon {

    CLLocationCoordinate2D centerPoint = CLLocationCoordinate2DMake(lat, lon);

    MKCoordinateSpan span = MKCoordinateSpanMake(0.008,0.008);

    MKCoordinateRegion region = MKCoordinateRegionMake(centerPoint, span);

    [_mapView setRegion:region animated:NO];
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


    free(pointsCoordinate);

    [self.mapView addOverlay:polyline];

}

//
//
//- (MKPolylineRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{
//
//    // create a polylineView using polyline overlay object
//    MKPolylineRenderer *polylineView = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
//
//    // Custom polylineView
//    polylineView.strokeColor =  line_strokeColor;
//    polylineView.lineWidth = 10.0;
//    polylineView.alpha = 0.6;
//
//
//    return polylineView;
//}


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


///////



- (void)mapSetting {

    self.old_map = [[AH_HistoryMapSet alloc] initWithFilename:@"mapCoordinate"];

    CLLocationDegrees latDelta = self.old_map.overlayTopLeftCoordinate.latitude - self.old_map.overlayBottomRightCoordinate.latitude;

    // think of a span as a tv size, measure from one corner to another
    MKCoordinateSpan span = MKCoordinateSpanMake(fabs(latDelta), 0.0);

    MKCoordinateRegion region = MKCoordinateRegionMake(self.old_map.midCoordinate, span);

    [self.mapView setRegion:region];
}


- (void)addOverlay {
    ah_overlay = [[AH_HistoryMapOverlay alloc] initWithHistoryMap:_old_map];

    [self.mapView addOverlay:ah_overlay];
}
- (void)addRoute {
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"EntranceToGoliathRoute" ofType:@"plist"];
    NSArray *pointsArray = [NSArray arrayWithContentsOfFile:thePath];

    NSInteger pointsCount = [pointsArray count];

    CLLocationCoordinate2D pointsToUse[pointsCount];

    for(int i = 0; i < pointsCount; i++) {
        CGPoint p = CGPointFromString([pointsArray objectAtIndex:i]);
        pointsToUse[i] = CLLocationCoordinate2DMake(p.x,p.y);
    }

    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];

    [self.mapView addOverlay:myPolyline];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:AH_HistoryMapOverlay.class]) {
        UIImage *oldMapImage = [UIImage imageNamed:@"overlay_ncu"];

        AH_HitoryMapOverlayView *overlayView = [[AH_HitoryMapOverlayView alloc] initWithOverlay:overlay overlayImage:oldMapImage];
        //    overlayView.alpha = 0.8;

        return overlayView;
    } else if ([overlay isKindOfClass:MKPolyline.class]) {
        MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];

        // Custom polylineView
        lineView.strokeColor =  line_strokeColor;
        lineView.lineWidth = line_Width;
        lineView.alpha = 0.6;


        return (MKOverlayView*)lineView;
    }
//    } else if ([overlay isKindOfClass:MKPolygon.class]) {
//        MKPolygonView *polygonView = [[MKPolygonView alloc] initWithOverlay:overlay];
//        [polygonView setStrokeColor:[UIColor magentaColor]];
//
//        return polygonView;
//    } else if ([overlay isKindOfClass:PVCharacter.class]) {
//        MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
//        [circleView setStrokeColor:[(PVCharacter *)overlay color]];
//
//        return circleView;
//    }
//    
    return nil;
}





@end
