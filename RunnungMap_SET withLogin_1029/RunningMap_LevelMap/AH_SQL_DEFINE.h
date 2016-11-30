//
//  AH_SQL_DEFINE.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/11/29.
//  Copyright © 2016年 aHom. All rights reserved.
//

#define DBFILENAME @"HistoryLog.sqlite"


#define CREATE_TABLE_gameMaster_SQL @"CREATE TABLE IF NOT EXISTS gameMaster(game_id varchar(9), map_id varchar(6),game_date datetime NOT NULL, totalTime varchar(200) NOT NULL, user_id varchar(200) NOT NULL, PRIMARY KEY(game_id, map_id))"

#define CREATE_TABLE_map_table_SQL @"CREATE TABLE IF NOT EXISTS map_table(  map_id varchar(6), map_title varchar(20) NOT NULL, map_subtitle varchar(20) NOT NULL, map_description text NOT NULL, map_targetLocate_id varchar(7), map_imageFileName varchar(50) NOT NULL , map_selectMapFileName varchar(50) NOT NULL, PRIMARY KEY(map_id, map_targetLocate_id))"

#define CREATE_TABLE_map_target_table_SQL @"CREATE TABLE IF NOT EXISTS map_target_table(  map_targetLocate_id varchar(7), target_id varchar(3) , target_lat double NOT NULL , target_lon double NOT NULL , PRIMARY KEY(map_targetLocate_id,target_id))"

#define CREATE_TABLE_path_table_SQL @"CREATE TABLE IF NOT EXISTS path_table( game_id varchar(9), path_id varchar(7) , path_locate_id integer primary key autoincrement, path_time varchar(200) NOT NULL, path_lat double NOT NULL, path_lon double NOT NULL)"


// Insert
#define INSERT_map_table_SQL @"INSERT INTO map_table(map_id,map_title,map_subtitle,map_description,map_targetLocate_id,map_imageFileName,map_selectMapFileName) VALUES(?,?,?,?,?,?,?)"

#define INSERT_map_target_table_SQL @"INSERT INTO map_target_table(map_targetLocate_id, target_id,target_lat, target_lon) VALUES(?,?,?,?)"


#define INSERT_path_table_SQL @"INSERT INTO path_table( game_id, path_id, path_time,path_lat,path_lon) VALUES(?,?,?,?,?)"






// gameMaster
#define GAME_ID_KEY @"game_id"
#define GAME_DATE_KEY @"map_id"
#define TOTALTIME_KEY @"totalTime"
#define USER_ID_KEY @"user_id"

// map_table
#define SELECT_map_table_SQL @"SELECT * from map_table;"
#define MAP_ID_KEY @"map_id"
#define MAP_TITLE_KEY @"map_title"
#define MAP_SUBTITLE_KEY @"map_subtitle"
#define MAP_DESCRIPTION_KEY @"map_description"

#define MAP_IMAGE_FILE_NAME @"map_imageFileName"
#define MAP_SELECTMAP_FILENAME @"map_selectMapFileName"



// map_target_table
#define SELECT_map_target_table_SQL @"SELECT * from map_target_table"
#define MAP_TARGETLOCATE_ID_KEY @"map_targetLocate_id"
#define MAP_TARGET_ID_KEY @"target_id"
#define MAP_TARGET_LAT @"target_lat"
#define MAP_TARGET_LON @"target_lon"


// path_table
#define SELECT_path_table_SQL @"SELECT * from path_table"
#define PATH_ID_KEY @"path_id"
#define PATH_LOCATE_ID_KEY @"path_locate_id"
#define PATH_TIME_KEY @"path_time"
#define PATH_LAT_KEY @"path_lat"
#define PATH_LON_KEY @"path_lon"


