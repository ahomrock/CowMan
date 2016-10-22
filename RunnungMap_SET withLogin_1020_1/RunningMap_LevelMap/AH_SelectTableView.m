//
//  AH_SelectTableView.m
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/9/25.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "AH_SelectTableView.h"
#import "AH_PerformAnimationManager.h"


@interface AH_SelectTableView()

@end

@implementation AH_SelectTableView

+(instancetype)startWithTableView:(UITableView *)tableView withImageView:(UIImageView *)imageView {
    AH_SelectTableView *selectTable = [[AH_SelectTableView alloc] init] ;
    if (selectTable) {
        selectTable.tableView = tableView ;
        selectTable.imageView = imageView ;
        selectTable.tableView.delegate = selectTable ;
        selectTable.tableView.dataSource = selectTable ;
        selectTable.tableView.tag = TableStateTYPE_onBottom ;
        selectTable.tableView.scrollEnabled = false;
        selectTable.originalTableFrame = tableView.frame ;
    }

    return selectTable ;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 7;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mapSelectTableCell" ] ;
//    cell.frame.size = CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height / 4) ;

    cell.textLabel.text = @"=    排行    =";
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor blackColor];
    return cell ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    AH_PerformAnimationManager *ah_PAManager = [[AH_PerformAnimationManager alloc] init] ;

    if(indexPath.row == 0 && _tableView.tag == TableStateTYPE_onBottom) {
        _tableView.frame = CGRectMake(0,0 , _tableView.frame.size.width, 650);
        [ah_PAManager performAnimationWithType:kCATransitionMoveIn WithSubType:kCATransitionFromTop withView:_tableView] ;
        _imageView.alpha = 0.5 ;
        [ah_PAManager performAnimationWithType:kCATransitionFade WithSubType:kCATransitionFromTop withView:_imageView] ;
        _tableView.tag = TableStateTYPE_onTOP ;
        _tableView.scrollEnabled = true ;
        _moveTabNavView.hidden = true ;

    }
    else if( _tableView.tag == TableStateTYPE_onTOP) { //indexPath.row == 0 &&

        [ah_PAManager performAnimationWithType:kCATransitionPush WithSubType:kCATransitionFromBottom withView:_imageView] ;

        [ah_PAManager performAnimationWithType:kCATransitionPush WithSubType:kCATransitionFromBottom withView:_tableView] ;

        [ah_PAManager setDuration:1] ;
        [ah_PAManager performAnimationWithType:kCATransitionFade WithSubType:kCATransitionFromBottom withView:_moveTabNavView] ;
        [ah_PAManager setDuration:DURATION_DEFAULT] ;

        _tableView.frame = _originalTableFrame ;

        // CGRectMake(0,450 , _tableView.frame.size.width, 200);
        
        _imageView.alpha = 1 ;
        _tableView.tag = TableStateTYPE_onBottom ;
        _moveTabNavView.hidden = false ;
    }


    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
