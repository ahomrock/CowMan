//
//  AH_PhotoDataManager.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/9/25.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "AH_PhotoDataManager.h"

@implementation AH_PhotoDataManager{
    NSMutableArray *photoFileNames ;
}

static AH_PhotoDataManager * _singletonDataManager ;

+(instancetype)shareInstance {

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _singletonDataManager = [AH_PhotoDataManager new] ;
        //Prepare photoFileNames

        [_singletonDataManager preparePhotoFileNames] ;

    });


    return _singletonDataManager ;
}

-(void) preparePhotoFileNames {
    photoFileNames = [NSMutableArray new] ;

    for( int i=1; i<=2 ; i++ ) {
        NSString *filename = [NSString stringWithFormat:@"selectMap0%d.jpg",i] ;
        [photoFileNames addObject:filename] ;
    }
}

-(NSInteger) getTotalCount {
    return  photoFileNames.count ;
}

-(NSString*) getFilenameByIndex:(NSInteger)index {
    return photoFileNames[index] ;

}
-(UIImage*) getImageIndex:(NSInteger)index {
    NSString *fileName = [self getFilenameByIndex:index] ;
    return [UIImage imageNamed:fileName];
    
}

-(NSMutableArray*) getImageNamesData {
    return photoFileNames ;
}
@end
