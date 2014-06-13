//
//  MaintTaskViewController.h
//  itcrm
//
//  Created by itdept on 14-6-13.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@interface MaintTaskViewController : UIViewController<SKSTableViewDelegate>
@property (nonatomic,strong)NSMutableArray *alist_miantTask;
//过滤后的数组
@property (nonatomic,strong)NSMutableArray *alist_filtered_taskdata;
@property (nonatomic,strong)NSMutableArray *alist_groupNameAndNum;

@property (weak, nonatomic) IBOutlet SKSTableView *skstableview;

@end
