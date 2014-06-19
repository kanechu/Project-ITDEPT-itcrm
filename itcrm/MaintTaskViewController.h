//
//  MaintTaskViewController.h
//  itcrm
//
//  Created by itdept on 14-6-13.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@interface MaintTaskViewController : UIViewController<SKSTableViewDelegate,UITextViewDelegate>
@property (nonatomic,strong)NSMutableArray *alist_miantTask;
//过滤后的数组
@property (nonatomic,strong)NSMutableArray *alist_filtered_taskdata;
@property (nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
@property (nonatomic,strong)UITextView *checkTextView;
@property (nonatomic,strong)NSMutableDictionary *idic_parameter_value;
@property (nonatomic,strong)Format_conversion *format;
@property (weak, nonatomic) IBOutlet SKSTableView *skstableview;

@end
