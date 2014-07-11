//
//  CrmContact_browseViewController.h
//  itcrm
//
//  Created by itdept on 14-7-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrmContact_browseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISearchBar *is_searchBar;
- (IBAction)fn_advance_search:(id)sender;

@end
