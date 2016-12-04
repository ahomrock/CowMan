//
//  AH_SQLiteManager.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/11/28.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "AH_SQLiteManager.h"
#import "AH_SQL_DEFINE.h"
#import <FMDB/FMDB.h>
#import "LevelMapsManager.h"
#import "HistoryDataManager.h"
#import <CoreLocation/CoreLocation.h>

@interface AH_SQLiteManager(){
    NSString *dbFilePathName ;
    FMDatabase *db ;
    NSMutableArray *mids ;
}
@end

@implementation AH_SQLiteManager

+(instancetype)sharedInstance {
    static AH_SQLiteManager *manager = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AH_SQLiteManager alloc]init ] ;
    });

    return manager ;
}


-(instancetype)init {
    self = [super init];

    mids = [NSMutableArray new] ;
    // Prepare dbFilePathName

    NSURL *cachesURL = [[NSFileManager defaultManager]URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject ;
    NSURL *dbFileURL = [cachesURL URLByAppendingPathComponent:DBFILENAME] ;
    dbFilePathName = dbFileURL.path ;
    NSLog(@"cxnvdfjkgn : %@",dbFilePathName) ;
    //  Prepare or Create db
    db = [FMDatabase databaseWithPath:dbFilePathName];
    if([[NSFileManager defaultManager] fileExistsAtPath:dbFilePathName] == false ) {
        //First time , create table
        NSLog(@"vxcvxcvsvsd") ;

        if([db open] ) {
            Boolean success =[self createTable] ;
            NSLog(@"Create DB Table : %@",(success?@"OK":@"Fail")) ;

            Boolean successInsertDefult = [self insertDefautMapData] ;
            NSLog(@"INsert map Data:%@", (successInsertDefult?@"ok":@"Fail")) ;
            
            [db close] ;
        }
    }
    else  {
        // DB/Table alreadt created. Prepare mids
        NSLog(@"sfvnxcjkvns") ;
//        if([db open]) {
//            [self setLevelMapData];
//            [db close] ;
//
//        } else
//            NSLog(@"cvnbjerhiuwe") ;

        [self resumeHistoryData] ;
    }
    
    return self ;
}

-(bool) createTable {

    if([db executeUpdate:CREATE_TABLE_gameMaster_SQL] &&
       [db executeUpdate:CREATE_TABLE_map_table_SQL] &&
       [db executeUpdate:CREATE_TABLE_map_target_table_SQL] &&
       [db executeUpdate:CREATE_TABLE_path_table_SQL] )
        return true ;

    return false ;

}

-(bool) insertDefautMapData {
// map_table(  map_id varchar(6), map_title varchar(20) NOT NULL, map_subtitle varchar(20) NOT NULL, map_description text NOT NULL, map_targetLocate_id varchar(7), map_imageFileName varchar(50) NOT NULL , map_selectMapFileName varchar(50) NOT NULL, PRIMARY KEY(map_id, map_targetLocate_id))"

    NSString *map_id = @"map001" ;
    NSString *map_title = @"ncu" ;
    NSString *map_subtitle = @"ncu" ;
    NSString *map_Description = @"zombile in mountile" ;
    NSString *map_targetLocate_id = @"mt00101" ;
    NSString *map_imageFileName = @"gameMap_01.jpg" ;
    NSString *map_selectMapFileName = @"selectMap01" ;

    if( [db executeUpdate:INSERT_map_table_SQL,map_id,map_title,map_subtitle,map_Description,map_targetLocate_id,map_imageFileName,map_selectMapFileName])
        return true ;

    return false ;
}




-(void)setLevelMapData {
    NSString *sql = SELECT_map_table_SQL;
    FMResultSet *result = [db executeQuery:sql];

    while([result next]) {
        LevelMapPoint *point = [[LevelMapPoint alloc]init] ;
        point.map_id = [result stringForColumn:MAP_ID_KEY] ;
        point.title = [result stringForColumn:MAP_TITLE_KEY] ;
        point.mapDescription = [result stringForColumn:MAP_DESCRIPTION_KEY] ;
        point.map_targetLocate_id = [result stringForColumn:MAP_TARGETLOCATE_ID_KEY] ;
        point.map_imageFileName = [result stringForColumn:MAP_IMAGE_FILE_NAME] ;
        point.map_selectMapFileName = [result stringForColumn:MAP_SELECTMAP_FILENAME];

        [[LevelMapsManager sharedInstance].levelMapPoints addObject:point] ;
    }
}



//
//- (void)copyHistoryPointToSqlite {
//    HistoryPoint *point = _historyPoints.lastObject ;
//
//    AH_SQLiteManager *sqlManager = [AH_SQLiteManager sharedInstance] ;
//
//    for (int i = 0 ; i < point.locationPaths.count; i++) {
//        for (int j = 0; j<[point.locationPaths[i] count]; j++) {
//            CLLocation *locate = point.locationPaths[i][j] ;
//            NSString *path_id = [NSString stringWithFormat:@"path%d",i] ;
//            [sqlManager insertPathTableWithGame_id:point.game_id
//                                       withPath_id:path_id
//                                withPath_locate_id:j
//                                     withPath_time:point.locationPathTimeStamp[i]
//                                      withPath_lat:locate.coordinate.latitude
//                                      withPath_lon:locate.coordinate.longitude] ;
//        }
//    }
//    
//    
//}

-(void)resumeHistoryData {
    if ([db open] ) {
        FMResultSet *result = [db executeQuery:SELECT_path_table_SQL] ;

        NSMutableArray *allLocation = [NSMutableArray new] ;
        NSMutableArray *paths = [NSMutableArray new] ;
        NSString *path_id = @"" ;
        NSString *game_id = @"" ;
        NSString *game_id_sql = @"" ;
        NSString *timeStamp = @"" ;
        HistoryPoint *point = [[HistoryPoint alloc]init];
        bool lock = false ;

        while ([result next]) {
            int i = [result intForColumn:PATH_LOCATE_ID_KEY] ;
            NSLog( @"==== %d",i );
            NSString *path_id_sql = [result stringForColumn:PATH_ID_KEY] ;
            game_id_sql = [result stringForColumn:GAME_ID_KEY] ;

            if( !lock ) {
                path_id = path_id_sql ;
                game_id = game_id_sql ;
                lock = true ;
            }

            double lat = [result doubleForColumn:PATH_LAT_KEY] ;
            double lon = [result doubleForColumn:PATH_LON_KEY] ;

            CLLocation *location =  [[CLLocation alloc]initWithLatitude:lat longitude: lon];

            if ( ![path_id isEqualToString:path_id_sql] ) {
                [point.getTargetLocate addObject:location] ;
                [point.locationPaths addObject:paths] ;
                [point.locationPathTimeStamp addObject:timeStamp] ;
                paths = [NSMutableArray new] ;
                path_id = path_id_sql ;
            }

            [paths addObject:location] ;
            [allLocation addObject:location] ;


            if( ![game_id isEqualToString:game_id_sql]) {
                point.allLocations = allLocation ;
                point.totalTime = timeStamp ;
                point.mapTitle = @"NCU" ;
                [[HistoryDataManager sharedInstance].historyPoints addObject:point] ;
                point = [[HistoryPoint alloc]init] ;
                game_id = game_id_sql ;
            }

            timeStamp = [result stringForColumn:PATH_TIME_KEY] ;
        }

        if (point != nil && allLocation.count > 0 ) {
            [point.getTargetLocate addObject:allLocation.lastObject] ;
            [point.locationPaths addObject:paths] ;
            [point.locationPathTimeStamp addObject:timeStamp] ;
            point.allLocations = allLocation ;
            point.totalTime = timeStamp ;
            point.mapTitle = @"NCU" ;
            point.game_id = game_id_sql ;
            [[HistoryDataManager sharedInstance].historyPoints addObject:point] ;
        }
        [db close] ;

    }
}

-(bool) insertPathTableWithGame_id:(NSString*)game_id
                       withPath_id:(NSString*)path_id
                    withPath_time:(NSString*)path_time
                      withPath_lat:(NSString*)path_lat
                      withPath_lon:(NSString*)path_lon {
    if( [db executeUpdate:INSERT_path_table_SQL,game_id,path_id,path_time,path_lat,path_lon]){
        return true ;
    }

    return false ;
}


- (void)copyHistoryPointToSqlite {
    HistoryPoint *point = [HistoryDataManager sharedInstance].historyPoints.lastObject;

    if([db open]) {
        for (int i = 0 ; i < point.locationPaths.count; i++) {
            for (int j = 0; j<[point.locationPaths[i] count]; j++) {
                CLLocation *locate = point.locationPaths[i][j] ;
                NSString *path_id = [NSString stringWithFormat:@"path%d",i+1] ;

                NSString *path_time = point.locationPathTimeStamp[i];
                NSString *lat = [NSString stringWithFormat:@"%f",locate.coordinate.latitude] ;
                NSString *lon = [NSString stringWithFormat:@"%f",locate.coordinate.longitude];

                bool success = [self insertPathTableWithGame_id:point.game_id
                                                    withPath_id:path_id
                                                  withPath_time:path_time
                                                   withPath_lat:lat
                                                   withPath_lon:lon] ;
                if(success)
                    NSLog(@"OK");
                else
                    NSLog(@"FAIL") ;
            }
        }
    }
    [db close] ;
    
    
}


// TEST FOR DATA
- (void)checkHistoryData {
    HistoryPoint *point = [HistoryDataManager sharedInstance].historyPoints.lastObject;

        for (int i = 0 ; i < point.locationPaths.count; i++) {
            for (int j = 0; j<[point.locationPaths[i] count]; j++) {
                CLLocation *locate = point.locationPaths[i][j] ;
                NSString *path_id = [NSString stringWithFormat:@"path%d",i+1] ;

                NSString *path_time = point.locationPathTimeStamp[i];
                NSString *lat = [NSString stringWithFormat:@"%f",locate.coordinate.latitude] ;
                NSString *lon = [NSString stringWithFormat:@"%f",locate.coordinate.longitude];

                NSLog(@"xcmv======================") ;
                NSLog(@"vvsdjnk :path_id: %@ gmaeid %@", path_id,point.game_id) ;
                NSLog(@"xcnvk lat:%@, lon:%@,",lat,lon);
                NSLog(@"zcnjn:time : %@",path_time) ;

            }
        }

    
}



//
//
//#pragma mark - Photo Caches Support
//- (void)savePhotoWithFileName:(NSString*)fileName data:(NSData*)fileData {
//    NSURL *fullFilePathURL = [self fullURLWithFileName:fileName] ;
//    [fileData writeToURL:fullFilePathURL atomically:true] ;
//
//
//}


//
//- (UIImage*)loadPhotoWithFileName:(NSString*)fileName {
//
//    NSURL* fullFilePathURL = [self fullURLWithFileName:fileName] ;
//    UIImage *result = [UIImage imageWithContentsOfFile:fullFilePathURL.path] ;
//
//    return result ;
//}
//
//
//- (NSURL*)fullURLWithFileName:(NSString*)fileName {
//    // Find cache folder url
//    NSURL *cachesURL = [[NSFileManager defaultManager]URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject ;
//    NSLog(@"cachesURL: %@",cachesURL);
//
//    // Decide file name
//    NSString *hashedFileName = [NSString stringWithFormat:@"%lu.jpg",fileName.hash] ;
//    NSURL *result = [cachesURL URLByAppendingPathComponent:hashedFileName] ;
//
//    return result ;
//
//}
//
//#pragma mark - Chat Messages Management Methods
//
//- (void)addChatLog:(NSDictionary*)message {
//    if([db open]) {
////        NSString *sql = [NSString stringWithFormat:INSERT_CHAT_LOG_SQL,ID_KEY,USER_NAME_KEY, MESSAGE_KEY,TYPE_KEY] ;
////        Boolean success = [db executeUpdate:sql,message[ID_KEY],message[USER_NAME_KEY],message[TYPE_KEY]] ;
//
//        [db close] ;
//        if(success) {
//            NSInteger lastmid = [self getLastmid] ;
//            [mids addObject:@(lastmid)] ;
//        }
//        else
//            NSLog(@"Add Chat Log Fail.") ;
//
//    }
//
//}
//
//
//- (NSDictionary*)getMessageByIndex:(NSInteger)index {
//    if(index >= mids.count || index < 0)
//        return nil ;
//
//    NSInteger targetmid = [mids[index] integerValue] ;
//    NSDictionary *message ;
//
//    if([db open]) {
//        NSString *sql = [NSString stringWithFormat:GET_MESSAGE_BY_INDEX_SQL,MID_KEY,targetmid] ;
//        FMResultSet *result = [db executeQuery:sql] ;
//        while([result next]) {
//            message = @{ID_KEY:@([result intForColumn:ID_KEY]),USER_NAME_KEY:[result stringForColumn:USER_NAME_KEY],MESSAGE_KEY:[result stringForColumn:MESSAGE_KEY],TYPE_KEY:@([result intForColumn:TYPE_KEY]) } ;
//        }
//
//        [db close] ;
//    }
//
//    return message ;
//}
//- (NSInteger)getTotalCount {
//    return mids.count ;
//    // SELECT COUNT(*)FROM chatlog_table;
//}
//
//
//- (NSInteger)getLastmid {
//    NSInteger resultValue ;
//
//    if([db open]) {
//        NSString *sql = GET_LAST_MID_SQL;
//        FMResultSet *result = [db executeQuery:sql] ;
//        if([result next]) {
//            resultValue = [result intForColumn:MID_KEY] ;
//        }
//        
//        [db close];
//    }
//    
//    return resultValue ;
//    
//}
//
//
@end
