//1111111111
//  addViewController.m
//  RunningBoy
//
//  Created by 王柏竣 on 2016/11/12.
//  Copyright © 2016年 Croly. All rights reserved.
//

#import "addViewController.h"
#import "ViewController.h"
#import "ActivityManager.h"
#import "NSMutableArray+SortByKey.h"
#import "ActivitySQL.h"

@interface addViewController () {
    
    ActivityManager *aManager ;
    
}
@property (weak, nonatomic) IBOutlet UITextField *friendName;
@property (weak, nonatomic) IBOutlet UITextField *levelName;
@property (nonatomic,strong) NSDate * date;
@property (nonatomic,strong) NSString * dateKey;                    // Dictionary key值


@end

@implementation addViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    aManager = [ActivityManager sharedInstance] ;
    
    _friendName.text = _editName;
    
    _levelName.text = _editLevel;
 
}

- (IBAction)activityTime:(id)sender
{
    
     _date = [sender date];

}

- (IBAction)save:(id)sender
{
    
    NSMutableArray * pointArray;
    
    // 判斷資料是否皆填
    if (_friendName.text.length < 1 || _levelName.text.length < 1 )
    {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"錯誤" message:@"有選項未填唷" preferredStyle:UIAlertControllerStyleAlert] ;
        
        UIAlertAction * error = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:error] ;
        
        [self presentViewController:alert animated:true completion:nil];
        
    }   else    {
        
        if (aManager.comefromtab == true)
        {
            [aManager.dayPoint[aManager.selecte] removeObject:aManager.dayPoint[aManager.selecte][aManager.rows]];
            
                if ([aManager.dayPoint[aManager.selecte] count] == 0 )
                {
            
                    [aManager.dayPoint removeObjectForKey:aManager.selecte];
                
                    [[ActivitySQL sharedInstance] delecteAct];
                    
                }
            
        }
        
        // 給予 datePicker 初始值
        if (!_date)
        {
            
            _date = [NSDate date];
            
        }
        
        _dateKey = [[self dateFormatter] stringFromDate:_date];
        
        ActivityPoint * point = [[ActivityPoint alloc] initWithName:_friendName.text withLevel:_levelName.text withDate:_date withKey:_dateKey withID:ACT_ID];
        
        
        aManager.act_friend = _friendName.text;
        aManager.act_level = _levelName.text;
        aManager.act_date = _date;
        aManager.act_key = _dateKey;
        
        
        // 判定 Array 是否已開
        if (!aManager.dayPoint[_dateKey])
        {
            
            pointArray = [NSMutableArray new];
            
        }    else    {
            
            pointArray = aManager.dayPoint[_dateKey];
            
        }
        
        [pointArray addObject:point] ;
        
        // 依照日期排序 Array
        pointArray = [pointArray sortByKey:ACTIVITY_DATE_KEY withArray:pointArray] ;
        
        [aManager.dayPoint setObject:pointArray forKey:_dateKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOT_RELOAD object:nil];
        
        [[ActivitySQL sharedInstance] savePoint];
        
        [self.navigationController popViewControllerAnimated:true] ;
        
    }
    
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

// 縮鍵盤
- (IBAction) textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    aManager.comefromtab = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
