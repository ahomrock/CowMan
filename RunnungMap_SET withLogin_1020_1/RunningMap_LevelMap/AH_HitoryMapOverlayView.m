//
//  AH_HitoryMapOverlayView.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/28.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "AH_HitoryMapOverlayView.h"

@interface AH_HitoryMapOverlayView()

@property (nonatomic, strong) UIImage *overlayImage;

@end

@implementation AH_HitoryMapOverlayView

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage {
    self = [super initWithOverlay:overlay];
    if (self) {
        _overlayImage = overlayImage;
    }

    return self;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    CGImageRef imageReference = self.overlayImage.CGImage;

    MKMapRect theMapRect = [self.overlay boundingMapRect];
    CGRect theRect = [self rectForMapRect:theMapRect];

    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -theRect.size.height);
    CGContextDrawImage(context, theRect, imageReference);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
