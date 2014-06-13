//
//  ActivityViewController.h
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Format_conversion;
@class DB_crmtask_browse;
@interface ActivityViewController : UITableViewController<UISearchBarDelegate>
@property(nonatomic,strong)Format_conversion *format;
@property(nonatomic,strong)DB_crmtask_browse *db_crmtask;
@property(nonatomic,strong)NSMutableArray *alist_crmtask;
- (IBAction)fn_advance_search_task:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *is_searchbar;

@end
