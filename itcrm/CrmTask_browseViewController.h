//
//  CrmTask_browseViewController.h
//  itcrm
//
//  Created by itdept on 14-6-23.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Format_conversion;
@class DB_crmtask_browse;
@interface CrmTask_browseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property(nonatomic,strong)Format_conversion *format;
@property(nonatomic,strong)DB_crmtask_browse *db_crmtask;
@property(nonatomic,strong)NSMutableArray *alist_crmtask;
@property(nonatomic,strong)NSMutableArray *alist_crmtask_parameter;
@property(nonatomic,strong)UIImage *task_icon;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISearchBar *is_searchbar;
- (IBAction)fn_advance_search_task:(id)sender;

@end
