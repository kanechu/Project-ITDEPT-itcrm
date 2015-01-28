//
//  Crmacct_browseViewController.h
//  itcrm
//
//  Created by itdept on 14-6-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Crmacct_browseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView_acct;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
