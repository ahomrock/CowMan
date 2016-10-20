//
//  ImageAnnotationView.m
//  HelloMyFriend
//
//  Created by NO KR on 2016/8/22.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "ImageAnnotationView.h"

@implementation ImageAnnotationView

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier] ;

    return self ;
}
@end
