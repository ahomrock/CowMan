//
//  HistoryViewController.m
//  
//
//  Created by NO KR on 2016/10/16.
//
//

#import "HistoryViewController.h"
#import "HistoryDataManager.h"
#import "MapRecordViewController.h"

@interface HistoryViewController ()<UITabBarDelegate,UITableViewDataSource> {
    HistoryDataManager *historyDataManager ;
}


@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    historyDataManager = [HistoryDataManager sharedInstance] ;
    [historyDataManager addObserver:self forKeyPath:@"message" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld  context:nil] ;
    self.tableView.backgroundColor = [UIColor blackColor] ;
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    [_tableView reloadData] ;
}



-(void)dealloc {
    [historyDataManager removeObserver:self forKeyPath:@"message" context:nil] ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return historyDataManager.historyPoints.count + 1 ;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell ;

    if(indexPath.row == 0 ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopCell" ];

        UIImage *image = [UIImage imageNamed:@"HistoryPIC.png"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image] ;
        [cell addSubview:imageView];
        cell.frame = imageView.frame ;
        cell.backgroundColor = [UIColor blackColor];
    }
    else {
        cell =
        [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"historyTableCell" ] ;
    //    cell.frame.size = CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height / 4) ;


        NSString *historyTitle = [NSString stringWithFormat:@"%@ : %@",[ historyDataManager.historyPoints[indexPath.row-1] mapTitle],[ historyDataManager.historyPoints[indexPath.row-1] totalTime]] ;
        cell.textLabel.text = historyTitle;
        cell.textLabel.textColor = [UIColor whiteColor];

        cell.backgroundColor = [UIColor blackColor];
    }

    return cell ;


}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 )
        return 400 ;
    return 100 ;
}


// 當 tableview 被點到第幾個 section 的第幾個 row 時，會透過 delegate 觸發這個方法。你可以從這個方法裡去回應接下來的行為。
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"我被點到了第 %lu 個列",indexPath.row);

    // 取消選擇的灰底顏色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 準備下一頁的畫面
    if ( indexPath.row != 0 ) {
        MapRecordViewController * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MapRecordViewController"];

        historyDataManager.selectPoint = historyDataManager.historyPoints [indexPath.row-1];
        [self showViewController:mapVC sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
