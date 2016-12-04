//
//  ViewController.m
//  RunningBoy
//
//  Created by 王柏竣 on 2016/11/12.
//  Copyright © 2016年 Croly. All rights reserved.
//

#import "ActViewController.h"
#import "addViewController.h"
#import "ActivityManager.h"
#import "ActivitySQL.h"

@interface ActViewController ()<UITableViewDelegate,UITableViewDataSource,JTCalendarDelegate>
{
    
    NSDate *_todayDate;                 // 今日日期
    NSDate *_minDate;                   // 最小日期
    NSDate *_maxDate;                   // 最大日期
    NSDate *_dateSelected;              // 點擊日期
    NSString * key;                     // calendarView 瀏覽到的日期做成的 KEY 值
    NSArray * keys;                     // 保存所有活動日期作成的 KEY 值
    ActivityManager * aManager ;        // 活動資料 singleton
    
    ActivitySQL * ASQL;
    
}

@end

@implementation ActViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    _calendarManager = [JTCalendarManager new];
    
    _calendarManager.delegate = self;
    
    // 顯示最大最小月份
    [self createMinAndMaxDate];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    
    // 先隱藏 tableView
    self.tableView.hidden = YES;
    
    // 實行 singleton
    aManager = [ActivityManager sharedInstance] ;
    
    // 監聽動作執行 reload
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:NOT_RELOAD object:nil];
    
}

#pragma mark - CalendarManager delegate

// 將日曆所有日期帶入繪製樣式
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // 今日樣式
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
        
        // 是否隱藏 table
        [self showTable:_dateSelected];
        
    }
    // 點選日樣式
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
        
        // 是否隱藏 table
        [self showTable:_dateSelected];
       
    }
    
    // 同月頁面其他月日期樣式
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    // 同月頁面 , 非當日及點選日樣式
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    // 判定是否有活動
    if([self haveEventForDay:dayView.date])
    {
       
        dayView.dotView.hidden = NO;
    
    }   else    {

        dayView.dotView.hidden = YES;

    }

}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // 樣式框架
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    // 點選到月份頁面其他月份日期則轉跳至對應月份頁面
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// 顯示頁面日期
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

// 顯示下一頁日曆
- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

// 顯示上一頁日曆
- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}


// 設定最大及最小可瀏覽月份
- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];

}

// 設定將日期轉成字串形式
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
    
}

// 設定將時間轉成字串形式
- (NSDateFormatter *)timeFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"HH:mm";
    }
    
    return dateFormatter;
    
}

// 判定日曆上日期是否有活動
- (BOOL)haveEventForDay:(NSDate *)date  {
    
    BOOL result = false ;
    
    key = [[self dateFormatter] stringFromDate:date];
    
    keys = [aManager.dayPoint allKeys];
    
    for (int i = 0; i < keys.count; i++) {
        
        if ([key isEqualToString:keys[i]]) {
            
            return YES;
            
        }
        
    }
    
    return result ;
    
}

// 判定日期是否有活動 , 無活動則隱藏 table
-(void) showTable:(NSDate*) date
{

    key = [[self dateFormatter] stringFromDate:date];
    
    keys = [aManager.dayPoint allKeys];
    
    for (int i = 0; i < keys.count; i++) {
        
        if ([key isEqualToString:keys[i]]) {
            
            self.tableView.hidden = NO;
            
            break;
            
        } else  {
            
            self.tableView.hidden = YES;
            
        }
        
    }
    
    [_tableView reloadData];
    
}

// 顯示 table 列數
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;

}

// 顯示 table 行數
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString * selected = [[self dateFormatter] stringFromDate:_dateSelected];
    
    if (!(aManager.dayPoint[selected])) {
        _tableView.hidden = true ;
        return 0;
    }
    
    _tableView.hidden = false ;
    return [aManager.dayPoint[selected] count];
    
}

// 顯示 cell 內容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSString * selected = [[self dateFormatter] stringFromDate:_dateSelected];
    
    
    NSString * time = [[self timeFormatter] stringFromDate:[aManager.dayPoint[selected][indexPath.row] activityDate]];
    
    NSString * friend = [aManager.dayPoint[selected][indexPath.row] activityName];
    
    NSString * level = [aManager.dayPoint[selected][indexPath.row] activityLevel];
    
    NSString * title = [NSString stringWithFormat:@"%@ 與 %@ 遊玩 %@ ",time,friend,level];
    
    cell.textLabel.text = title;
    
    return cell;
    
}

// 點選 cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    aManager.comefromtab = true;
    
    // 創造編輯界面
    addViewController * editvc = [self.storyboard instantiateViewControllerWithIdentifier:@"addViewController"];
    
    aManager.selecte = [[self dateFormatter] stringFromDate:_dateSelected];
    
    aManager.rows = indexPath.row;
    
    editvc.editName = [aManager.dayPoint[aManager.selecte][aManager.rows]activityName];
    
    editvc.editLevel = [aManager.dayPoint[aManager.selecte][aManager.rows]activityLevel];
    
    [self showViewController:editvc sender:nil];
   
}

// 刪除 cell 資料
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString * selected = [[self dateFormatter] stringFromDate:_dateSelected];
    
    aManager.act_id = [aManager.dayPoint[selected][indexPath.row] actvityID];
    
    NSLog(@"~~~~~~~~~~~~~~~~~~%@",[aManager.dayPoint[selected][indexPath.row] actvityID]);
    
    
    // 移除 Array 資料
    [aManager.dayPoint[selected] removeObject:aManager.dayPoint[selected][indexPath.row]];
   
    [[ActivitySQL sharedInstance] delecteAct];
    
    // 確認 Dictionary 是否內容為空 , 為空即刪除 , 使日曆打點正確
    if ([aManager.dayPoint[selected] count] == 0 )
    {
     
        [aManager.dayPoint removeObjectForKey:selected];
    
    }
    
    [self reload];
  
}
// reload 畫面
-(void) reload
{
    
    [_tableView reloadData];
    
    [_calendarManager reload];
    
}

// 關閉監聽模式
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:@"cc"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    ASQL = [ActivitySQL sharedInstance];
    
    [self reload];
    
}

@end
