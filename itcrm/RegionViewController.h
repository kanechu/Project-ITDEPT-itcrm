//
//  RegionViewController.h
//  itcrm
//
//  Created by itdept on 14-6-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegionViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *ilist_region;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)fn_return_acctSearch:(id)sender;

@end
