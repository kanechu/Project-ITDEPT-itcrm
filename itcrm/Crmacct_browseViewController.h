//
//  Crmacct_browseViewController.h
//  itcrm
//
//  Created by itdept on 14-6-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Format_conversion;
@class DB_crmacct_browse;
@interface Crmacct_browseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) Format_conversion *format;
@property (nonatomic,strong) NSMutableArray *ilist_account;
@property (nonatomic,strong) DB_crmacct_browse *db_acct;

@property (weak, nonatomic) IBOutlet UITableView *tableView_acct;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)fn_advance_search:(id)sender;

@end
