//
//  OpportunitiesViewController.h
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Format_conversion;
@interface OpportunitiesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)Format_conversion *format;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *alist_crmopp_browse;

@end
