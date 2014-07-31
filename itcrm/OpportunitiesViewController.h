//
//  OpportunitiesViewController.h
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpportunitiesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISearchBar *is_searchBar;
- (IBAction)fn_advance_search_opp:(id)sender;

@end
