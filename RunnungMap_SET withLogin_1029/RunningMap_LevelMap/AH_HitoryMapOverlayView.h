//
//  AH_HitoryMapOverlayView.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/28.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "AH_HistoryMapOverlay.h"


@interface AH_HitoryMapOverlayView : MKOverlayView

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage;

@end
