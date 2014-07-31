//
//  CrmTask_browseViewController.h
//  itcrm
//
//  Created by itdept on 14-6-23.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CrmTask_browseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISearchBar *is_searchbar;
- (IBAction)fn_advance_search_task:(id)sender;

@end
