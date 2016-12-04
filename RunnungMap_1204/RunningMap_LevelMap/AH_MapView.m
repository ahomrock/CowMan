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

    int coorinate_index ;

    NSMutableArray *inputCoordinate ;

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
                inputCoordinate = hPoint.locationPaths[i] ;
                [self createLine] ;


                CLLocation *tempLocate = hPoint.getTargetLocate[i] ;
                MKPointAnnotation *annotation =[ [MKPointAnnotation alloc]init ];

                annotation.title = [NSString stringWithFormat:@"Target:%d",i];
                annotation.subtitle = hPoint.locationPathTimeStamp[i];

                annotation.coordinate = CLLocationCoordinate2DMake(tempLocate.coordinate.latitude, tempLocate.coordinate.longitude);
                NSLog(@".. c %f,%f",annotation.coordinate.latitude,annotation.coordinate.longitude);
                
                [self.mapView addAnnotation:annotation] ;


            }
            else
                NSLog(@"FAIL FAIL!!!") ;
            NSLog(@" -- - %d " ,i) ;
        }
    }

    coorinate_index = 0 ;

//    inputCoordinate = hPoint.allLocations ;
    [self createLine ] ;


    [self getTotalMapVision] ;

}

-(void) getTotalMapVision {

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
//
//    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//
//    [rightButton addTarget:self action:@selector(buttonPrssed:) forControlEvents:UIControlEventTouchUpInside];

//    resultView.rightCalloutAccessoryView = rightButton;


    resultView.animatesDrop = YES;

    resultView.pinTintColor= [UIColor blueColor];

    return resultView;
}

- (void) buttonPrssed:(id)sender {

}
-(void)clear {
   
}

#pragma mark - show Line Method

-(void)createLine{
    NSLog(@"ASCACZXCV ,%lu" ,(unsigned long)inputCoordinate.count) ;
    double delayTime = 1.5 / inputCoordinate.count ;
    if(coorinate_index >= inputCoordinate.count -1)
        return ;

    CLLocationCoordinate2D *pointCoordinate = (CLLocationCoordinate2D *) malloc(sizeof(CLLocationCoordinate2D) *2) ;

    pointCoordinate[0] = CLLocationCoordinate2DMake([[inputCoordinate objectAtIndex:coorinate_index] coordinate].latitude, [[inputCoordinate objectAtIndex:coorinate_index] coordinate].longitude);
    pointCoordinate[1] = CLLocationCoordinate2DMake([[inputCoordinate objectAtIndex:coorinate_index+1] coordinate].latitude, [[inputCoordinate objectAtIndex:coorinate_index+1] coordinate].longitude);

    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:pointCoordinate count:2];

    
    free(pointCoordinate);

    [self.mapView addOverlay:polyline];


    coorinate_index++ ;

    [self performSelector:@selector(createLine) withObject:nil afterDelay:delayTime] ;

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

    return nil;
}





@end
