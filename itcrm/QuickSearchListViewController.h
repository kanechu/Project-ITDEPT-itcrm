//
//  QuickSearchListViewController.h
//  itcrm
//
//  Created by itdept on 15/3/11.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickSearchListViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *alist_browse_data;
- (void)fn_refresh_listView;
@end
