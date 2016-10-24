//
//  RunningViewController.h
//  RunningMap_LevelMap
//
//  Created by NO KR on 2016/10/9.
//  Copyright © 2016年 aHom. All rights reserved.
//

#import "ViewController.h"
#import "MZTimerLabel.h"

@interface RunningViewController : ViewController <MZTimerLabelDelegate>{
    MZTimerLabel *mzStopWatchLabel ;
    MZTimerLabel *mzCountingDownLabel;
}

@end
